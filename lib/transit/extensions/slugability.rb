module Transit
  module Extension
    ##
    # Includes functionality for creating url slugs 
    # for deliverable models.
    # 
    module Slugability
      extend ActiveSupport::Concern
      
      ##
      # Takes the models interpolation string and 
      # generates a slug. By default this is simply :title
      # 
      def interpolate_slug
        interpolation = self.class.delivery_options_for(:slugability)
        ::Transit::Interpolations.interpolate(interpolation, self)
      end
    end
    
  end
end