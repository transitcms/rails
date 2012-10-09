##
# Defines a h1-h6 text heading. To help keep html semantic and clean, and to help 
# with styling, this is provided separately from the TextBody.
# 
#
class HeadingText < Context
  class_attribute :node_types
  self.node_types = (1..6).to_a.collect{ |h| ["Heading #{h}", "h#{h}"] }

  field :body, :type => String, :default => 'Heading Text', :localize => has_translation_support
  field :node, type: String, default: "h2"
  
  before_save :cleanup_body
  
  ##
  # Include the node and body within 
  # the JSON hash.
  # 
  def serializable_hash(options = {})
    options.reverse_merge!({ :only => [:body, :node] })
    super(options)
  end
  
  private
  
  ##
  # Strip useless info from the body
  # 
  def cleanup_body
    self.body = self.body.to_s.chomp.strip.gsub("\n", " ")
  end
  
end