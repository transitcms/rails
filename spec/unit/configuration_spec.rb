require 'spec_helper'

describe "Transit configuration" do
  
  describe ".config" do
    
    it "has a config method" do
      Transit.respond_to?(:config).should be_true
    end
    
    it 'includes default properties' do
      Transit.config.translate.should_not be_nil
    end

  end
  
end