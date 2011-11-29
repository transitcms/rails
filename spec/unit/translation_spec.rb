require 'spec_helper'

describe "Translated deliverables" do
  
  subject do
    TranslatedPost
  end
  
  it "includes the translations module" do
    subject.included_modules.should include(Mongoid::Globalize)
  end
  
  it "embeds many translations" do
    subject.should embed_many(:translations)
  end
  
  describe "proxying methods" do
    
    subject do
      TranslatedPost.new
    end
    
    
    context "when translating" do
    
      before(:all) do
        @post = TranslatedPost.new
        @post.title = "English title"
        @post.save(:validate => false)
      end
    
      let(:post) do
        @post
      end
    
      context "with the default :en locale" do
      
        it "uses the default field for its data" do
          post.title.should == "English title"
        end
      
      end
    
      context "with a :mx locale" do
        
        before(:all) do
          I18n.locale = :mx
          @post.title = "Spanish title"
          @post.save(:validate => false)
          @post = @post.reload
        end
        
        it "uses the proxied translation for its data" do
          post.title.should == "Spanish title"
        end
        
        it "adds a translation for the specified locale" do
          post.translations.count.should_not == 0
        end
        
        context "when switching locale" do
          
          before(:all) do
            I18n.locale = :en
          end
          
          it "reverts to the default data" do
            post.title.should == "English title"
          end
          
        end
        
      end
    
    end
    
  end
  
end