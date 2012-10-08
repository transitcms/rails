require 'spec_helper'

describe AssetGroup do
  
  describe 'assocations' do
    
    it 'has many assets' do
      should have_many(:assets)
    end
  end
  
  describe '.default' do
    
    let(:group) do
      AssetGroup.default
    end
    
    context 'when no groups exist' do
      
      before do
        AssetGroup.destroy_all
      end
      
      it 'creates a default root group' do
        group.name.should eq('Uploads')
      end
      
      it 'names the default group using config.assets.default_group_name' do
        group.name.should eq(
          Transit.config.assets.default_group
        )
      end
    end
    
    context 'when a root group already exists' do
      
      before do
        AssetGroup.destroy_all
        AssetGroup.create(:name => 'default')
      end
      
      it 'returns the existing group' do
        group.name.should eq 'default'
      end
    end
  end
end