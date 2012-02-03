module Transit
  
  ##
  # All built-in deliverable types are defined by a definition.
  # When calling deliver_as on any deliverable, the associated
  # definition is applied to it. 
  # 
  # @see lib/transit/deliverable
  # 
  module Definition

    autoload :Base,  'transit/definitions/base'
    autoload :Post,  'transit/definitions/post'
    autoload :Page,  'transit/definitions/page'
    
    ##
    # Raised when trying to include deliverable definition 
    # that does not exist.
    #
    class MissingDefinitionError < ::Transit::Error
    end    
    
  end # Definition
end # Transit