require 'spec_helper'

describe Page do
  include DeliverableSpecs
  
  
  before(:all) do
    Page.delete_all
  end
  
  let(:page) do 
    @parent_page = Page.where(:title => "Parent Page").first || Page.make!(:title => "Parent Page", :slug => 'parent-page')
  end
  
  it "references many pages" do
    should be_referenced_in(:page)
  end
  
  it "references many content blocks" do
    should reference_and_be_referenced_in_many(:content_blocks)
  end
  
  specify do
    page.respond_to?(:pages).should be_true
  end
  
  describe "validations" do
    
    subject do
      Page
    end
    
    it{ should validate_presence_of(:title) }
    it{ should validate_presence_of(:name) }
    it{ should validate_presence_of(:slug) }
    
  end
  
  describe "when delivered_as page" do
  
    it "includes the page definition" do
      described_class.included_modules.should include(Transit::Definition::Page)
    end
    
    it "applies the page fields" do
      ['title', 'slug', 'description', 'keywords', 'published'].each do |field| 
        described_class.fields.keys.should include(field)
      end
    end
  
  end
  
  describe "slug" do
    
    after do
      Page.where(:title => "Test page").delete
    end
    
    it "should remove protocols on save" do
      slugged = Page.make!(:title => "Test page", :slug => "http://somedomain.com/the-path")
      slugged.reload.slug.should == "the-path"
    end
    
    it "should remove leading slashes on save" do
      slugged = Page.make!(:title => "Test page", :slug => "//the-path")
      slugged.reload.slug.should == "the-path"
    end
    
  end
  
  describe "nesting pages" do
    
    before(:all) do      
      page.pages << sub_page
    end
    
    let(:sub_page) do
      @sub_page ||= Page.make!(:title => "Sub Page", :slug => "sub-page")
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
      
    end
    
    describe "top_level scope" do

      it "only finds pages that do not belong to another" do
        Page.top_level.count.should == 1
      end
      
    end
    
  end
  
end