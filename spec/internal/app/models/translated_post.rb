class TranslatedPost
  include Transit::Deliverable
  deliver_as :post, :translate => true
  
end