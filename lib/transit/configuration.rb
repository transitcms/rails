## 
# Setup default configuration options
# 
module Transit
  
  # Enable translations globally
  config.translate = false
  
  ## 
  # Asset configuration. These properties are applied 
  # directly to paperclip's `has_attached_file` method.
  # 
  config.assets           = ::ActiveSupport::OrderedOptions.new
  config.assets.styles    = {}
  config.assets.storage   = :filesystem
  config.assets.path      = ":rails_root/public/system/assets/:id/:style.:extension"
  config.assets.url       = "/system/assets/:id/:style.:extension"
  
  ##
  # View paths
  # 
  config.template_base_path = nil
  
  ##
  # When using the publishing extension, should a publish_date be used?
  # 
  config.publish_with_date = true
  
  # When in management mode, the tag that wraps each context when output.
  config.field_wrapper = :li

end