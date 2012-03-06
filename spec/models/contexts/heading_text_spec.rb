require 'spec_helper'

describe HeadingText do
  
  describe 'as a class' do

    it 'provides a list of heading nodes' do
      HeadingText.respond_to?(:node_types).should be_true
      HeadingText.node_types.should be_a(Array)
      HeadingText.node_types.first.should == ['Heading 1', 'h1']
    end
    
  end
  
  describe 'any instance' do

    let(:heading) do
      HeadingText.new
    end
    
    it 'provides a list of heading nodes' do
      heading.respond_to?(:node_types).should be_true
      heading.node_types.should be_a(Array)
      heading.node_types.first.should == ['Heading 1', 'h1']
    end
    
    
  end
  
end