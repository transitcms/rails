require 'mongoid'
require 'mongoid-ancestry'

class AssetGroup
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Mongoid::Ancestry
  
  field :name, :type => String, :localize => Transit.config.translate
  has_ancestry :orphan_strategy => :rootify, :cache_depth => true
  
  has_many :assets, :inverse_of => :group
  validates :name, :presence => true, :uniqueness => true

  scope :by_creation, ascending(:created_at)
  scope :by_name, ascending(:name)
  
  class << self
    
    def default
      roots.first || create(:name => Transit.config.assets.default_group)
    end
  end
  
  ##
  # Name based accessor for group paths.
  # 
  def groups
    self.children
  end
  
  def groups=(kids)
    self.children = kids
  end
  
  def group
    self.parent
  end
  
  def group=(g)
    self.parent = g
  end
end