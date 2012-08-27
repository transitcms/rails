module Transit
  module Extension
    ##
    # Enables "publish" state for deliverable models.
    # By default this includes a boolean `published` field, 
    # as well as a `post_date`, allowing the ability to mark an
    # item as published, as well as set the date in which it is 
    # available.
    # 
    module Publishing
      extend ActiveSupport::Concern
      
      included do
        field :published,    :type => Boolean, :default => false
        field :publish_date, :type => Time                    
        ## Alias post_date for convenience and as a sensible name for post type deliverables.
        alias_attribute :post_date, :publish_date
        
      end
      
      ##
      # Publish and save the resource.
      # 
      def publish!
        self.set(:published, true)
      end
      
      ##
      # Class level methods and functionality
      # 
      module ClassMethods
        
        ##
        # Published items are defined as having a `published` value of true
        # and a publish_date before or on the current date.
        # 
        def published
          all_of(:published => true, :publish_date.gte => Date.today.to_time)
        end
        
      end
      
    end
  end
end