module Syncthing
  module Helper
    module API
      class UpdaterBase
        include Concurrent::Async
        attr_accessor :current_snapshot, :listener, :config_obj

        def initialize config_obj: nil, col: nil
          super()
          @config_obj = config_obj
          @col = col
          listen
        end

        def listen
          @listener = (Firestore.col @col).listen do |snapshot|
            if snapshot.changes.count > 0
              @config_obj.retrieve
              @current_snapshot = snapshot
              snapshot.changes.each do |chng|
                @chng_obj = chng
                send "#{@col}_#{chng.type.to_s}".to_sym
              end
              @config_obj.update
            end
          end
        end
      end

      class DevicesUpdater < UpdaterBase
        # TODO: validate input!
        def devices_added
          device_exists = @config_obj.devices.find{ |d| d['deviceID'] == @chng_obj.doc.document_id }
          unless device_exists
            new_device = @config_obj.devices.first.dup
            new_device['deviceID'] = @chng_obj.doc.document_id
            new_device['name'] = @chng_obj.doc.data[:label]
            new_device['compression'] = 'always'
            @config_obj.devices << new_device
          end
        end
        alias_method :devices_modified, :devices_added

        def devices_removed
          @config_obj.devices.delete_if { |d| d['deviceID'] == @chng_obj.doc.document_id }
        end
      end

      class FoldersUpdater < UpdaterBase
        # TODO: validate input!
        def folders_added
          remove_folder
          new_folder = @config_obj.folders.first.dup
          new_folder['id'] = @chng_obj.doc.document_id
          new_folder['path'] = @chng_obj.doc.data[:path]
          new_folder['label'] = @chng_obj.doc.data[:label]
          new_folder['type'] = @chng_obj.doc.data[:type]
          new_folder['maxConflicts'] = -1
          new_folder['devices'] = API::Firestore.col('devices').get.map { |d| {'deviceID' => d.document_id, 'introducedBy' => '' }}
          @config_obj.folders << new_folder
        end
        alias_method :folders_modified, :folders_added

        def folders_removed
          @config_obj.folders.delete_if { |d| d['id'] == @chng_obj.doc.document_id }
        end

        private
        def remove_folder
          folder_exists = @config_obj.folders.find{ |f| f['id'] == @chng_obj.doc.document_id }
          @config_obj.folders.delete(folder_exists) if folder_exists
        end
      end

    end
  end
end
