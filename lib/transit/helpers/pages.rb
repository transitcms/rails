module Transit
  module Helpers
    ##
    # General helpers for display and manipulation of pages.
    # 
    module Pages
      ##
      # Takes a colletion of root nodes/pages
      # and generates sets of nested ordered lists
      # 
      def transit_page_tree(roots, options = {}, &block)
        
        wrap_attrs = options.delete(:wrapper) || :ul
        unless wrap_attrs.is_a?(Hash)
          wrapper    = wrap_attrs
          wrap_attrs = {}
        else
          wrapper = wrap_attrs.delete(:tag) || :ul
        end
        
        # TODO: Why doesn't rails like to use the assigned result of this?
        content_tag(wrapper, Transit::Helpers.merge_tag_classes('page-tree', wrap_attrs)) do
          roots.each do |page|
            next unless page.is_root?
            concat transit_page_leaves(page, wrapper, wrap_attrs, options, &block)
          end
        end
      end

      ##
      # Handles generating nested sub-tree lists
      # for the page tree
      #  
      def transit_page_leaves(node, wrapper, wrap_attrs, options, &block)
        tag_attrs = options.delete(:item)
        tag_attrs = :li if tag_attrs.nil?
        
        unless tag_attrs.is_a?(Hash)
          tag       = tag_attrs
          tag_attrs = {}
        else
          tag = tag_attrs.delete(:tag)
        end
        
        tag = :li if tag.nil?
        
        if node.has_children?
          result = [
            capture(node, &block),
            content_tag(wrapper, Transit::Helpers.merge_tag_classes('sub-tree', wrap_attrs)) do 
              node.children.collect{ |child| transit_page_leaves(child, wrapper, wrap_attrs, options, &block) }.join.html_safe
            end
          ].join.html_safe
        else
          result = capture(node, &block)
        end
        
        unless tag == false
          return content_tag(tag, result, tag_attrs.merge!(data: { page_id: node.id.to_s }))
        end
        result
      end
    end
    
  end
end