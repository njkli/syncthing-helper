module Syncthing
  module Helper
    module CLI
      class DemoCommand < AbstractCommand
        parameter 'INPUT', 'xml config to read', attribute_name: :src, required: true

        def execute
          puts Syncthing::Helper::API.api_key_from_xml src
        end
      end
    end
  end
end
