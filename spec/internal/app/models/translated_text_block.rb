class TranslatedTextBlock < TextBlock
  enable_translation
  
  with_optional_translation do
    field :translated_body, :type => String
  end
  
end