module ComboBox
  module Helpers
    module FormTagHelper


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
        if choices.nil?
          choices = {:action=>"search_for_#{method}"}
        elsif choices.is_a?(Symbol)
          choices = {:action=>"search_for_#{choices}"}
        elsif choices.is_a?(String)
          action = choices.split(/\#+/)
          choices = {:action=>action[1], :controller=>action[0]}
        end
        choices[:controller] ||= options.delete(:controller) || controller.controller_name
        unless ComboBox::CompiledLabels.methods.include?("item_label_for_#{choices[:action]}_in_#{choices[:controller]}".to_sym)
          needed_controller = "#{choices[:controller].to_s.classify.pluralize}Controller"
          needed_controller.constantize
          unless ComboBox::CompiledLabels.methods.include?("item_label_for_#{choices[:action]}_in_#{choices[:controller]}".to_sym)
            raise Exception.new("It seems there is no search_for declaration corresponding to #{choices[:action]} in #{needed_controller}")
          end
        end
        html_options[:id] ||= "#{object_name}_#{method}"
        html  = ""
        html << tag(:input, :type=>:text, "data-combo-box"=>url_for(choices.merge(:format=>:json)), "data-value-container"=>html_options[:id], :value=>ComboBox::CompiledLabels.send("item_label_for_#{choices[:action]}_in_#{choices[:controller]}", object.send(method.to_s.gsub(/_id$/,''))), :size=>html_options.delete(:size)||32)
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
          choices = {:action=>action[1], :controller=>action[0]}
        end
        choices[:controller] ||= options.delete(:controller) || controller.controller_name
        html_options[:id] ||= name.to_s.gsub(/\W+/, '_').gsub(/(^_+|_+$)/, '')
        html  = ""
        html << tag(:input, :type=>:text, "data-combo-box"=>url_for(choices.merge(:format=>:json)), "data-value-container"=>html_options[:id], :size=>html_options.delete(:size)||32, :value=>options.delete(:label))
        html << hidden_field_tag(name, html_options.delete(:value), html_options)
        return html.html_safe
      end

    end
  end
end
