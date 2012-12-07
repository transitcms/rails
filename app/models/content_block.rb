##
# A content block is similar to a page, except that it only stores contexts. 
# Content blocks can be referenced from one or more pages, they 
# can also have their content disabled, in cases where they should have a 
# defined set of contexts, un-changable by the user. 
# 
# Finally they can also be marked as "removable", making it easy to 
# disallow deletion of content blocks that are vital to layout or 
# other elements.
# 
# 
require File.join(File.dirname(__FILE__), 'context.rb')

class ContentBlock
  include Mongoid::Document
  include Mongoid::Timestamps
  include Transit::Definition::Base
  
  field :name,            :type => String,  :default => "content_block"
  field :content_enabled, :type => Boolean, :default => true
  field :removable,       :type => Boolean, :default => true

  private
  
  ##
  # ContentBlocks set to be non-removable should be 
  # blocked on destroy.
  # 
  def block_if_non_removable
    return removable?
  end
  before_destroy :block_if_non_removable
  
end