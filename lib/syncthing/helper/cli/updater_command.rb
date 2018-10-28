module Syncthing
  module Helper
    module CLI
      class UpdaterCommand < AbstractCommand
        option ['-k', '--key'], 'API_KEY', 'Syncthing Api key', environment_variable: 'SYNCTHING_API_KEY', attribute_name: :syncthing_api_key
        option ['-c', '--config'], 'PATH', 'config.xml path', environment_variable: 'SYNCTHING_CONFIG_PATH', attribute_name: :xml_config

        def execute
          super
          config_obj = API::Config.new
          config_obj.connect(syncthing_uri: syncthing_uri,
                             syncthing_api_key: api_key)

          %w(devices folders).each do |col_name|
            klass = ('Syncthing::Helper::API::' + col_name.capitalize + 'Updater').constantize
            instance_variable_set ('@' + col_name).to_sym, klass.new(config_obj: config_obj, col: col_name)
          end

          %w(term int quit).map(&:upcase).each do |sig|
            Signal.trap(sig) do
              Thread.new {shutdown}
              exit
            end
          end

          loop { sleep 60 }
        end

        def shutdown
          @devices.listener.stop
          @folders.listener.stop
          sleep 5
        end

        def api_key
          syncthing_api_key || Syncthing::Helper::API.api_key_from_xml(xml_config)
        end
      end
    end
  end
end
