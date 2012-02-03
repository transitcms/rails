require 'spec_helper'

describe Asset do

  it "includes Paperclip::Glue" do
    described_class.included_modules.should include(Paperclip::Glue)
  end
  
  it{ should belong_to(:deliverable) }
  
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

end