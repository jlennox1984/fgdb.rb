module ActiveRecord
  module ConnectionAdapters
    # TODO -- Add Aggregates ability
    class PostgreSQLAdapter < AbstractAdapter
      include SchemaProcs

      def procedures(lang=nil)
        query <<-end_sql
          SELECT P.oid, proname, pronamespace, proowner, lanname, proisagg, prosecdef, proisstrict, proretset, provolatile, pronargs, prorettype, proargtypes, proargnames, prosrc, probin, proacl
            FROM pg_proc P
            JOIN pg_language L ON (P.prolang = L.oid)
            JOIN pg_namespace N ON (P.pronamespace = N.oid)
           WHERE N.nspname = 'public'
             AND (proisagg = 'f')
            #{'AND (lanname ' + lang + ')'unless lang.nil?}
        end_sql
      end

      def triggers(table_name)
        query(<<-end_sql).collect {|row| TriggerDefinition.new(*row) }
          SELECT T.oid, C.relname, T.tgname, T.tgtype, P.proname
            FROM pg_trigger T
            JOIN pg_class   C ON (T.tgrelid = C.OID AND C.relname = '#{table_name}')
            JOIN pg_proc    P ON (T.tgfoid = P.OID)
            WHERE T.tgname NOT LIKE 'RI_ConstraintTrigger%'
        end_sql
      end

      def types
        result = query(<<-end_sql)
          SELECT T.oid, T.typname, A.attname, format_type(A.atttypid, A.atttypmod) AS type
            FROM pg_type      T
            JOIN pg_class     C ON (T.typrelid = C.oid)
            JOIN pg_attribute A ON (A.attrelid = C.oid AND C.relkind = 'c')
        end_sql

        type_id = nil
        types = []
        result.each { |row|
          if type_id != row[0]
            types << TypeDefinition.new(row[0], row[1], [])
            type_id = row[0]
          end

          types.last.columns << [row[2], row[3]]
        }

        types
      end

      def create_type(name, *columns)
        drop_type(name) if types.find {|typ| typ.name == name.to_s }
        execute get_type_query(name, *columns)
      end
      
      def drop_type(name, cascade=false)
        execute "DROP TYPE #{name} #{cascade_or_restrict(cascade)}"
      end

#     Add a trigger to a table
      def add_trigger(table, events, options={})
        events += [:row]    if options.delete(:row)
        events += [:before] if options.delete(:before)
        trigger = TriggerDefinition.new(0, table, options[:name], events, options[:function])
        execute trigger.to_sql_create
      end

#      DROP TRIGGER name ON table [ CASCADE | RESTRICT ]
      def remove_trigger(table, name, options={})
        options[:name] = name
        execute "DROP TRIGGER #{trigger_name(table, [], options).to_sql_name} ON #{table} #{cascade_or_restrict(options[:deep])};"
      end

#      Create a stored procedure
      def create_proc(name, columns=[], options={}, &block)
        if select_value("SELECT count(oid) FROM pg_language WHERE lanname = 'plpgsql' ","count").to_i == 0
#          execute("CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler AS '$libdir/plpgsql', 'plpgsql_call_handler' LANGUAGE c")
          execute("CREATE TRUSTED PROCEDURAL LANGUAGE plpgsql HANDLER plpgsql_call_handler")
        end

        if options[:force]
          drop_proc(name, columns) rescue nil
        end

        if block_given?
          execute get_proc_query(name, columns, options) { yield }
        elsif options[:resource]
          execute get_proc_query(name, columns, options)
        else
          raise StatementInvalid.new("Missing function source")
        end
      end

#      DROP FUNCTION name ( [ type [, ...] ] ) [ CASCADE | RESTRICT ]
#     default RESTRICT
      def drop_proc(name, columns=[], cascade=false)
        execute "DROP FUNCTION #{name.to_sql_name}(#{columns.collect {|column| column}.join(", ")}) #{cascade_or_restrict(cascade)};"
      end

      private
        def trigger_name(table, events=[], options={})
          options[:name] || MyInflector.triggerize(table, events, options[:before])
        end

#       Helper function that builds the sql query used to create a stored procedure.
#       Mostly this is here so we can unit test the generated sql.
#       Either an option[:resource] or block must be defined for this method. 
#       Otherwise an ActiveRecord::StatementInvalid exception is raised.
#       Defaults are: 
#          RETURNS (no default -- which is cheap since that means you have to call this method w/ the options Hash) TODO: fix this
#          LANGUAGE = plpgsql (The plugin will add this if you don't have it added already)
#          behavior = VOLATILE (Don't specify IMMUTABLE or STABLE and this will be added for you)
#          strict = CALLED ON NULL INPUT (Otherwise STRICT, According to the 8.0 manual STRICT and RETURNS NULL ON NULL INPUT (RNONI)
#		     behave the same so I didn't make a case for RNONI)
#          user = INVOKER
        def delim(name, options)
          options[:delim] || "$#{(name.underscore)}_body$"
        end
          
#       From PostgreSQL
##      CREATE [ OR REPLACE ] FUNCTION
##          name ( [ [ argmode ] [ argname ] argtype [, ...] ] )
##          [ RETURNS rettype ]
##        { LANGUAGE langname
##          | IMMUTABLE | STABLE | VOLATILE
##          | CALLED ON NULL INPUT | RETURNS NULL ON NULL INPUT | STRICT
#          | [ EXTERNAL ] SECURITY INVOKER | [ EXTERNAL ] SECURITY DEFINER
##          | AS 'definition'
#          | AS 'obj_file', 'link_symbol'
#        } ...
#          [ WITH ( isStrict &| isCacheable ) ]
		# TODO Implement [ [ argmode ] [ argname ] argtype ]
        def get_proc_query(name, columns=[], options={}, &block)
          returns = ''
          if options.has_key?(:return)
            returns = "RETURNS#{' SETOF' if options[:set]} #{options[:return] || 'VOID'}"
          end
          lang = options[:lang] || "plpgsql"

          if block_given?
            body = "#{delim(name, options)}\n#{yield}\n#{delim(name, options)}"
          elsif options[:resource]
            options[:resource] += [name] if options[:resource].size == 1
            body = options[:resource].collect {|res| "'#{res}'" }.join(", ")
          else
            raise StatementInvalid.new("Missing function source")
          end
          
          result = "
		  CREATE OR REPLACE FUNCTION #{name.to_sql_name}(#{columns.collect{|column| column}.join(", ")}) #{returns} AS
			#{body}
			LANGUAGE #{lang}
			#{ behavior(options[:behavior] || 'v').upcase }
			#{ strict_or_null(options[:strict]) }
			EXTERNAL SECURITY #{ definer_or_invoker(options[:definer]) }
		  "
        end

        def get_type_query(name, *columns)
          raise StatementInvalid.new if columns.empty?
          "CREATE TYPE #{quote_column_name(name)} AS (
            #{columns.collect{|column,type|
					if column.is_a?(Hash)
					column.collect { |column, type| "#{quote_column_name(column)} #{type}" }
					else
					"#{quote_column_name(column)} #{type}"
					end
							}.join(",\n")}
						)"
        end
    end
  end
end
