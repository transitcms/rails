##
# Defines a plain block of html based content to be output 
# directly to the page. Typically used with wysiwyg editors etc.
# 
# 
class TextBlock < Context
  
  field :body, :type => HtmlContent, :default => "<p>type content here</p>", :localize => has_translation_support
  
  # Identify the amount of 'editability' supported by this this contect. This is mostly used 
  # on the front-end when implementing rich-text editors etc to know the level of functionality needed.
  # Set the values as necessary depending on your front-end implementation. A good practice is to 
  # use names that can translate to your editor options.
  # 
  field :features, :type => Array, :default => ['text', 'link', 'image']
  
  ##
  # Sanitize the body content if enabled.
  # 
  if Transit.config.sanitize_html_content == true
    deliver_with :html_sanitization
  end
  
  ##
  # Contexts are delivered either internally or via helper method. 
  # If the deliver method exists on a resource, it is used. 
  # In this case, text blocks always simply deliver their content.
  # 
  def deliver
    self.body.to_s.html_safe
  end
  
  def as_json(options = {})
    options.merge!({ :only => [:body] })
    super(options)
  end

end