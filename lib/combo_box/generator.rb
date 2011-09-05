module ComboBox
  module Generator

    class Base

      def self.generate_controller_code(controller_name, options={})
        model = (options[:model]||controller_name).to_s.classify.constantize


        # def mono_choice_search_code(field)
        source_model = field_datasource_class_name(field).constantize
        # reflection = source_model.reflections[field.choices]
        # if reflection.nil?
        #   raise Exception.new("#{source_model.name} must have a reflection :#{field.choices}.")
        # end
        model = field.reflection.class_name.constantize #reflection.class_name.constantize
        foreign_record  = model.name.underscore
        foreign_records = "#{source_model.name.underscore}_#{field.choices}"
        options = field.options
        attributes = field.search_attributes
        attributes = [attributes] unless attributes.is_a? Array
        attributes_hash = {}
        attributes.each_index do |i|
          attribute = attributes[i]
          attributes[i] = [
                           (attribute.to_s.match(/\./) ? attribute.to_s : model.table_name+'.'+attribute.to_s.split(/\:/)[0]),
                           (attribute.to_s.match(/\:/) ? attribute.to_s.split(/\:/)[1] : (options[:filter]||'%X%')),
                           '_a'+i.to_s]
          attributes_hash[attributes[i][2]] = attributes[i][0]
        end
        query = []
        parameters = ''
        if options[:conditions].is_a? Hash
          options[:conditions].each do |key, value| 
            query << (key.is_a?(Symbol) ? model.table_name+"."+key.to_s : key.to_s)+'=?'
            parameters += ', ' + sanitize_conditions(value)
          end
        elsif options[:conditions].is_a? Array
          conditions = options[:conditions]
          case conditions[0]
          when String  # SQL
            #               query << '["'+conditions[0].to_s+'"'
            query << conditions[0].to_s
            parameters += ', '+conditions[1..-1].collect{|p| sanitize_conditions(p)}.join(', ') if conditions.size>1
            #                query << ')'
          else
            raise Exception.new("First element of an Array can only be String or Symbol.")
          end
        end
        
        select = (model.table_name+".id AS id, "+attributes_hash.collect{|k,v| v+" AS "+k}.join(", ")).inspect
        
        code  = ""
        code << "conditions = [#{query.join(' AND ').inspect+parameters}]\n"
        code << "search = params[:term]\n"
        code << "words = search.to_s.mb_chars.downcase.strip.normalize.split(/[\\s\\,]+/)\n"
        code << "if words.size > 0\n"
        code << "  conditions[0] << '#{' AND ' if query.size>0}('\n"
        code << "  words.each_index do |index|\n"
        code << "    word = words[index].to_s\n"
        code << "    conditions[0] << ') AND (' if index > 0\n"

        if ActiveRecord::Base.connection.adapter_name == "MySQL"
          code << "    conditions[0] << "+attributes.collect{|key| "LOWER(CAST(#{key[0]} AS CHAR)) LIKE ?"}.join(' OR ').inspect+"\n"
        else
          code << "    conditions[0] << "+attributes.collect{|key| "LOWER(CAST(#{key[0]} AS VARCHAR)) LIKE ?"}.join(' OR ').inspect+"\n"
        end

        code << "    conditions += ["+attributes.collect{|key| key[1].inspect.gsub('X', '"+word+"').gsub(/(^\"\"\+|\+\"\"\+|\+\"\")/, '')}.join(", ")+"]\n"
        code << "  end\n"
        code << "  conditions[0] << ')'\n"
        code << "end\n"

        # joins = options[:joins] ? ", :joins=>"+options[:joins].inspect : ""
        # order = ", :order=>"+attributes.collect{|key| "#{key[0]} ASC"}.join(', ').inspect
        # limit = ", :limit=>"+(options[:limit]||80).to_s
        joins = options[:joins] ? ".joins(#{options[:joins].inspect})" : ""
        order = ".order("+attributes.collect{|key| "#{key[0]} ASC"}.join(', ').inspect+")"
        limit = ".limit(#{options[:limit]||80})"

        partial = options[:partial]

        html  = "<ul><%for #{foreign_record} in #{foreign_records}-%><li id='<%=#{foreign_record}.id-%>'>" 
        html << "<%content=#{foreign_record}.#{field.item_label}-%>"
        # html << "<%content="+attributes.collect{|key| "#{foreign_record}['#{key[2]}'].to_s"}.join('+", "+')+" -%>"
        if partial
          html << "<%=render(:partial=>#{partial.inspect}, :locals =>{:#{foreign_record}=>#{foreign_record}, :content=>content, :search=>search})-%>"
        else
          html << "<%=highlight(content, search)-%>"
        end
        html << '</li><%end-%></ul>'

        # code << "#{foreign_records} = #{field_datasource(field)}.find(:all, :conditions=>conditions"+joins+order+limit+")\n"
        code << "#{foreign_records} = #{field_datasource(field).gsub(/\.all$/, '')}.where(conditions)"+joins+order+limit+"\n"
        # Render HTML is old Style
        code << "respond_to do |format|\n"
        code << "  format.html { render :inline=>#{html.inspect}, :locals=>{:#{foreign_records}=>#{foreign_records}, :search=>search} }\n"
        code << "  format.json { render :json=>#{foreign_records}.collect{|#{foreign_record}| {:label=>#{foreign_record}.#{field.item_label}, :id=>#{foreign_record}.id}}.to_json }\n"
        code << "  format.xml { render :xml=>#{foreign_records}.collect{|#{foreign_record}| {:label=>#{foreign_record}.#{field.item_label}, :id=>#{foreign_record}.id}}.to_xml }\n"
        code << "end\n"      
        return code
      end


      def self.generate_controller_action(name, options={})
        code  = "def #{action}\n"
        code << Generator::Base.generate_controller_code(options).strip.gsub(/^/, '  ')+"\n"
        code << "end\n"
        return code
      end

    end

  end

end
