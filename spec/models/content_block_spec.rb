require 'spec_helper'

describe ContentBlock do
  
  it 'embeds many contexts' do
    ::ContentBlock.should embed_many(:contexts)
  end
  
end