require 'spec_helper'

describe 'HTMLContent' do
  
  describe 'as a mongoid field' do
    
    it 'functions as a string' do
      TextBlock.new(:body => "test").body.acts_like?(:string).should be_true
    end
    
  end
  
end