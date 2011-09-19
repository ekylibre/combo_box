require 'combo_box/railtie' if defined?(::Rails)
require 'combo_box/engine' if defined?(::Rails)

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
