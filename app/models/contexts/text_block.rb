##
# Defines a plain block of html based content to be output 
# directly to the page. Typically used with wysiwyg editors etc.
# 
# 
class TextBlock < Context
  field :body, :type => HtmlContent, :default => "<p>type content here</p>", :localize => has_translation_support
  
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