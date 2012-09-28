module Transit
  ##
  # String interpolation, based off of Paperclip.
  # 
  module Interpolations
    extend self

    def self.[]= name, block
      define_method(name, &block)
    end

    def self.[] name
      method(name)
    end
    
    # Returns a sorted list of all interpolations.
    def self.all
      self.instance_methods(false).sort
    end
    
    ##
    # Perform the actual interpolation using the provided pattern.
    # 
    def self.interpolate pattern, *args
      all.reverse.inject(pattern) do |result, tag|
        result.gsub(/:#{tag}/) do |match|
          send( tag, *args )
        end
      end
    end
    
    ##
    # Returns the title of the passed resource.
    #
    # @param [Object] resource The associated model instance
    #  
    def title(resource)
      resource.title.to_s.to_slug
    end
    
    ##
    # Month value, using publish_date if it exists, 
    # otherwise, created_at date.
    # 
    # @param [Object] resource The associated model instance
    # 
    def month(resource)
      if resource.respond_to?(:publish_date) 
        return resource.publish_date.try(:strftime, '%m')
      end
      resource.created_at.try(:strftime, '%m')
    end
    
    ##
    # Day value, using publish_date if it exists, 
    # otherwise, created_at date.
    # 
    # @param [Object] resource The associated model instance
    # 
    def day(resource)
      if resource.respond_to?(:publish_date) 
        return resource.publish_date.try(:day)
      end
      resource.created_at.try(:day)
    end
    
    ##
    # Year value, using publish_date if it exists, 
    # otherwise, created_at date.
    # 
    # @param [Object] resource The associated model instance
    # 
    def year(resource)
      if resource.respond_to?(:publish_date) 
        return resource.publish_date.try(:year)
      end
      resource.created_at.try(:year)
    end
  end
end