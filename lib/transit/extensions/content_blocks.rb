module Transit
  module Extension
    ##
    # Deliverables can reference any number of content blocks, which act somewhat like 
    # mini "pages" that simply display a list of contexts. 
    # 
    # ContentBlock's have a `name` attribute which can be used to identify one block over another 
    # when a deliverable references many of them. Typically ContentBlocks are usually not user-defined 
    # but are created during development for end-users to manage unique pieces of content.
    # 
    module ContentBlocks
      extend ActiveSupport::Concern
      
      included do
        has_and_belongs_to_many :content_blocks
        ::ContentBlock.send(:has_and_belongs_to_many, :"#{self.class.name.pluralize.underscore}", :inverse_of => nil)
      end
      
    end # ContentBlocks
  end # Extensions
  # 
end # Transit