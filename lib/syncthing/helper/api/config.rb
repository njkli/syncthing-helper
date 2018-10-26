module Syncthing
  module Helper
    module API
      # @current_config = Syncthing::Helper::API::Config.new
      # @current_config.connect syncthing_uri: syncthing_uri, syncthing_api_key: syncthing_api_key
      # @current_config.retrieve
      # do something
      # @current_config.update
      class Config < OpenStruct
        include Roar::Client
        include Roar::JSON

        property :version
        property :gui
        property :options
        collection :folders
        collection :devices

        def connect syncthing_uri: nil, syncthing_api_key: nil
          @opts = {uri: URI(syncthing_uri) + 'rest/system/config', as: 'application/json'}
          @syncthing_api_key = syncthing_api_key
        end

        def retrieve
          get(@opts) { |r| r.add_field('X-API-Key', @syncthing_api_key) }
        end

        def update
          post(@opts) { |r| r.add_field('X-API-Key', @syncthing_api_key) }
        end
      end

    end
  end
end
