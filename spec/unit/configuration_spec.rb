require 'spec_helper'

describe "Transit configuration" do
  
  describe ".config" do
    
    it "has a config method" do
      Transit.respond_to?(:config).should be_true
    end
  
    it "initializes a configuration class" do
      Transit.config.should be_a(Transit::Configuration)
    end

  end
  
  describe "configuration options" do
    
    subject do
      Transit.config
    end
    
  end
  
end