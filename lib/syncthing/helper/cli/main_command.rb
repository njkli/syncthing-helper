module Syncthing
  module Helper
    module CLI
      class MainCommand < AbstractCommand

        self.default_subcommand = 'demo'
        subcommand 'demo', 'Demo reading apikey from config.xml', DemoCommand
        subcommand ['dev', 'devices'], 'Participating devices', DeviceCommand
        subcommand ['fol', 'folders'], 'Synchronized folders operations', FolderCommand

        subcommand ['updater'], 'Config sync daemon related', UpdaterCommand
      end
    end
  end
end
