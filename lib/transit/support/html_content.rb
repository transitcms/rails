require 'mongoid'

##
# Subclasses String to provide custom functionality 
# for html text content. When creating model attributes 
# which will contain user created html text, assign the 
# field type to HtmlContent.
# 
# 
class HtmlContent < String

  # @private
  def initialize(strval) #:nodoc:
    self.concat strval
  end
  
  def mongoize
    self
  end
  
  class << self
    ##
    # Called on retrieval from the database.
    # 
    def demongoize(strval)
      HtmlContent.new(strval)
    end
  
    ##
    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    #
    def evolve(strval)
      case strval
      when HtmlContent then strval.mongoize
      else strval
      end
    end

    ##
    # Called on save to the database.
    # 
    def mongoize(strval)
      case strval
      when HtmlContent then strval.mongoize
      when String then HtmlContent.new(strval).mongoize
      else strval
      end
    end
  end  
end
