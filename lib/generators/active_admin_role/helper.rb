module ActiveAdminRole
  module Generators
    module Helper
      def self.included(klass)
        klass.send :extend, ClassMethods
      end

      private

        def model_class_name
          options[:model] ? options[:model].classify : "AdminUser"
        end

        def model_file_path
          model_name.underscore
        end

        def model_path
          @model_path ||= File.join("app", "models", "#{model_file_path}.rb")
        end

        def namespace
          Rails::Generators.namespace if Rails::Generators.respond_to?(:namespace)
        end

        def namespaced?
          !!namespace
        end

        def model_name
          if namespaced?
            [namespace.to_s] + [model_class_name]
          else
            [model_class_name]
          end.join("::")
        end

        def inject_into_model
          indents = "  " * (namespaced? ? 2 : 1)
          inject_into_class model_path, model_class_name, "#{indents}role_based_authorizable\n"
        end

        def migration_class_name
          if Rails::VERSION::MAJOR >= 5
            "ActiveRecord::Migration[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
          else
            "ActiveRecord::Migration"
          end
        end

        module ClassMethods
          # Define the next_migration_number method (necessary for the migration_template method to work)
          def next_migration_number(dirname)
            if ActiveRecord::Base.timestamped_migrations
              sleep 1 # make sure each time we get a different timestamp
              Time.new.utc.strftime("%Y%m%d%H%M%S")
            else
              "%.3d" % (current_migration_number(dirname) + 1)
            end
          end
        end
    end
  end
end
