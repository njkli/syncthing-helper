module Syncthing
  module Helper
    module CLI
      class MainCommand < AbstractCommand
        subcommand ['dev', 'devices'], 'Participating devices', DeviceCommand
        subcommand ['fol', 'folders'], 'Synchronized folders operations', FolderCommand
        subcommand ['updater'], 'Config sync daemon', UpdaterCommand
      end
    end
  end
end
