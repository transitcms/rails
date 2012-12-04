require 'spec_helper'

describe NavigationMenu do
  
  describe 'associations' do
    
    it 'embeds many menu items' do
      should embed_many(:items)
    end
  end
  
  describe 'validations' do
    
    it 'requires a name be set' do
      should validate_presence_of(:name)
    end
  end
  
  describe 'MenuItem' do
    
    subject do
      NavigationMenu::MenuItem
    end
    
    it 'is embedded in a menu' do
      should be_embedded_in(:menu)
    end
    
    it 'requires a title' do
      should validate_presence_of(:title)
    end
  end
  
  let!(:menu) do
    NavigationMenu.make!
  end
  
  let!(:page) do
    NavigationMenu.make!
  end
  
  describe 'an item with a page' do
    
    let!(:item) do
      menu.items
        .create({
          :title => 'Home Page',
          :page  => page
        })
    end
    
    it 'sets the items page id' do
      item.page_id
        .should_not be_nil
    end
    
    it 'sets the items url to the page path' do
      item.url.should(
        eq "/#{page.full_path}"
      )
    end
  end
  
  describe 'an item with no page' do
    
    let!(:item) do
      menu.items
        .create({
          :title => 'Home Page',
          :url   => "http://google.com"
        })
    end
    
    it 'should not set the items page id' do
      item.page_id
        .should be_nil
    end
    
    it 'uses the defined url attribute' do
      item.url.should(
        eq "http://google.com"
      )
    end
  end
end