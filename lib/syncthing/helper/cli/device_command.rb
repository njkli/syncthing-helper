module Syncthing
  module Helper
    module CLI
      class DeviceCreateCommand < AbstractCommand
        parameter 'DEVICE_ID:DEVICE_NAME ...', 'Syncthing device UUID:NAME', attribute_name: :device_ids, required: true
        # parameter 'DEVICE_LABEL', 'Syncthing human readable device label', attribute_name: :device_label, required: true

        def execute
          super
          device_ids.each do |d|
            device_id, device_label = d.split ':'
            API::Firestore.doc('devices/' + device_id).set(device_id: device_id, label: device_label)
          end
          trigger_updates
        end
      end

      class DeviceReadCommand < AbstractCommand
        def execute
          super
          col = 'devices'
          docs = API::Firestore.col(col).get.map(&:document_id)
          res = docs.map{|d| dr = API::Firestore.doc(col + '/' + d).get.data; [dr[:device_id], dr[:label]]}
          tabled_stdout header: ['Device Id', 'Label'], rows: res
        end
      end

      class DeviceUpdateCommand < AbstractCommand
        def execute
          raise NotImplementedError, 'Not required currently'
        end
      end

      class DeviceDeleteCommand < AbstractCommand
        parameter 'DEVICE_IDS ...', 'Syncthing device ids or names', attribute_name: :idents, required: true

        def execute
          super
          delete_record
        end
      end

      class DeviceCommand < AbstractCommand
        self.default_subcommand = 'ls'
        subcommand ['add', 'create'], 'Create device', DeviceCreateCommand
        subcommand ['ls', 'read'], 'Read device tables', DeviceReadCommand
        subcommand ['set', 'update'], 'Update devices', DeviceUpdateCommand
        subcommand ['rm', 'delete'], 'Delete devices', DeviceDeleteCommand
      end
    end
  end
end
