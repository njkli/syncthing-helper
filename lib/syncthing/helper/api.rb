require 'syncthing/helper/api/config'
require 'syncthing/helper/api/updater'

module Syncthing
  module Helper
    module API
      module Xml
        class Gui
          include ROXML
          xml_accessor :apikey
        end
        class Config
          include ROXML
          xml_name :configuration
          xml_accessor :gui, as: Gui
        end
      end

      class << self
        attr_accessor :firestore
        def init_firestore project_id: nil, credentials: nil
          @firestore ||= Google::Cloud::Firestore.new project_id: project_id, credentials: credentials
          const_set :Firestore, @firestore
          const_set :DB_FIELDS, {'devices' => [:device_id, :label],
                                 'folders' => [:id, :path, :label]}
          const_set :DB_FIELDS_CONFIG_OBJ, {'devices' => 'deviceID',
                                    'folders' => 'id'}
        end

        def api_key_from_xml xml_file
          Xml::Config.from_xml(rio(xml_file).expand_path.read).gui.apikey
        end
      end
    end
  end
end
