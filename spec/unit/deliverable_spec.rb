require 'spec_helper'

describe "A Deliverable" do
  
  class Deliverable
    include Transit::Deliverable
    deliver_as :post, :translate => true
  end
  
  subject do
    Deliverable
  end
  
  describe "delivery options" do
    
    it "creates a delivery_options class attribute" do
      subject.respond_to?(:delivery_options).should be_true
    end
    
    it "assigns options when setting the deliverable type" do
      subject.delivery_options.respond_to?(:translate).should be_true
      subject.delivery_options.translate.should be_true
    end
    
    
    
  end
  
end