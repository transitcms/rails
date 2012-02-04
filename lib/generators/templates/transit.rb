# Use this file to configure any default / global options.
Transit.configure do |config|
  
  ##
  # Enable translations globally. This will enable 
  # translation support for any model which acts as a deliverable.
  # To enable support on a per-model basis, pass :translate => true to the 
  # deliver_as method.
  # 
  #config.translate = false

  ##
  # Global asset configuration. These options are applied
  # directly to the has_attached_file method within the Asset class.
  # 
  #config.assets.styles    = {}
  #config.assets.storage   = :filesystem
  #config.assets.path      = ":rails_root/public/system/assets/:id/:style.:extension"
  #config.assets.url       = "/system/assets/:id/:style.:extension"

  ##
  # When using the publishing extension, by default published state 
  # is determined by checking the value of the 'published' attribute 
  # as well as 'publish_date'. Items are considered published if true, and the
  # publish_date is on or before the current date. Set this to false to only 
  # utilize the 'published' attribute.
  # 
  #config.publish_with_date = true

end