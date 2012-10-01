require 'nokogiri'

module Transit
  ##
  # Takes HTML data and processes it into contexts to be used within a deliverable.
  # For consistency, the HTML should be quite basic, mostly heading tags, paragraphs, 
  # and items like audio/video.
  # 
  class Generator
    attr_reader :doc
    attr_reader :target
    
    ##
    # Initializes a new generator, using HTML data and a deliverable object
    # 
    # @param [data] String HTML content
    # @param [target] Object A deliverable object, or any class inheriting Transit::Deliverable
    # 
    def initialize(data, target)
      @target = target
      @doc    = ::Nokogiri::HTML(data)
    end
    
    def children
      doc.css('body').children
    end
    
    def contexts
      children.collect do |child|
        next nil if child.nil?
        type = child.name.downcase
        if type =~ /h[1-6]/
          ['HeadingText', { :node => type, :body => child.text.to_s.strip }]
        elsif type == 'div'
          [child.attr('data-context-type'), { :body => child.children.to_html.chomp.strip }]
        elsif ['audio','video'].include?(type)
          [type.classify, attrs_to_hash(child)]
        else
          nil
        end
      end.compact
    end
    
    private
    
    def attrs_to_hash(child)
      child.attributes.keys.inject({}) do |name, hash|
        hash.merge!(name => child.attr(name))
      end
    end
  end
end