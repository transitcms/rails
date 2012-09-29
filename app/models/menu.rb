require 'transit/delivery'
require 'mongoid-ancestry'

##
# The Menu class is used to generate navigation menus from various pages 
# within an application. These can be primary navigation menus, sidebar menus,
# whatever. Each menu contains a number of items, which allows customization 
# of the text displayed, as well as the url.
# 
class Menu
  include Mongoid::Document
  include Mongoid::Timestamps

  ##
  # Optional identifier for the menu, used when you want to 
  # easily find a particular menu no matter the name. This field 
  # should really never be set by an end user.
  # 
  field :identifier, :type => String, :default => ''
  field :name, :type => String
  field :description, :type => String
  
  embeds_many :items, :class_name => 'Menu::MenuItem'
  
  validates :name, :presence => true
  
  scope :called, lambda{ |name| where(:identifier => name) }
  accepts_nested_attributes_for :items, :allow_destroy => true
  
  class MenuItem
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Ancestry
    
    include Transit::Extension::Ordering

    class_attribute :has_translation_support
    self.has_translation_support = Transit.config.translate
    
    field :title,   :type => String, :localize => has_translation_support
    field :page_id, :type => ::Moped::BSON::ObjectId
    field :url,     :type => String
    
    has_ancestry :orphan_strategy => :rootify, :cache_depth => true
    field :ancestry_depth, :type => Integer, :default => 0
    
    embedded_in :menu, :class_name => 'Menu'
    validates :title, :presence => true
    
    before_validation :set_url_from_page
    
    ##
    # Accessor for the page, since embedded to top level relationships
    # can be iffy. We use a .where here to avoid document not found errors.
    # 
    def page
      @page ||= ::Page.where(:id => self.page_id).first
    end
    
    ##
    # Setter for the item's page. 
    # 
    def page=(p)
      self.page_id = p.id
    end
    
    private
    
    ##
    # If a menu item has an associated page, use that page's url for navigation.
    # To make sure top level paths are used, normalize the beginning slash.
    # 
    def set_url_from_page
      return true if self.page.nil?
      return true unless self.page_id_changed?
      full = self.page.full_path.to_s.sub(/^\//, '')
      self.url = "/#{full}"
    end
  end
end