class AltTextBlock < TextBlock  
  def deliver
    false
  end  
end

class UndeliverableContext < Context
end

Transit::Delivery.configure(:alt_text_block) do |context|
  content_tag(:p, context.body)
end