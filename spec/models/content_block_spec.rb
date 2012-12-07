require 'spec_helper'

describe 'ContentBlock' do
  
  Page.class_eval do
    deliver_with :content_blocks
  end
  
  let!(:page) do
    Page.new
  end
  
  it 'embeds many contexts' do
    ContentBlock.should(
      embed_many(:contexts)
    )
  end
  
  context 'when creating contexts inside of a deliverable' do
    
    let!(:cblock) do
      ContentBlock.create(
        :name => 'block_text'
      )
    end
    
    let(:heading) do
      {
        :node => 'h1', 
        :body => "Headline!"
      }
    end
    
    before do
      page.content_blocks.delete_all
      cblock.contexts.create(heading, HeadingText)
      page.content_blocks << cblock
    end
    
    it 'should create contexts for the block' do
      cblock.contexts.count
        .should_not eq 0
    end
    
    it 'should embed the contexts in the block' do
      page.content_blocks.first.contexts
        .count.should_not eq 0
    end
  end

end