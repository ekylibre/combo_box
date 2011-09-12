module ComboBox
  module Helpers
    module FormTagHelper

      
      # Returns the list of columns to use in the combo_box for displaying
      # the current item
      # @param [String, Symbol] action_name Name of the 'search_for' action
      # @param [String, Symbol] controller_name Name of the controller of the 'search_for' action
      #
      # @return [Array] Lists of symbols corresponding to the 'search_for' columns's names
      def search_columns_for(action, controller=nil)
        method_name = "search_columns_for_#{action}_in_#{controller}"
        if self.respond_to?(method_name)
          return self.send(method_name)
        else
          return nil
        end
      end


      # Returns a text field which has the same behavior of +select+ but  with a search 
      # action which permits to find easily in very long lists...
      #
      # @param [Symbol] object_name Name of the used instance variable
      # @param [Symbol] method Attribute to control
      # @param [Symbol,String,Hash] choices 
      #   Name of data source like specified in `search_for` or a specific URL 
      #   in its String form (like `"orders#search_for"`) or in its Hash form
      # @param [Hash] options Options to build the control
      # @param [Hash] html_options Extra-attributes to add to the tags
      #
      # @return [String] HTML code of the tags
      def combo_box(object_name, method, choices = nil, options = {}, html_options = {})
        object = instance_variable_get("@#{object_name}")
        label = []
        if choices.is_a? Symbol
          columns = object.class.columns.collect{|c| c.name.to_s}
          label = options.delete(:label)||columns
          label = [label] unless label.is_a? Array
          label.each_index do |i| 
            if columns.include?(label[i])
              label[i] = label[i].to_s            
            else
              raise ArgumentError.new("Option :label must only contains columns of the model like: #{columns.inspect} and not #{label.inspect}")
            end
          end
        else
          label = send("columns_for_#{controller_name}_#{choices}_combo_box")
        end
        associated = object.send(method)
        html  = ""
        html << tag(:input, :type=>:text, "data-combo-box"=>url_for(choices.merge(:format=>:json)), "data-value-container"=>"#{object_name}_#{method}", :value=>(associated ? label.collect{|c| associated[c]} : nil), :size=>html_options.delete(:size)||32)
        html << hidden_field(object_name, method, html_options)
        return html.html_safe
      end

      # Returns a text field which has the same behavior of +select+ but  with a search 
      # action which permits to find easily in very long lists.
      #
      # @param [Symbol] name Name of the field
      # @param [Symbol,String,Hash] choices 
      #   Name of data source like specified in `search_for` or a specific URL 
      #   in its String form (like `"orders#search_for"`) or in its Hash form
      # @param [Hash] options Options to build the control
      # @param [Hash] html_options Extra-attributes to add to the tags
      #
      # @option options [String] label Default label to display
      #
      # @return [String] HTML code of the tags
      def combo_box_tag(name, choices = nil, options={}, html_options = {})
        if choices.nil? or choices == controller_name.to_sym
          choices = {:action=>"search_for"}
        elsif choices.is_a?(Symbol)
          choices = {:action=>"search_for_#{choices}"}
        elsif choices.is_a?(String)
          action = choices.split(/\#+/)
          choices = {:action=>"search_for_#{action[1]}", :controller=>action[0]}
        end
        html  = ""
        html << tag(:input, :type=>:text, "data-combo-box"=>url_for(choices.merge(:format=>:json)), "data-value-container"=>name, :size=>html_options.delete(:size)||32, :value=>options.delete(:label))
        html << hidden_field_tag(name, html_options.delete(:value), html_options)
        return html.html_safe
      end

    end
  end
end
