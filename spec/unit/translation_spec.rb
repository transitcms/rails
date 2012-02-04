require 'spec_helper'

Transit.config.translate = true

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
 
  before(:all) do
    @post = TranslatedPost.new(:title => "english title")
    @post.save(:validate => false)
  end
  
  let(:post) do
    @post
  end
 
  describe "translated attributes" do
    
    context 'when the default locale' do
      
      after do
        I18n.locale = :en
      end
      
      it 'translates attributes' do
        post.title.should == "english title"
      end
      
      it 'defines attributes by the locale' do
        I18n.locale = :mx
        post.title.should be_nil
      end
      
    end
    
    context 'when a specific locale' do
      
      before(:all) do
        I18n.locale = :mx
        post.update_attributes(:title => 'spanish title')
      end
      
      it 'translates attributes' do
        post.title.should == 'spanish title'
      end
      
      it 'defines attributes by the current locale' do
        I18n.locale = :en
        post.title.should == 'english title'
      end
      
    end
    
  end
  
  describe "context translations" do
    
    before(:all) do
      I18n.locale = :en
      @text = post.contexts.create({ :translated_body => "english content" }, TranslatedTextBlock)
      post.reload.contexts.each(&:save)
      text = post.contexts.first
      I18n.locale = :mx
      text.update_attributes({ :translated_body => "spanish content" })
    end
    
    context "when has_translation_support is set to true" do
      
      it 'creates translations' do
        @text.translations.should_not be_empty
      end
      
      it 'translates the content' do
        I18n.locale = :en
        @text.reload.translated_body.should == "english content"
        I18n.locale = :mx
        @text.reload.translated_body.should == "spanish content"
      end
      
    end 
    
  end
  
  
end