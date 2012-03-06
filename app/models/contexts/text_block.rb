##
# Defines a plain block of html based content to be output 
# directly to the page. Typically used with wysiwyg editors etc.
# 
# 
class TextBlock < Context
  with_optional_translation do
    field :body, :type => HtmlContent, :default => "<p>type content here</p>"
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