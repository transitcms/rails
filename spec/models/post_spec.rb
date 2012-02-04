require 'spec_helper'

describe Post do
  include DeliverableSpecs
 
  describe "when delivered_as post" do
  
    it "includes the post definition" do
      described_class.included_modules.should include(Transit::Definition::Post)
    end
    
    it "applies the post fields" do
      ['title', 'slug', 'teaser'].each do |field| 
        described_class.fields.keys.should include(field)
      end
    end
    
    it 'applies the publishing extension' do
      described_class.included_modules.should include(Transit::Extension::Publishing)
    end
    
    it 'applies the publishing fields' do
      ['publish_date', 'published'].each do |field| 
        described_class.fields.keys.should include(field)
      end
    end
  
  end  
  
  describe "validations" do

    it{ Post.should validate_presence_of(:title) }
    
  end
    
  
  describe "publishing posts" do
    
    let!(:post) do
      @_post ||= Post.make!(:title => "a sample post")
    end
    
    context "when un-published" do
      
      it "does not generate a slug from the title" do
        post.slug.should be_nil
      end
      
    end
    
    context "when published" do

      before(:all) do
        post.update_attribute(:published, true)
      end

      it "generates a slug from the title" do
        post.slug.should eq(post.title.to_slug)
      end    
      
    end # end when published
   
  end
  
  
end