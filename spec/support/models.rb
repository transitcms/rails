class AltTextBlock < TextBlock  
  def deliver
    false
  end  
end

class UndeliverableContext < Context
end

class InlineTextWithPartial < HeadingText
end