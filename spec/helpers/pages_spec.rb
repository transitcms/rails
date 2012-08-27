require 'spec_helper'

describe "Pages Helper", :type => :view do
  
  let!(:parent) do
    Page.make!(
      :name => 'Root Page'
    )
  end
  
  let!(:sub1) do
    Page.make!(
      :page => parent,
      :name => 'Sub Page 1'
    )
  end
  
  let!(:sub2) do
    Page.make!(
      :page => parent,
      :name => 'Sub Page 2'
    )
  end
  
  let!(:tertiary) do
    Page.make!(
      :page => sub1,
      :name => 'Tertiary Page'
    )
  end

  describe 'generating page trees' do
    
    let!(:options) do
      {}
    end
    
    before do
      render :partial => "pages/tree",
        :locals => {
          :options => options
        }      
    end
    
    it 'generates an ordered list' do
      rendered.should(
        have_tag('ul.page-tree')
      )
    end
    
    it 'generates items for each parent page' do
      rendered.should(
        have_tag('ul.page-tree > li', :count => 1)
      )
    end
    
    it 'contains the captured view html' do
      rendered.should(
        have_tag("ul.page-tree > li > span.page")
      )
    end
    
    context 'when assigning a :wrapper' do
      
      let!(:options) do
        { :wrapper => :ol }
      end
      
      context 'and :wrapper is a hash' do
        
        let!(:options) do
          { :wrapper => { :tag => :ol, :class => 'my-tree-list' } }
        end
        
        it 'renders the specified :tag' do
          rendered.should(
            have_tag('ol.page-tree')
          )
        end
        
        it 'adds other options as attributes' do
          rendered.should(
            have_tag('ol.page-tree.my-tree-list')
          )
        end
      end

      context 'and :wrapper is a symbol' do
        
        let!(:options) do
          { :wrapper => :div }
        end
        
        it 'renders the specified wrapping tag' do
          rendered.should(
            have_tag('div.page-tree')
          )
        end
        
        it 'renders nested items with the same tag' do
          rendered.should(
            have_tag('div.page-tree div.sub-tree')
          )
        end
      end
    end
    
    context 'when assigning a :item' do
        
      context 'and :item is a hash' do
          
        let!(:options) do
          { :item => { :tag => :div, :class => 'tree-item' } }
        end
          
        it 'renders the specified :tag' do
          rendered.should(
            have_tag('ul.page-tree > div')
          )
        end
          
        it 'adds other options as attributes' do
          rendered.should(
            have_tag('ul.page-tree > div.tree-item')
          )
        end
      end
      
      context 'and :item is a symbol' do
        
        let!(:options) do
          { :item => :div }
        end
        
        it 'renders the specified item tag' do
          rendered.should(
            have_tag('ul.page-tree > div')
          )
        end
      end
      
      context 'and :item is false' do
        
        let!(:options) do
          { :item => false }
        end
        
        it 'does not render the item tag' do
          rendered.should_not(
            have_tag('ul.page-tree > li')
          )
        end
      end
    end
    
    describe 'generated sub page trees' do
      
      let(:subtree) do
        'ul.page-tree > li:first-child > ul.sub-tree'
      end
      
      it 'contains a nested list' do
        rendered.should(
          have_tag(subtree)
        )
      end
      
      it 'contains list items for each sub page' do
        rendered.should(
          have_tag("#{subtree} > li", :count => 2)
        )
      end
      
      it 'contains the captured view html' do
        rendered.should(
          have_tag("#{subtree} > li > span.page")
        )
      end
    end
    
    describe 'generated tertiary page trees' do
      
      let(:subtree) do
        'ul.page-tree > li:first-child > ul.sub-tree > li:first-child > ul.sub-tree'
      end
      
      it 'contains a nested list' do
        rendered.should(
          have_tag(subtree)
        )
      end
      
      it 'contains list items for each sub page' do
        rendered.should(
          have_tag("#{subtree} > li", :count => 1)
        )
      end
      
      it 'contains the captured view html' do
        rendered.should(
          have_tag("#{subtree} > li > span.page")
        )
      end
    end
  end
end