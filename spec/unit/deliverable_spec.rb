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
  
  describe "creating contexts" do
    
    describe "creating a new context" do
      
      before(:all) do
        @_post = Post.make!
      end
      
      let(:post) do
        @_post
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
        @_post || Post.make!
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
          post.contexts_attributes = { "0" => { "id" => context.id.to_s, "_type" => "TextBlock", "body" => "Sample text body" }}
          post.save
        }.to_not change(post.contexts, :count)
      end
      
    end
  
  end
  
end