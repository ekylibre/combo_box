module ComboBox
  module Helpers
    module FormTagHelper

      
      # Returns a text field which has the same behavior of +select+ but  with a search 
      # action which permits to find easily in very long lists...
      def combo_box(object_name, method, choices_url = nil, options = {}, html_options = {})
        object = instance_variable_get("@#{object_name}")
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
        associated = object.send(method)
        html  = ""
        html << tag(:input, :type=>:text, "data-combo-box"=>url_for(choices_url.merge(:format=>:json, :columns=>label.join(','))), "data-value-container"=>"#{object_name}_#{method}", :value=>(associated ? label.collect{|c| associated[c]} : nil), :size=>html_options.delete(:size)||32)
        html << hidden_field(object_name, method, html_options)
        return html.html_safe
      end

      def combo_box_tag(name, choices_url = nil, options={}, html_options = {})
        label = options.delete(:label)||columns
        label = [label] unless label.is_a? Array
        html  = ""
        html << tag(:input, :type=>:text, "data-combo-box"=>url_for(choices_url.merge(:format=>:json, :columns=>label.join(','))), "data-value-container"=>name, :size=>html_options.delete(:size)||32)
        html << hidden_field_tag(name, html_options)
        return html.html_safe
      end

    end
  end
end
