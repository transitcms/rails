require 'spec_helper'

describe "A Deliverable" do
  
  class Deliverable
    include Transit::Deliverable
    deliver_as :post, :translate => true
  end
  
  subject do
    Deliverable
  end
  
  it 'registers itself on Transit.deliverables' do
    Deliverable
    Transit.deliverables['Post'].should be_a(Array)
    Transit.deliverables['Post'].should include('Deliverable')
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
  
  describe "translation" do
    
    context "when :translate => true is passed to deliver_as" do
      
      it "enables translations" do
        TranslatedPost.has_translation_support.should be_true
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
          Page.has_translation_support.should be_true
        end
        
        it 'adds :localize => true to fields' do
          TranslatedPage.new.respond_to?(:name_translations).should be_true
        end
        
      end # global translations
      
      context "when translations are not enabled globaly" do
        
        before do
          Transit.config.translate = false
          Page.delivery_options = nil
          Page.send(:deliver_as, :page)
        end
        
        it 'does not enable translations' do
          Page.has_translation_support.should be_false
        end
        
        it 'does not add :localize => true to fields' do
          Page.new.respond_to?(:name_translations).should be_false
        end
        
      end
      
    end
    
  end
  
  describe "creating contexts" do
    
    describe "on a new record" do
      
      it "creates a new context" do
        post = Post.make
        post.contexts.count.should == 0
        post.contexts_attributes = { "0" => { "_type" => "TextBlock", "body" => "Sample text body" }}
        post.save
        post.contexts.count.should == 1
      end
    end
    
    describe "creating a new context" do
      
      before(:all) do
        @post = Post.make!
      end
      
      let!(:post) do
        @post
      end
      
      context "when no contexts exist" do
        
        before(:all) do
          post.contexts_attributes = { "0" => { "_type" => "TextBlock", "body" => "Sample text body" }}
          post.save
        end
        
        it 'adds a context' do
          post.contexts.count.should == 1
        end
      
        it "assigns the proper STI class to the context" do
          post.contexts.first.class.should == TextBlock
        end 
                 
      end
      
      context "when contexts exist" do
        
        before(:all) do
          post.contexts_attributes = { 
            "0" => { "_type" => "TextBlock", "body" => "Sample text body" }, 
            "1" => post.contexts.first.attributes.merge!("id" => post.contexts.first.id.to_s) 
          }
          post.save
        end
        
        it 'adds a context' do
          post.contexts.count.should == 2
        end
      
        it "assigns the proper STI class to the context" do
          post.contexts.last.class.should == TextBlock
        end
        
        after(:all) do
          post.contexts.last.delete
        end
        
      end
      
    end
    
    describe "updating an existing context" do
      
      let!(:post) do
        @post || Post.make!
      end
      
      before(:all) do
        post.contexts_attributes = { "0" => { "_type" => "TextBlock", "body" => "Sample text body" }}
        post.save        
      end
   
      let(:context) do 
        post.contexts.first
      end
      
      it 'should update the context inline' do
        expect{
          post.update_attributes(:contexts_attributes => { "0" => { "id" => context.id.to_s, "_type" => "TextBlock", "body" => "Sample text body" }})
        }.to_not change(post.contexts, :count)
      end
      
    end
    
    describe 'removing contexts' do
      
      let!(:post) do
        @post || Post.make!
      end
      
      before(:all) do
        post.contexts_attributes = { "0" => { "_type" => "TextBlock", "body" => "Sample text body" }}
        post.save        
      end
      
      let(:context) do 
        post.contexts.first
      end
      
      it 'destroys contexts when the _destroy attribute is true' do
        expect{
          post.update_attributes(:contexts_attributes => { "0" => { "id" => context.id.to_s, "_destroy" => "true", "_type" => "TextBlock", "body" => "Sample text body" }})
        }.to change(post.contexts, :count).by(-1)
      end
      
      
    end
  
  end
  
end