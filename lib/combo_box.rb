require 'combo_box/rails/railtie' if defined?(::Rails)
require 'combo_box/rails/engine' if defined?(::Rails)

# :include: ../README.rdoc
module ComboBox
  extend ActiveSupport::Autoload

  # Module used to "stock" labelling methods for items
  module CompiledLabels
  end
  
  autoload :Helpers
  autoload :Generator
  autoload :ActionController
end
