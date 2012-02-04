require 'spec_helper'

describe "Extensions" do
  
  describe "Loader" do
    
    it "creates a deliver_with method for activating extensions" do
      Post.respond_to?(:deliver_with).should be_true
    end
    
    it "creates an add_extension alias for activating extensions" do
      Post.respond_to?(:add_extension).should be_true
    end
    
  end
  
  describe 'adding extensions' do
    
    context 'when the extension is found' do
      
      before do
        Post.send(:deliver_with, :publishing)
      end
      
      it 'extends the model' do
        Post.included_modules.should include(Transit::Extension::Publishing)
      end
      
    end # found extensions
    
    context 'when the extension is missing' do
      
      it 'raises a MissingExtensionError' do
        lambda{ Post.send(:deliver_with, :nothing) }.should
          raise_error(Transit::Extension::MissingExtensionError)
      end
      
    end # missing extensions
    
  end # extensions
  
  
end