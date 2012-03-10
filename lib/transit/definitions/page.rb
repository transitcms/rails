require 'mongoid/tree'

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
        include Mongoid::Tree
        include Mongoid::Tree::Traversal
        include Mongoid::Tree::Ordering

        field :name,        :type => String, :localize => has_translation_support
        field :title,       :type => String, :localize => has_translation_support
        field :description, :type => String, :localize => has_translation_support
        field :keywords,    :type => Array,  :default => []
       
        field :slug, :type => String,  :default => nil
        
        # Stores an array of paths/slugs based on the page's level in the tree
        field :path, :type => Array, :default => []
		    
		    # Pages can always reference sub-pages etc
		    define_method(:"#{self.name.pluralize.underscore}") do
		      self.children
	      end
	      
	      define_method(:"#{self.name.pluralize.underscore}=") do |kids|
		      self.children  = kids
	      end
        
        define_method(:"#{self.name.underscore}") do
          self.parent
        end
        
        define_method(:"#{self.name.underscore}=") do |owner|
          self.parent = owner
        end
		    		    
		    before_save :sanitize_path_names
		    before_save :generate_paths
		    before_destroy :nullify_children
		    
		    has_and_belongs_to_many :content_blocks
		    
		    validates_presence_of :title, :name, :slug
      end
      
      ##
      # Class level methods and functionality
      # 
      module ClassMethods
        
        ##
        # Returns all top_level pages (those without children)
        # 
        def top_level
          roots
        end
        
        ##
        # Accepts a url fragment and returns the corresponding page.
        # @param [String] path The url fragment
        # 
        def from_path(path)
          where(path: path.split("/"))
        end
        
        ##
        # Returns all published pages
        # 
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
        self.path.dup.join("/")
      end
      
      def pages?
        self.send(:"#{self.class.name.pluralize.underscore}").published.exists?
      end
      
      private
      
      ##
      # Generates an array of slugs based on this page's nesting in the tree. 
      # When a page belongs to another (and even another) the resulting path stack 
      # should represent the full url to that page.
      # 
      #  
      def generate_paths
        self.path = self.ancestors_and_self.collect(&:slug).map do |part|
          _sanitize_uri_fragment(part)
        end
      end
      
      ##
      # In the event slugs are entered by end-users, this ensures they are 
      # always truncated to non-absolute paths. It also checks against 
      # duplication of parent slug/path values.
      # 
      def sanitize_path_names        
        self.slug  = _sanitize_uri_fragment(self.slug)                
        unless self.parent.nil?
          slug_parts   = self.slug.to_s.split("/").compact
          parent_parts = self.parent.path.dup
          self.slug    = slug_parts.drop_while{ |part| part == parent_parts.shift }.join("/")
        end
        unless [self.path].flatten.compact.empty?
          self.path.map!{ |part| _sanitize_uri_fragment(part) }
        end
      end

      ##
      # Removes protocols, and invalid characters from a url fragment
      # @param [String] frag The fragment to sanitize
      # 
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