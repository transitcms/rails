require 'spec_helper'

describe "Extensions" do
  
  describe "Loader" do
    
    describe 'extension methods' do

      it "includes .deliver_with" do
        Post.respond_to?(:deliver_with)
          .should be_true
      end
    
      it "alias's .add_extension" do
        Post.respond_to?(:add_extension)
          .should be_true
      end
    end
  end
  
  describe 'adding extensions' do
    
    context 'when the extension is found' do
      
      before do
        Post.send(
          :deliver_with, :publishing
        )
      end
      
      let(:extname) do
        Transit::Extension::Publishing
      end
      
      it 'extends the model with the specified extension' do
        Post.included_modules
          .should include(extname)
      end
    end
    
    context 'when the extension is missing' do
      
      let(:missing) do
        lambda do
          Post.send(:deliver_with, :nothing)
        end
      end
      
      it 'raises a MissingExtensionError' do
        expect{ 
          missing.call 
        }.to raise_error(
          Transit::Extension::MissingExtensionError
        )
      end 
    end
  end
  
  
  describe "configuring extensions" do
    
    context 'when extensions are passed as a hash' do

      before do
        Post.send(
          :deliver_with, 
          :slugability => ":title"
        )
      end
    
      it 'assigns the options to the model delivery_options' do
        Post.delivery_options_for(:slugability)
          .should eq ':title'
      end
    end
  end  
end