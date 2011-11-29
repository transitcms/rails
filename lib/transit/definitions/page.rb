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
        translates do
          field :name,        :type => String,  :default => "Un-named Page"
          field :title,       :type => String,  :default => ""        
          field :description, :type => String,  :default => ""
          field :keywords,    :type => Array,   :default => []
        end
        
        field :published,   :type => Boolean, :default => false
        field :slug,        :type => String,  :default => nil
        
        # Stores an array of paths/slugs based on the page's level in the tree
        field :path,        :type => Array, :default => []
        
        # Position field for use in building navigation trees
        field :position,    :type => Integer
		    
		    # Pages can always reference sub-pages etc
		    send(:has_many, :"#{self.name.pluralize.underscore}")
		    send(:belongs_to, :"#{self.name.underscore}")
		    
		    before_save :generate_paths
		    before_save :sanitize_path_names
		    
		    references_and_referenced_in_many :content_blocks
		    
      end
      
      
      module ClassMethods
        
        def top_level
          where(:page_id => nil)           
        end
        
        def published
          where(:published => true)
        end
        
      end
      
      ##
      # Convenience method for returning the full path to this page.
      # @return [String] The full path
      # 
      def full_path
        return self.slug if [self.path].flatten.compact.empty?
        self.path.join("/")
      end
      
      ##
      # Accessor for the parent page
      # 
      def parent
        self.send(:"#{self.class.name.underscore}")
      end
      
      private
      
      ##
      # Generates an array of slugs based on this page's nesting in the tree. 
      # When a page belongs to another (and even another) the resulting path stack 
      # should represent the full url to that page.
      # 
      #  
      def generate_paths
        return true unless self.page_id.present?
        parts = [self.slug]
        owner = parent
        until owner.nil?
          parts.unshift(owner.slug.to_s)
          owner = owner.parent
        end
        self.path = parts.map!{ |part| _sanitize_uri_fragment(part) }
      end
      
      ##
      # In the event slugs are entered by end-users, this ensures they are 
      # always truncated to non-absolute paths.
      # 
      def sanitize_path_names
        self.slug = _sanitize_uri_fragment(self.slug)
        unless [self.path].flatten.compact.empty?
          self.path.map!{ |part| _sanitize_uri_fragment(part) }
        end
      end

      def _sanitize_uri_fragment(frag)
        return nil if frag.nil?
        frag   = frag.gsub(/^(http|ftp|sftp|file)?:?(\/{1,2})?/i, "")
        parts  = frag.split("/")
        parts.shift if (parts.size > 1 && parts.first =~ /.*(\.)[a-z]{2,4}/i)
        parts.join("/")
      end
      
      
    end # Page
  end # Definition
end # Transit