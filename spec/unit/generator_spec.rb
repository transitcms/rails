require 'spec_helper'

describe 'HTML to Context generator' do
  
  let!(:page) do
    Page.new
  end
  
  let!(:data) do
    "<h1>Heading</h1><div data-context-type='TextBlock'><p>This is some body copy</p></div>"
  end
  
  let!(:gen) do
    Transit::Generator.new(data, page)
  end
  
  it 'should create a nokogiri doc with the html string' do
    gen.doc.should(
      be_a(::Nokogiri::HTML::Document)
    )
  end
  
  describe '.children' do

    it 'includes all tags under the body' do
      gen.children.count
        .should eq 2
    end
    
    it 'only collects top level tags' do
      gen.children.first
        .name.should eq 'h1'
    end
  end
  
  describe '.contexts' do
    
    it 'generates an array of context data' do
      gen.contexts.should(
        be_an(Array)
      )
    end
    
    it 'includes the context type as the first item' do
      gen.contexts.first.first
        .should eq 'HeadingText'
    end
    
    it 'includes context attributes as the second item' do
      gen.contexts.first.last
        .should be_a(Hash)
    end
    
    describe 'generated attributes' do

      context 'when a heading node' do
      
        let(:attrs) do
          gen.contexts.first.last
        end
      
        it 'creates a :node attribute from the tag' do
          attrs[:node].present?
            .should be_true
          attrs[:node].should eq 'h1'
        end
      
        it 'creates a :body attribute from the nodes text' do
          attrs[:body].present?
            .should be_true
          attrs[:body].should eq 'Heading'
        end
      end
      
      context 'when a text block node' do
      
        let(:attrs) do
          gen.contexts.last.last
        end
      
        it 'creates a :body attribute from the child\'s  html' do
          attrs[:body].present?
            .should be_true
          attrs[:body].should eq '<p>This is some body copy</p>'
        end
      end
    end
    
    context 'when multiple nodes of the same type exist' do
      
      let!(:data) do
        "<h1>Heading</h1><div data-context-type='TextBlock'><p>This is some body copy</p></div><h2>This is a subheading</h2>"
      end
      
      it 'generates contexts for all nodes' do
        gen.contexts.size
          .should eq 3
      end
      
      it 'generates separate contexts for matching nodes' do
        gen.contexts.first.last[:node]
          .should eq 'h1'
        gen.contexts.last.last[:node]
          .should eq 'h2'
      end
    end
  end
  
  context 'when used with .build_from_html on a deliverable' do
    
    before do
      page.contexts.delete_all
      page.build_from_html(data)
    end
    
    it 'generates contexts from the html data' do
      page.contexts.size
        .should eq 2
    end
    
    it 'generates each context from type' do
      page.contexts.first
        .should be_a(HeadingText)
    end
  end
end