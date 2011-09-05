require 'combo_box/railtie' if defined?(::Rails)
require 'combo_box/engine' if defined?(::Rails)

# :include: ../README.rdoc
module ComboBox
  extend ActiveSupport::Autoload
  
  autoload :Helpers
  autoload :ActionController
end
