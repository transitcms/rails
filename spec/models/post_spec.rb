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
  
  describe "validations" do
    
    subject do
      Post
    end
    
    it{ should validate_presence_of(:title) }
    it{ should validate_presence_of(:post_date) }
    
  end
  
  describe "published scope" do
   
    before(:all) do
      Post.make!(:post_date => 1.year.ago.to_time, :published => true)
      Post.make!(:post_date => 1.year.from_now.to_time, :published => true)
      Post.make!(:post_date => 1.year.ago.to_time, :published => false)
    end
    
    it "only finds posts which are published and older than today" do
      Post.published.count == 1
    end
    
  end
  
  describe "post properties" do
    
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