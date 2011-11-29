module Transit
  module Definition
    
    module Post
      
      extend ActiveSupport::Concern
      
      included do
        translates do
          field :title,  :type => String
          field :teaser, :type => String
        end
        
        field :post_date,  :type => Time
        field :slug,       :type => String        
        field :published,  :type => Boolean, :default => false
        
        before_save :create_slug_if_published
        validates_presence_of :title, :post_date
      end
      
      module ClassMethods
        
        ##
        # Published posts are defined as posts with their `published` 
        # attribute set to true, with a post date before or on the current date
        # 
        def published
          all_of(:published => true, :post_date.gte => Date.today.to_time)
        end
        
      end
      
      private
      
      def create_slug_if_published
        return true unless self.slug.nil?
        return true unless self.published?
        self.slug = self.title.to_slug
      end
      
    end # Post
  end # Definition
end # Transit