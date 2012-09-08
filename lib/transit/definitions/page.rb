require 'mongoid-ancestry'

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
        include Mongoid::Ancestry
        
        field :name,        :type => String, :localize => has_translation_support
        field :title,       :type => String, :localize => has_translation_support
        field :description, :type => String, :localize => has_translation_support
        field :keywords,    :type => Array,  :default => []
        
        field :slug,      :type => String,  :default => nil
        field :position,  :type => Integer, :default => 0
        
        # Used as a unique identifier for things like page id's etc.
        field :identifier, :type => String  
          
        has_ancestry :orphan_strategy => :rootify, :cache_depth => true
        field :ancestry_depth, :type => Integer, :default => 0
        
        # Stores an array of paths/slugs based on the page's level in the tree
        field :slug_map,  :type => Array, :default => []
        
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
        before_create :generate_heirarchy
        before_save :generate_paths
        before_create :generate_identifier
        has_and_belongs_to_many :content_blocks
        
        validates_presence_of :title, :name
        validates_presence_of :slug, :allow_blank => true
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
        def from_path(p)
          where(:slug_map => p.split("/"))
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
        return self.slug if [self.slug_map].flatten.compact.empty?
        self.slug_map.dup.join("/")
      end
      
      ##
      # Used to set keywords via comma separated string
      # 
      def keyword_list=(words)
        self.keywords = words.split(",").compact.map!(&:strip)
      end
      
      ##
      # Display keywords as a comma separated string.
      # 
      def keyword_list
        self.keywords.join(",")
      end
      
      ##
      # Does this page have children?
      # 
      def pages?
        self.send(:"#{self.class.name.pluralize.underscore}").published.exists?
      end
      
      ##
      # Override the slug setter to ensure 
      # clean urls.
      # 
      def slug=(value)
        write_attribute(:slug, _sanitize_uri_fragment(value.to_s))
      end
      
      private
      
      ##
      # Build the cache and heirarchy of pages
      # 
      def generate_heirarchy
        #cache_depth
        self.position = self.siblings.count
      end
      
      ##
      # Generates an array of slugs based on this page's nesting in the tree. 
      # When a page belongs to another (and even another) the resulting path stack 
      # should represent the full url to that page.
      # 
      #  
      def generate_paths
        parts = [self.ancestors(:to_depth => self.depth).collect(&:slug), self.slug].flatten.compact
        self.slug_map = parts.map do |part|
          _sanitize_uri_fragment(part)
        end.reject(&:blank?)
        
        # once the path is built, set the slug unless previously set
        write_attribute(:slug, self.full_path) if self.slug.nil?
        true
      end
      
      ##
      # On creation, if the identifier is nil, generate it from the name.
      # 
      def generate_identifier
        self.identifier ||= self.name.to_s.to_slug.underscore
      end
      
      ##
      # In the event slugs are entered by end-users, this ensures they are 
      # always truncated to non-absolute paths. It also checks against 
      # duplication of parent slug/path values.
      # 
      def sanitize_path_names
        unless self.parent.nil?
          slug_parts   = self.slug.to_s.split("/").compact
          parent_parts = self.parent.slug_map.dup
          self.slug    = slug_parts.drop_while{ |part| part == parent_parts.shift }.join("/")
        end
        unless [self.slug_map].flatten.compact.empty?
          self.slug_map.map!{ |part| _sanitize_uri_fragment(part) }
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