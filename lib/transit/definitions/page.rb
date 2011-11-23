module Transit
  module Definition
    ##
    # A page defines any full page-like model within a site. 
    # Pages have the same properties as standard html pages, including a title, 
    # a slug (url), keywords and descriptions.
    # 
    # 
    module Page
      
      extend ActiveSupport::Concern
      
      included do
        field :title,       :type => String,  :default => ""
        field :slug,        :type => String,  :default => nil
        field :description, :type => String,  :default => ""
        field :keywords,    :type => Array,   :default => []
        field :published,   :type => Boolean, :default => false        
        
        # Position field for use in building navigation trees
        field :position,    :type => Integer
		    
		    # Pages can always reference sub-pages etc
		    send(:has_many, :"#{self.name.pluralize.underscore}")
		    send(:belongs_to, :"#{self.name.underscore}")
		    
      end
  
      module ClassMethods
        
        def top_level
          where(:page_id => nil)           
        end
        
      end
      
    end # Page
  end # Definition
end # Transit