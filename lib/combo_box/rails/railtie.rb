# encoding: utf-8
module ComboBox
  class Railtie < Rails::Railtie
    initializer 'formize.initialize' do
      ActiveSupport.on_load(:action_view) do
        include ComboBox::Helpers::FormTagHelper
      end
      ActiveSupport.on_load(:action_controller) do
        include ComboBox::ActionController
      end
    end
  end
end
