module Syncthing
  module Helper
    module CLI
      module InstanceMethods
        def tabled_stdout header: nil, rows: nil
          puts (TTY::Table.new header: header, rows: rows).
                 render(:unicode, alignment: [:center], multiline: true)
        end

        def doc_ref col: nil, ident: nil
          q = API::Firestore.col(col)
          q.where(:label, :eq, ident).get.first || q.where(fields_for(col), :eq, ident).get.first
        end
        private

        def fields_for col
          case col
          when /devices/
            :device_id
          when /folders/
            :id
          end
        end
      end

      class AbstractCommand < Clamp::Command
        include InstanceMethods

        option "--version", :flag, "show version" do
          puts Syncthing::Helper::VERSION
          exit(0)
        end
        option ['-c', '--config'], 'PATH', 'Path to syncthing config.xml, usually /var/lib/syncthing/config.xml or ~/.config/syncthing/config.xml', attribute_name: :xml_config
        option ['-k', '--key'], 'API_KEY', 'Syncthing Api key', environment_variable: 'SYNCTHING_API_KEY', attribute_name: :syncthing_api_key
        option ['-u', '--uri'], 'URI', 'Syncthing URI', environment_variable: 'SYNCTHING_URI', attribute_name: :syncthing_uri, default: 'http://127.0.0.1:8384'
        option ['-p', '--project'], 'GCP_PROJECT_ID', 'GCP project_id', environment_variable: 'GOOGLE_APPLICATION_PROJECT_ID', attribute_name: :gcp_project_id
        option ['-a', '--auth'], 'GCP_CREDS_JSON', 'Path to json keyfile', environment_variable: 'GOOGLE_APPLICATION_CREDENTIALS', attribute_name: :credentials

        def execute
          API.init_firestore  project_id: gcp_project_id, credentials: credentials
        end
      end
    end
  end
end
