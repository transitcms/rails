require 'spec_helper'

describe Post do
  include DeliverableSpecs
 
  
  describe "when delivered_as post" do
  
    it "includes the post definition" do
      described_class.included_modules.should include(Transit::Definition::Post)
    end
    
    it "applies the post fields" do
      ['title', 'post_date', 'slug', 'teaser', 'published'].each do |field| 
        described_class.fields.keys.should include(field)
      end
    end
  
  end  
  
  
end