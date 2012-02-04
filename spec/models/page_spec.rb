require 'spec_helper'

describe Page do
  include DeliverableSpecs
  
  
  before(:all) do
    Page.delete_all
  end
  
  let(:page) do 
    @parent_page = Page.where(:title => "Parent Page").first || Page.make!(:title => "Parent Page", :slug => 'parent-page')
  end
  
  it "references many content blocks" do
    should reference_and_be_referenced_in_many(:content_blocks)
  end
  
  it 'creates a child getter based on the delivered class' do
    page.respond_to?(:pages).should be_true
  end
  
  it 'creates a child setter based on the delivered class' do
    page.respond_to?(:pages=).should be_true
  end
  
  it 'creates a parent setter based on the delivered class' do
    page.respond_to?(:page=).should be_true
  end
  
  it 'creates a parent getter based on the delivered class' do
    page.respond_to?(:page).should be_true
  end
  
  describe "validations" do
    
    subject do
      Page
    end
    
    it{ should validate_presence_of(:title) }
    it{ should validate_presence_of(:name) }
    it{ should validate_presence_of(:slug) }
    
  end # validations
  
  describe "when delivered_as page" do
  
    it "includes the page definition" do
      described_class.included_modules.should include(Transit::Definition::Page)
    end
    
    it "applies the page fields" do
      ['title', 'slug', 'description', 'keywords'].each do |field| 
        described_class.fields.keys.should include(field)
      end
    end
  
  end # delivery
  
  describe "slug" do
    
    after do
      Page.where(:title => "Test page").delete
    end
    
    it "should remove protocols on save" do
      Page.make!(:title => "Test page", :slug => "http://somedomain.com/the-path").reload.slug.should == "the-path"
    end
    
    it "should remove leading slashes on save" do
      Page.make!(:title => "Test page", :slug => "//the-path").reload.slug.should == "the-path"
    end
    
  end #slugs
  
  describe "scopes" do
    
    before(:all) do
      Page.delete_all
      @page     = Page.make!(:title => 'Un-Published Page', :slug => 'un-published-page')
      @pub_page = Page.make!(:title => 'Published Page', :slug => 'published-page', :published => true, :page => @page)
    end
    
    it ".top_level only finds pages that do not belong to another" do
      Page.top_level.count.should == 1
    end
    
    it ".published does not find un-published pages" do
      Page.published.all.collect{ |p| p.id }.map(&:to_s).should_not include(@page.id.to_s)
    end
    
    it '.published finds published pages' do
      Page.published.all.collect{ |p| p.id }.map(&:to_s).should include(@pub_page.id.to_s)
    end
    
    it '.from_path takes a url and finds pages by path' do
      Page.from_path("un-published-page/published-page").first.should == @pub_page
    end
    
  end # scopes
  
  describe "nesting pages" do
    
    before(:all) do      
      page.pages << sub_page
    end
    
    let(:sub_page) do
      @sub_page ||= Page.make!(:title => "Sub Page", :slug => "sub-page", :published => true)
    end
    
    it "returns false for pages? when the page has children" do
      page.pages?.should be_true
    end
    
    it "returns false for pages? when the page has children" do
      sub_page.pages?.should be_false
    end
    
    it "stores sub-pages as an array" do
      page.pages.all.should_not be_empty
    end
    
    it "sub pages are instances of the page class" do
      page.pages.first.should be_a(Page)
    end
    
    it "sub pages reference the parent page" do
      sub_page.page.should == page
    end
    
    it "stores the pages in a one-sided manner" do
      sub_page.pages.should be_empty
    end
    
    it "stores unique page instances" do
      page.pages.count.should == 1
    end
    
    it "creates a full path to the page" do
      sub_page.full_path.should == "parent-page/sub-page"
    end
    
    it "stores all parent paths in the path array" do
      sub_page.path.should == ['parent-page', 'sub-page']
    end
    
    context "when tertiary" do
      
      let(:tertiary) do
        @tertiary ||= Page.make!(:title => "Tertiary Page", :slug => 'tertiary-page')
      end
      
      before(:all) do
        sub_page.pages << tertiary
      end
      
      after(:all) do
        tertiary.try(:destroy)
      end
      
      it "is nested under the secondary page" do
        sub_page.pages.should include(tertiary)
      end
      
      it "is not referenced in the top level page" do
        page.pages.should_not include(tertiary)
      end
      
      it "stores unique page instances" do
        sub_page.pages.count.should == 1
      end
      
      it "creates a full path to the page" do
        tertiary.full_path.should == "parent-page/sub-page/tertiary-page"
      end
      
      it "stores all parent paths in the path array" do
        tertiary.path.should == ['parent-page', 'sub-page', 'tertiary-page']
      end
      
    end # tertiary
    
    describe "de-duping slugs" do
      
      
      context "when a child page's slug contains the parent" do
        
        let(:secondary) do
          @secpage ||= Page.make!(:page => page, :title => "Dupetest Page", :slug => 'parent-page/dupetest-page')
        end
        
        it "removes the parent's slug from the child" do
          secondary.path.should == ['parent-page', 'dupetest-page']
        end
        
        after(:all) do
          @secpage.try(:destroy); @secpage = nil
        end
        
      end # de-duping duplicate slugs
      
      context "when a child page's slug does not contain a parent" do
        
        let(:nodupe) do
          @secpage2 ||= Page.make!(:page => page, :title => "Dupetest Page2", :slug => 'random-page/dupetest-page')
        end
        
        it "does not modify the slug" do
          nodupe.path.should == ['parent-page', 'random-page/dupetest-page']
        end
        
        after(:all) do
          @secpage2.try(:destroy); @secpage2 = nil
        end
        
      end # de-duping safe
            
    end # de-duping
       
  end
  
end