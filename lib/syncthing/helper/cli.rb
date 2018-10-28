Clamp.allow_options_after_parameters = true
%w(syncthing/helper/cli/abstract_command
   syncthing/helper/cli/demo_command
   syncthing/helper/cli/device_command
   syncthing/helper/cli/folder_command

   syncthing/helper/cli/updater_command

   syncthing/helper/cli/main_command).each(&method(:require))
