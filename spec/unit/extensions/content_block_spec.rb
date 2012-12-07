require 'spec_helper'

describe "the Content Block extension" do
  
  class Deliverable
    include Transit::Deliverable
    deliver_as :post, :translate => true
    deliver_with :content_blocks
  end
  
  subject do
    Deliverable.new
  end
  
  it "adds the `attach` class method" do
    subject.respond_to?(:content_blocks).should be_true
  end
  
  it 'associates the content block class' do
    Deliverable.should have_and_belong_to_many :content_blocks
  end
end