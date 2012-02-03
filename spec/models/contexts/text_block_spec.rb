require 'spec_helper'

describe TextBlock do
  
  it{ should be_embedded_in(:deliverable) }
  
  describe 'body' do
    
    it 'is an instance of the HtmlContent class' do
      TextBlock.new.body.should be_a(HtmlContent)
    end
    
  end
  
end