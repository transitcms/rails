module Transit
  module Definition
    
    ##
    # Defines the base functionality for a Post type deliverable. A 'post' in its basic form 
    # can be described as any individual member of a 'feed' of many of the same or similar item.
    # 
    # Posts contain a `published` state which can be used to determine their availability for 
    # display on front-facing pages. They also include a post_date which can be used to 
    # pre-generate content to be displayed at a later point in time.
    # 
    module Post
      
      extend ActiveSupport::Concern
      
      included do
        translates do
          field :title,  :type => String
          field :teaser, :type => String
        end

        field :slug,       :type => String        

        validates_presence_of :title, :post_date
        
        # By default all posts should be publishable
        deliver_with :publishing
        before_save :create_slug_if_published
      end
      
      private
      
      ##
      # Post slugs are automatically generated from the :title attribute 
      # unless already defined. Since the title may change prior to publishing, 
      # the slug is not generated until the post is in a published state.
      # 
      def create_slug_if_published
        return true unless self.slug.nil?
        return true unless self.published?
        self.slug = self.title.to_slug
      end
            
      
    end # Post
  end # Definition
end # Transit