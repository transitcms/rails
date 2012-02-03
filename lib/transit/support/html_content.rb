require 'mongoid'

##
# Subclasses String to provide custom functionality 
# for html text content. When creating model attributes 
# which will contain user created html text, assign the 
# field type to HtmlContent.
# 
# 
class HtmlContent < String
  include ::Mongoid::Fields::Serializable

  # @private
  def initialize(strval) #:nodoc:
    self.concat strval
  end
  
  ##
  # Called on retrieval from the database.
  # 
  def deserialize(strval)
    self.replace strval
  end

  ##
  # Called on save to the database.
  # 
  def serialize(strval)
    strval
  end
  
end
