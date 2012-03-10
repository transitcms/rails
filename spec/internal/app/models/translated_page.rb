class TranslatedPage
  include Transit::Deliverable
  deliver_as :page, :translate => true
  
end