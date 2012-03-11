require 'spec_helper'

describe ContentBlock do
  
  it 'embeds many contexts' do
    described_class.should embed_many(:contexts)
  end
  
end