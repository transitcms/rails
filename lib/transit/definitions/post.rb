module Transit
  module Definition
    
    module Post
      
      extend ActiveSupport::Concern
      
      included do
        translates do
          field :title,  :type => String
          field :teaser, :type => String
        end
        
        field :post_date,  :type => Date
        field :slug,       :type => String        
        field :published,  :type => Boolean, :default => false
      end
      
      module ClassMethods
        
        ##
        # Published posts are defined as posts with their `published` 
        # attribute set to true, with a post date before or on the current date
        # 
        def published
          all_of(:published => true, :post_date.gte => Date.today)
        end
        
      end
      
    end # Post
  end # Definition
end # Transit