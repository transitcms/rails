require 'spec_helper'

describe 'String extensions' do
  
  describe '.to_slug' do
    
    it 'sanitizes a string into a url format' do
      "Some String".to_slug.should == "some-string"
    end
    
    it 'removes invalid characters' do
      "Some ^(String".to_slug.should == "some-string"
    end
    
    it 'removes extra whitespace' do
      "Some      String".to_slug.should == "some-string"
    end
    
  end
  
end