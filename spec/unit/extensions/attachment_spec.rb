require 'spec_helper'

describe "the Attachment extension" do
  
  class Deliverable
    include Transit::Deliverable
    deliver_as :post, :translate => true
    deliver_with :attachments
  end
  
  subject do
    Deliverable.new
  end
  
  it "adds the `attach` class method" do
    Deliverable.respond_to?(:attach).should be_true
  end
  
  describe "attaching files" do
    
    before(:all) do
      Deliverable.send(:attach, :test_file, {})
    end
    
    it "generates the necessary fields for the attachment" do
      Deliverable.fields.keys.should include('test_file_file_name', 'test_file_content_type', 'test_file_file_size', 'test_file_updated_at')
    end
    
  end
  
end