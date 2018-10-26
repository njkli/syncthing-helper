module Syncthing
  module Helper
    module CLI
      class UpdaterStartCommand < AbstractCommand
        def execute
          super
          opts = {syncthing_uri: syncthing_uri,
                  syncthing_api_key: syncthing_api_key}
          config_obj = API::Config.new
          config_obj.connect opts

          @devices = API::DevicesUpdater.new(config_obj: config_obj, col: 'devices')
          @folders = API::FoldersUpdater.new(config_obj: config_obj, col: 'folders')

          %w(term int quit).map(&:upcase).each do |sig|
            Signal.trap(sig) do
              Thread.new {shutdown}
              exit
            end
          end

          loop { sleep 60 }
        end

        def shutdown
          @devices.async.listener.stop
          @folders.async.listener.stop
          sleep 5
        end
      end

      class UpdaterCommand < AbstractCommand
        self.default_subcommand = 'start'
        subcommand ['start', 'daemon'], 'Start background config sync', UpdaterStartCommand
      end
    end
  end
end
