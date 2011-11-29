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
  
end