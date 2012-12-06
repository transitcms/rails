require 'spec_helper'

describe Page do
  include DeliverableSpecs
  
  Page.class_eval do
    deliver_with :publishing
    scope :published, where(:published => true)
  end
  
  let!(:page) do 
    Page.make!(
      :title => "Parent Page", 
      :slug => 'parent-page'
    )
  end
  
  it "references many content blocks" do
    should have_and_belong_to_many(
      :content_blocks
    )
  end
  
  describe 'getters and setters' do
  
    it 'creates a getter from the delivered class' do
      page.respond_to?(:pages)
        .should be_true
    end
  
    it 'creates a setter from the delivered class' do
      page.respond_to?(:pages=)
        .should be_true
    end
  
    it 'creates a singluar setter' do
      page.respond_to?(:page=)
        .should be_true
    end
  
    it 'creates a singular getter' do
      page.respond_to?(:page).should be_true
    end  
  end
  
  describe "validations" do
    
    subject do
      Page
    end
    
    it 'validates that a title exists' do
      should validate_presence_of(:title)
    end
    
    it 'validates that a name exists' do
      should validate_presence_of(:name)
    end
    
    it 'validates the presence of a slug' do
      should validate_presence_of(:slug)
    end
  end
  
  describe "when delivered_as page" do
  
    it "includes the page definition" do
      described_class.included_modules
        .should include(Transit::Definition::Page)
    end
    
    it "applies the page fields" do
      ['title', 'slug', 'description', 'keywords'].each do |field| 
        described_class.fields.keys
          .should include(field)
      end
    end
  
  end # delivery
  
  describe "slug" do
    
    after do
      Page.where(:title => "Test page").delete
    end
    
    it "should remove protocols on save" do
      Page.make!(
        :title => "Test page", 
        :slug => "http://somedomain.com/the-path")
      .reload.slug.should eq "the-path"
    end
    
    it "should remove leading slashes on save" do
      Page.make!(
        :title => "Test page", 
        :slug => "//the-path")
      .reload.slug.should eq "the-path"
    end
    
  end #slugs
  
  describe "scopes" do
   
    let!(:parent_page) do
      Page.create(
        :title => 'Un-Published Page', 
        :name  => 'Unpub Page',
        :slug => 'un-published-page',
        :published => true
      )
    end
    
    let!(:pub_page) do
      Page.create(
        :title => 'Published Page', 
        :name  => 'Pub Page',
        :slug => 'published-page', 
        :published => true, 
        :page => parent_page
      )
    end
    
    describe '#top_level page scope' do
    
      it "only finds pages that do not belong to another" do
        Page.top_level.count
          .should eq 2
      end
    end    
    
    describe '#published page scope' do
      
      let(:page_ids) do
        Page.published.all
          .collect(&:id).map(&:to_s)
      end
    
      it "does not find pages where published is false" do
        page_ids.should_not(
          include(page.id.to_s)
        )
      end
    
      it 'finds pages where published is true' do
        page_ids.should(
          include(pub_page.id.to_s)
        )
      end
    end
    
    describe '#from_path page scope' do
      
      it 'accepts a url and finds pages by path' do
        Page.from_path("un-published-page/published-page")
          .first.should eq pub_page
      end
    end
  end
  
  describe "nesting pages" do
    
    let!(:page) do 
      Page.make!(
        :title => "Parent Page", 
        :slug => 'parent-page'
      )
    end
    
    let!(:sub_page) do
      Page.make!(
        :title => "Sub Page", 
        :slug => "sub-page", 
        :published => true,
        :page => page)
    end
    
    context 'when a page is top level' do
      
      context 'and it has sub-pages' do
        
        it ".pages? returns true" do
          page.pages?
            .should be_true
        end
        
        it "stores sub-pages as an array" do
          page.pages.all
            .should_not be_empty
        end
        
        it "stores sub pages as instances of a page" do
          page.pages.first
            .should be_a(Page)
        end
        
        it "stores unique page instances" do
          page.pages.count
            .should eq 1
        end
        
        it "creates full_path using only its slug" do
          page.full_path
            .should eq 'parent-page'
        end
        
        it 'creates absolute_path using only its slug' do
          page.absolute_path
            .should eq '/parent-page'
        end
      end
      
      context 'and it does not have sub-pages' do
        
        it ".pages? returns false" do
          sub_page.pages?
            .should be_false
        end
      end
    end
    
    context 'when a secondary page' do
      
      it 'references its parent as .page' do
        sub_page.page
          .should eq page
      end
      
      it 'does not store parent page ids' do
        sub_page.pages
          .should be_empty
      end
      
      it "creates full_path using only its parent slug" do
        sub_page.full_path
          .should eq 'parent-page/sub-page'
      end
        
      it 'creates absolute_path using its parent slug' do
        sub_page.absolute_path
          .should eq '/parent-page/sub-page'
      end
    end
    
    context "when tertiary" do
      
      let!(:tertiary) do
        Page.make!(
          :title => "Tertiary Page", 
          :slug => 'tertiary-page',
          :page => sub_page
        )
      end
      
      it "is nested under the secondary page" do
        sub_page.pages
          .should include(tertiary)
      end
      
      it "is not referenced in the top level page" do
        page.pages
          .should_not include(tertiary)
      end
      
      it "stores unique page instances" do
        sub_page.pages.count
          .should eq 1
      end
      
      it "creates a full path to the page" do
        tertiary.full_path
          .should eq "parent-page/sub-page/tertiary-page"
      end
      
      it "stores all parent paths in the slug_map array" do
        tertiary.slug_map
          .should eq [
              'parent-page', 
              'sub-page', 
              'tertiary-page'
            ]
      end
    end
    
    describe "de-duping slugs" do
      
      context "when a child page's slug contains the parent" do
        
        let!(:secondary) do
          Page.make!(
            :page => page, 
            :title => "Dupetest Page", 
            :slug => 'parent-page/dupetest-page'
          )
        end
        
        it "removes the parent's slug from the child" do
          secondary.slug_map
            .should eq ['parent-page', 'dupetest-page']
        end
      end # de-duping duplicate slugs
      
      context "when a child page's slug does not contain a parent" do
        
        let(:nodupe) do
          Page.make!(
            :page => page, 
            :title => "Dupetest Page2", 
            :slug => 'random-page/dupetest-page'
          )
        end
        
        it "does not modify the slug" do
          nodupe.slug_map
            .should eq [
                'parent-page', 
                'random-page/dupetest-page'
              ]
        end
      end # de-duping safe
    end # de-duping
  end
  
  describe 'positioning pages' do
    
    let!(:top) do
      Page.make!(
        :slug  => 'top-page',
        :name  => 'Top Page',
        :title => 'This is a top page'
      )
    end
    
    let!(:top2) do
      Page.make!(
        :slug  => 'top-page2',
        :name  => 'Top page 2',
        :title => 'This is a top page'
      )
    end
    
    let!(:sub) do
      Page.make!(
        :page  => page,
        :slug  => 'sub-page',
        :name  => 'Sub Page',
        :title => 'This is a sub page'
      )
    end
    
    let!(:sub2) do
      Page.make!(
        :page  => page,
        :slug  => 'sub-page',
        :name  => 'Sub Page',
        :title => 'This is a sub page'
      )
    end
    
    let!(:sub3) do
      Page.make!(
        :page  => page,
        :slug  => 'sub-page',
        :name  => 'Sub Page',
        :title => 'This is a sub page'
      )
    end
    
    context 'when top level pages' do
      
      it 'increments position from existing pages' do
        page.position
          .should eq 1
      end
      
      it 'adds pages in ascending order' do
        top.position
          .should eq 2
      end
      
      it 'sets the position to an incrementing value' do
        top2.position
          .should eq 3
      end
    end
    
    context 'when nested pages' do
      
      it 'adds pages in ascending order' do
        sub.position
          .should eq 1
      end
      
      it 'sets the position to an incrementing value' do
        sub2.position
          .should eq 2
      end
    end
    
    describe 'reordering pages with .reposition!' do
      
      context 'when top level pages' do
        
        before do
          top2.reposition!(1)
          [page, top, top2]
            .each(&:reload)
        end
        
        it 're-orders the page to the new position' do
          top2.position
            .should eq 1
        end
        
        it 're-orders sibling pages to higher positions' do
          page.position
            .should eq 2
          top.position
            .should eq 3
        end
      end
      
      context 'when nested pages' do
        
        before do
          sub2.reposition!(1)
          [sub, sub2, sub3, top, top2]
            .each(&:reload)
        end
        
        it 're-orders the page to the new position' do
          sub2.position
            .should eq 1
        end
        
        it 'moves sibling pages to higher positions' do
          sub.position
            .should eq 2
          sub3.position
            .should eq 3
        end
        
        it 'does not move other pages outside of siblings' do
          page.position
            .should eq 1
          top.position
            .should eq 2
        end
      end
    end
  end
end