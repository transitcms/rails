require 'spec_helper'

describe "Extensions" do
  
  describe "Loader" do
    
    describe 'extension methods' do

      it "includes .deliver_with" do
        Post.respond_to?(:deliver_with).should be_true
      end
    
      it "alias's .add_extension" do
        Post.respond_to?(:add_extension).should be_true
      end
    
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
  
  
  describe "configuring extensions" do
    
    before do
      Post.send(:deliver_with, :publishing)
    end
    
    it 'adds configuration options to the model' do
      
    end
    
  end # configuring
  
end