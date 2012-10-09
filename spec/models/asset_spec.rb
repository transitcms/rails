require 'spec_helper'

describe Asset do
  
  before(:all) do
    Paperclip.options[:log] = false
  end
  
  let(:fixture) do
    File.open(File.join(File.expand_path('../../fixtures', __FILE__), 'image.jpg'))
  end
  
  after(:all) do
    Paperclip.options[:log] = true
  end
  
  it "includes Paperclip::Glue" do
    described_class.included_modules.should include(Paperclip::Glue)
  end
  
  it 'belongs to a deliverable' do
    Asset.should belong_to(:deliverable)
  end
  
  describe 'on create' do
    
    context 'when a name was not set' do
      
      let!(:asset) do
        Asset.create(
          :file => fixture
        )
      end
      
      it 'sets the name from the file name' do
        asset.name.should eq('image.jpg')
      end
    end
    
    context 'when the name is blank' do
      
      let!(:asset) do
        Asset.create(
          :file => fixture,
          :name => ""
        )
      end
      
      it 'sets the name from the file name' do
        asset.name.should eq('image.jpg')
      end
    end
    
    context 'when a name was set' do
      
      let!(:asset) do
        Asset.create(
          :name => 'asset',
          :file => fixture
        )
      end
      
      it 'uses the defined name' do
        asset.name
          .should eq 'asset'
      end
    end
  end
  
  describe "identificaton" do
    
    subject do
      Asset.new(attrs)
    end
    
    context "when an image" do

      let(:attrs) do
        { :file_content_type => 'image/jpeg' }
      end
      
      it "image? should be true" do
        subject.image?.should be_true
      end
      
      it "should not be audio" do
        subject.audio?.should be_false
      end
      
      it "should not be video" do
        subject.video?.should be_false
      end
    end
    
    context "when a video" do
      
      let(:attrs) do
        { :file_content_type => 'video/mp4' }
      end
      
      it "should be a video" do
        subject.video?.should be_true
      end
      
      it "should not be audio" do
        subject.audio?.should be_false
      end
      
      it "should not be an image" do
        subject.image?.should be_false
      end
    end
    
    context "when an audio file" do
      
      let(:attrs) do
        { :file_content_type => 'audio/mp3' }
      end
      
      it "should be audio" do
        subject.audio?.should be_true
      end
      
      it "should not be a video" do
        subject.video?.should be_false
      end
      
      it "should not be an image" do
        subject.image?.should be_false
      end
    end
  end
  
  describe 'grouping assets' do
    
    context 'when configured to store in groups' do
      
      before(:all) do
        Transit.configure do |conf|
          conf.assets.store_in_groups = true
        end
      end
      
      after do
        asset.destroy
        AssetGroup.destroy_all
      end
      
      context 'when no groups exist' do
        
        before do
          AssetGroup.destroy_all
        end
        
        let!(:asset) do
          Asset.create(
            :name => 'In group',
            :file => fixture
          )
        end
      
        it 'creates a default group for the asset' do
          asset.group.should_not be_nil
        end
      
        it 'creates a root group for storage' do
          asset.group.is_root?
            .should be_true
        end
      
        it 'includes the group in serialization' do
          asset.as_json.keys
            .should include(:group)
        end
      end
      
      context 'when a root group exists' do
        
        before do
          AssetGroup.create(:name => '_root')
        end
        
        let!(:asset) do
          Asset.create(
            :name => 'In group',
            :file => fixture
          )
        end

        it 'stores the asset in the existing group' do
          asset.group.name
            .should eq '_root'
        end
      end
      
      context 'when the asset is already assigned to a group' do
        
        let!(:asset) do
          Asset.create(
            :name   => 'In group',
            :file   => fixture,
            :group  => AssetGroup.create(:name => 'folder')
          )
        end
        
        it 'stores the asset in the assigned group' do
          asset.group.name
            .should eq 'folder'
        end
      end
    end
    
    context 'when not configured to store in groups' do
      
      before(:all) do
        Transit.configure do |conf|
          conf.assets.store_in_groups = false
        end
      end
      
      let!(:asset) do
        Asset.create(
          :name => 'In group',
          :file => fixture
        )
      end
      
      it 'does not create a default group' do
        asset.group.should be_nil
      end
      
      it 'does not include the group in serialization' do
        asset.as_json.keys
          .should_not include(:group)
      end
    end
  end

end