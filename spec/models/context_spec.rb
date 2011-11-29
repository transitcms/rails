require 'spec_helper' 

describe Context do
  
  it "is embedded in a deliverable" do
    should be_embedded_in(:deliverable)
  end

  
end