##
# A content block is similar to a page, except that it only stores contexts. 
# Content blocks can be referenced from one or more pages.
# 
class ContentBlock
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => :String, :default => "block"
  embeds_many :contexts, :as => :deliverable
  
end