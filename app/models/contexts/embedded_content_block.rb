##
# Wraps a ContentBlock to be used as a context within a block of content.
# 
class EmbeddedContentBlock < Context
  
  belongs_to :content_block
  delegate :deliver, :to => :content_block
  
end