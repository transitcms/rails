module Transit
  
  ##
  # All built-in deliverable types are defined by a definition.
  # When calling deliver_as on any deliverable, the associated
  # definition is applied to it. 
  # 
  # @see lib/transit/deliverable
  # 
  module Definition

    autoload :Post,  'transit/definitions/post'
    autoload :Page,  'transit/definitions/page'
    
    class MissingDefinitionError < StandardError
    end    
    
  end # Definition
end # Transit