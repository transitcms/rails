require 'spec_helper'

describe "A Deliverable" do
  
  class Deliverable
    include Transit::Deliverable
    deliver_as :post, :translate => true
  end
  
  subject do
    Deliverable
  end
  
  describe 'Transit.deliverables' do
    
    let(:reg) do
      Transit.deliverables['Post']
    end
    
    it 'should be an array' do
      reg.should
        be_a(Array)
    end
    
    it 'should include models which are deliverable' do
      reg.should include('Deliverable')
    end
  end
  
  describe 'extending including models' do
    
    it 'add a delivery_options attribute' do
      subject.respond_to?(
        :delivery_options
      ).should be_true
    end
    
    it 'includes options passsed from deliver_as' do
      subject.delivery_options
        .translate.should be_true
    end
  end
  
  describe "translation" do
    
    context "when :translate => true is passed to deliver_as" do
      
      it "enables translations" do
        TranslatedPost.has_translation_support
          .should be_true
      end
    end
    
    context "when :translate is not passed to deliver_as" do
      
      context "when translations are enabled globally" do
        
        before do
          Transit.config.translate = true
          Page.delivery_options = nil
          Page.send(:deliver_as, :page)
        end
        
        it 'enables translations' do
          Page.has_translation_support
            .should be_true
        end
        
        it 'adds :localize => true to fields' do
          TranslatedPage.new
            .respond_to?(:name_translations)
            .should be_true
        end
      end
      
      context "when translations are not enabled globaly" do
        
        before do
          Transit.config.translate = false
          Page.delivery_options = nil
          Page.send(:deliver_as, :page)
        end
        
        it 'does not enable translations' do
          Page.has_translation_support
            .should be_false
        end
        
        it 'does not add :localize => true to fields' do
          Page.new.respond_to?(:name_translations)
            .should be_false
        end
      end
    end
  end
  
  describe "creating contexts" do
    
    context "when a new record" do
      
      let!(:post) do
        Post.make
      end
      
      context 'and passed contexts_attributes' do
        
        before do
          post.contexts_attributes = { 
            "0" => { 
              "_type" => "TextBlock", 
              "body"  => "Sample text body" 
            }
          }
          post.save
        end
        
        it 'adds a new context' do
          post.contexts
            .count.should eq 1
        end
        
        it 'adds a context of the specified _type' do
          post.contexts.first
            .should be_a(TextBlock)
        end
      end
    end
    
    context "when an existing record" do
      
      let!(:post) do
        Post.make!
      end
      
      context 'and passed contexts_attributes' do
        
        before do
          post.contexts_attributes = { 
            "0" => { 
              "_type" => "TextBlock", 
              "body"  => "Sample text body" 
            }
          }
          post.save
        end
        
        it 'adds a new context' do
          post.contexts
            .count.should eq 1
        end
        
        it 'adds a context of the specified _type' do
          post.contexts.first
            .should be_a(TextBlock)
        end
      end
    end
      
    context "when previous contexts exist" do
      
      let!(:post) do
        Post.make!(
          :contexts_attributes => {
            "0" =>{
              "_type" => "TextBlock", 
              "body"  => "Sample text body"
            }
          }
        )
      end
      
      before do
        post.contexts_attributes = { 
          "0" => {
            "_type" => "HeadingText",
            "body"  => "This is a heading"
          }
        }
        post.save
      end
        
      it 'adds new contexts' do
        post.contexts
          .count.should eq 2
      end
      
      it "assigns the proper STI class to the context" do
        post.contexts.last
          .should be_a HeadingText
      end
    end
    
    context "when contexts_attributes is for an existing context" do
      
      let!(:post) do
        Post.make!(
          :contexts_attributes => { 
            "0" => { 
              "_type" => "TextBlock", 
              "body"  => "Sample text body" 
            }
          }
        )
      end
   
      let(:context) do 
        post.contexts
          .first
      end
      
      let(:attrs) do
        {
          :contexts_attributes => { 
            "0" => { 
              "id"    => context.id.to_s, 
              "_type" => "TextBlock", 
              "body"  => "Sample text body" 
            }
          }
        }
      end

      it 'updates the existing context' do
        expect{
          post.update_attributes(attrs)
        }.to_not change(
          post.contexts, :count
        )
      end
      
      context 'and the attributes contain _destroy' do
        
        let!(:post) do
          Post.make!(
            :contexts_attributes => { 
              "0" => { 
                "_type" => "TextBlock", 
                "body"  => "Sample text body" 
              }
            }
          )
        end
      
        let(:context) do 
          post.contexts.first
        end
        
        context 'and _destroy evaluates true' do
          
          let(:attrs) do
            { :contexts_attributes => { 
                "0" => { 
                  "id"       => context.id.to_s, 
                  "_destroy" => 'true'}
            }}
          end
          
          it 'removes the context' do
            expect{
              post.update_attributes(attrs)
            }.to change(
              post.contexts, :count
            ).by(-1)
          end
        end
        
        context 'and _destroy evaluates false' do
          
          let(:attrs) do
            { :contexts_attributes => { 
                "0" => { 
                  "id"       => context.id.to_s, 
                  "_destroy" => 'false'}
            }}
          end
          
          it 'does not remove the context' do
            expect{
              post.update_attributes(attrs)
            }.to_not change(
              post.contexts, :count
            )
          end
        end
      end
    end
  end
end