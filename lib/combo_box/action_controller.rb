module ComboBox
  module ActionController

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods


      # Generates a default action for combox_box or combo_box_tag
      #
      def search_for(belongs_to, options={})
        method_name = "#{__method__}_#{belongs_to}"
        Generator::Base.generate_controller_action(method_name, controller_name, options)
      end

    end

  end
end
