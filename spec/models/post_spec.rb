require 'spec_helper'

describe Post do
  include DeliverableSpecs
 
  describe "when delivered_as post" do
  
    it "includes the post definition" do
      described_class.included_modules
        .should include(Transit::Definition::Post)
    end
    
    ['title', 'slug', 'teaser'].each do |field|

      it "creates a field for #{field}" do
        described_class.fields.keys
          .should include(field)
      end
    end
    
    it 'applies the publishing extension' do
      described_class.included_modules
        .should include(Transit::Extension::Publishing)
    end
    
    ['publish_date', 'published'].each do |field| 
      
      it "creates a field for #{field}" do
        described_class.fields.keys
          .should include(field)
      end
    end
  end  
  
  describe "validations" do

    it 'validates a title exists' do
      Post.should validate_presence_of(:title)
    end
  end
    
  
  describe "publishing posts" do
    
    let!(:post) do
      Post.make!(
        :title => "a sample post"
      )
    end
    
    context "when un-published" do
      
      it "does not generate a slug from the title" do
        post.slug.should be_nil
      end
    end
    
    context "when published" do

      describe 'then generated slug' do
        
        context 'when the default interpolation method' do
          
          before do
            post.update_attribute(:published, true)
          end

          it "generates a slug from the post title" do
            post.slug.should(
              eq(post.title.to_slug)
            )
          end
        end
        
        context 'when a custom interpolation method' do
          
          before do
            Post.send(
              :deliver_with, 
              :slugability => ':month/:title'
            )
            post.update_attribute(:published, true)
          end
          
          it 'generates a slug from the custom interpolation' do
            post.slug.should(
              eq "#{post.publish_date.month}/#{post.title.to_slug}"
            )
          end
        end
      end
    end
  end
end