module Transit
  module Definition
    
    module Post
      
      extend ActiveSupport::Concern
      
      included do
        field :title,           :type => String
        field :post_date,       :type => DateTime
        field :slug,            :type => String
        field :teaser,          :type => String
        field :published,       :type => Boolean, :default => false
      end
      
    end # Post
  end # Definition
end # Transit