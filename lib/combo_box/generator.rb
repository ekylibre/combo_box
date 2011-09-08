module ComboBox
  module Generator

    Column = Struct.new('Column', :name, :filter, :interpolation_key)

    class Base

      attr_accessor :action_name, :controller, :options

      def initialize(controller, action_name, model, options={})
        @controller = controller
        @action_name = action_name.to_sym
        @options = options
        @model = model
        columns = @options.delete(:columns)
        columns ||= model.content_columns.collect{|x| x.name.to_sym}
        columns = [columns] unless column.is_a? Array
        # Normalize columns
        count = 0
        @columns = columns.collect do |c| 
          c = c.to_s.split(/\:/) if [String, Symbol].include? c.class
          c = if c.is_a? Hash
                Column.new(c[:name], c[:filter], c[:interpolation_key])
              elsif c.is_a? Array
                Column.new(c[0], c[1], c[2])
              else
                raise Exception.new("Bad column: #{c.inspect}")
              end
          c.filter ||= @options[:filter]||'%X%'
          c.interpolation_key ||= c.name.gsub(/\W/, '_')
          c
        end
      end



      def controller_code()
        foreign_record  = @model.name.underscore
        foreign_records = @model.name.pluralize
        foreign_records = "many_#{foreign_records}" if foreign_record == foreign_records

        query = []
        parameters = ''
        if @options[:conditions].is_a? Hash
          @options[:conditions].each do |key, value| 
            query << (key.is_a?(Symbol) ? @model.table_name+"."+key.to_s : key.to_s)+'=?'
            parameters += ', ' + sanitize_conditions(value)
          end
        elsif @options[:conditions].is_a? Array
          conditions = @options[:conditions]
          if conditions[0].is_a?(String)  # SQL
            query << conditions[0].to_s
            parameters += ', '+conditions[1..-1].collect{|p| sanitize_conditions(p)}.join(', ') if conditions.size>1
          else
            raise Exception.new("First element of an Array can only be String or Symbol.")
          end
        end
        
        # select = "#{@model.table_name}.id AS id"
        # for c in @columns
        #   select << ", #{c.full_name} AS #{c.short_name}"
        # end
        
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

        # joins = @options[:joins] ? ", :joins=>"+@options[:joins].inspect : ""
        # order = ", :order=>"+attributes.collect{|key| "#{key[0]} ASC"}.join(', ').inspect
        # limit = ", :limit=>"+(@options[:limit]||80).to_s
        joins = @options[:joins] ? ".joins(#{@options[:joins].inspect}).include(#{@options[:joins].inspect})" : ""
        order = ".order("+@columns.collect{|c| "#{c.full_name} ASC"}.join(', ').inspect+")"
        limit = ".limit(#{@options[:limit]||80})"

        partial = @options[:partial]

        html  = "<ul><% for #{foreign_record} in #{foreign_records} -%><li id='<%=#{foreign_record}.id-%>'>" 
        html << "<% content = ::I18n.translate('views.combo_boxes.#{@controller.controller_name}.#{@action_name}', "+@columns.collect{|c| ":#{c.interpolation_key}=>#{foreign_record}.#{c.name}"}+")-%>"
        # html << "<%content="+#{foreign_record}.#{field.item_label}+" -%>"
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


      def controller_action(name, options={})
        code  = "def #{action}\n"
        code << Generator::Base.generate_controller_code(options).strip.gsub(/^/, '  ')+"\n"
        code << "end\n"
        return code
      end


      def view_code()
        code  = "def search_columns_for_#{@action_name}_in_#{@controller.controller_name}\n"
        code << "  return #{@columns.inspect}\n"
        code << "end\n"
        return code
      end

    end

  end

end
