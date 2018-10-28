module Syncthing
  module Helper
    module API
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
          get(@opts) { |r| auth(r) }
        end

        def update
          post(@opts) { |r| auth(r) }
        end

        private
        def auth r
          r.add_field('X-API-Key', @syncthing_api_key)
        end
      end

    end
  end
end
