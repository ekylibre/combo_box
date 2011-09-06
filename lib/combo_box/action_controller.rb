module ComboBox
  module ActionController

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods


      # Generates a default action which is the resource for a combo_box.
      # It generates an helper which takes in account selected columns for displaying.
      # 
      # @param [Symbol] name
      #   Name of the datasource. If the option `:model` is not used, this name is used to
      #   find a reflection or if there is no reflection, the name is used as the model name
      #
      # @param [Hash] options Options to build controller action
      #
      # @option options [Symbol] :model Force the use of a specific model
      # @option options [Array] :columns The columns which are used for search and display
      #   All the content columns are used by default.
      # @option options [Array,Hash] :conditions Default conditions used in the search query
      # @option options [String, Hash, Array] :joins To make a join like in `find`
      # @option options [Integer] :limit (80) Maximum count of items in results
      # @option options [String] :partial Specify a partial for HTML autocompleter
      # @option options [String] :filter ('%X%') Filter format used to build search query. 
      #   Specific filters can be specified for each column. 
      #
      # @example Classic use: Search in all the clients
      #   # app/controller/orders_controller.rb
      #   class OrdersController < ApplicationController
      #     ...
      #     search_for :client
      #     ...
      #   end
      # 
      # @example Search all accounts where `name` contains search and number starts with search
      #   # app/controller/orders_controller.rb
      #   class PeopleController < ApplicationController
      #     ...
      #     search_for :account, :columns=>[:name, 'number:X%']
      #     ...
      #   end
      #   
      def search_for(name, options={})
        method_name = "#{__method__}_#{belongs_to}"
        generator = Generator::Base.new(self, options)
        generator.controller_action(method_name)
      end

    end

  end
end
