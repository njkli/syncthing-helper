module Syncthing
  module Helper
    module CLI
      module InstanceMethods
        # DB_FIELDS = {'devices' => [:device_id, :label],
        #              'folders' => [:id, :path, :label]}

        def tabled_stdout header: nil, rows: nil
          puts (TTY::Table.new header: header, rows: rows).
                 render(:unicode, alignment: [:center], multiline: true)
        end

        def query
          API::DB_FIELDS[col].map do |f|
            API::Firestore.col(col).where(f, :eq, @ident)
          end.map(&:get).find(&:first)
        end

        def delete_record
          idents.each do |ident|
            @ident = ident
            query ? API::Firestore.doc(col + '/' + query.first.document_id).delete : puts('record not found')
          end
        end

        def col
          self.class.name.split('::').last.underscore.split('_').first.pluralize
        end

        def trigger_updates
          API::Firestore.col('folders').get.map(&:document_id).each do |d|
            API::Firestore.col('folders').doc(d).update(devices: [])
          end
          Logger.tagged('trigger') {Logger.debug 'Update firestore folders'}
        end
      end

      class AbstractCommand < Clamp::Command
        include InstanceMethods

        option "--version", :flag, "show version" do
          puts Syncthing::Helper::VERSION
          exit(0)
        end

        option ['-u', '--uri'], 'URI', 'Syncthing URI', environment_variable: 'SYNCTHING_URI', attribute_name: :syncthing_uri, default: 'http://127.0.0.1:8384'
        option ['-p', '--project'], 'GCP_PROJECT_ID', 'GCP project_id', environment_variable: 'GOOGLE_APPLICATION_PROJECT_ID', attribute_name: :gcp_project_id
        option ['-a', '--auth'], 'GCP_CREDS_JSON', 'Path to json keyfile', environment_variable: 'GOOGLE_APPLICATION_CREDENTIALS', attribute_name: :credentials
        option ['-l', '--log'], 'LOG_LEVEL', 'trace, debug, info, warn, error, fatal', environment_variable: 'SYNCTHING_LOG_LEVEL', attribute_name: :log_level, default: :info

        def execute
          SemanticLogger.default_level = log_level.downcase.to_sym
          API.init_firestore project_id: gcp_project_id, credentials: credentials
        end
      end
    end
  end
end
