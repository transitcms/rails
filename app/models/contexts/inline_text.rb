##
# Defines a inline block of html based content to be output 
# directly to the page. Default use is for headings (h1/h2/etc).
# 
#
class InlineText < Context
  class_attribute :node_types
  self.node_types = [['Heading 2', 'h2'],['Heading 3', 'h3']]

  with_optional_translation do
    field :body, :type => String
  end  
  
  field :node, type: String, default: "h2"  
end