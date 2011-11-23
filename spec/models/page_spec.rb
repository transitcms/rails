require 'spec_helper'

describe Page do
  include DeliverableSpecs
  
  
  before(:all) do
    Page.delete_all
  end
  
  let(:page) do 
    @parent_page = Page.where(:title => "Parent Page").first || Page.make!(:title => "Parent Page")
  end
  
  it "references many pages" do
    should be_referenced_in(:page)
  end
  
  specify do
    page.respond_to?(:pages).should be_true
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
  
  describe "nesting pages" do
    
    before(:all) do      
      page.pages << sub_page
    end
    
    let(:sub_page) do
      @sub_page ||= Page.make!(:title => "Sub Page")
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
    
    context "when tertiary" do
      
      let(:tertiary) do
        @tertiary ||= Page.make!(:title => "Tertiary Page")
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
      
    end
    
    describe "top_level scope" do

      it "only finds pages that do not belong to another" do
        Page.top_level.count.should == 1
      end
      
    end
    
  end
  
end