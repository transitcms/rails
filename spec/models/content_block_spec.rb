require 'spec_helper'

describe ContentBlock do
  
  it "embeds many contexts" do
    should embed_many(:contexts)
  end
  
end