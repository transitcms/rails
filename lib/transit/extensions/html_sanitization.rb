module Transit
  module Extension
    ##
    # Deliverables can reference any number of content blocks, which act somewhat like 
    # mini "pages" that simply display a list of contexts. 
    # 
    # Content Blocks have a `name` attribute which can be used to identify one block over another 
    # when a deliverable references many of them. Typically ContentBlocks are usually not user-defined 
    # but are created during development for end-users to manage unique pieces of content.
    # 
    module HtmlSanitization
      extend ActiveSupport::Concern
      
      included do
        before_save :sanitize_body
      end
      
      ##
      # Take a model's "body" attribute, and sanitize it.
      # TODO: Implement sanitizer
      # 
      def sanitize_body
      end
      
    end # ContentBlocks
  end # Extensions
  # 
end # Transit