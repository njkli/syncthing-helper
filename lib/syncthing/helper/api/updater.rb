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
          Logger.tagged('firestore/' + @col) {Logger.info 'Starting query listener'}
          @listener = (Firestore.col @col).listen do |snapshot|
            if snapshot.changes.count > 0
              @config_obj.retrieve
              @current_snapshot = snapshot
              snapshot.changes.each do |chng|
                @chng_obj = chng
                send "#{@col}_#{chng.type.to_s}".to_sym
              end
              @config_obj.update
              Logger.tagged('config_api: ' + @col.singularize + '/update') { Logger.debug 'Written' }
            end
          end
        end

        def removed
          id_field = API::DB_FIELDS_CONFIG_OBJ[@col]
          @config_obj[@col].delete_if { |f| f[id_field] == @chng_obj.doc.document_id }
          Logger.tagged('config_api: ' + @col.singularize + '/rm') { Logger.debug @chng_obj.doc.document_id }
        end
        alias_method :folders_removed, :removed
        alias_method :devices_removed, :removed
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
            Logger.tagged('config_api: ' + @col.singularize + '/add') { Logger.debug @chng_obj.doc.document_id }
          end
        end
        alias_method :devices_modified, :devices_added
      end

      class FoldersUpdater < UpdaterBase
        # TODO: validate input!
        def folders_added
          folders_removed
          new_folder = @config_obj.folders.first.dup
          new_folder['id'] = @chng_obj.doc.document_id
          new_folder['path'] = @chng_obj.doc.data[:path]
          new_folder['label'] = @chng_obj.doc.data[:label]
          new_folder['type'] = @chng_obj.doc.data[:type]
          new_folder['maxConflicts'] = -1
          new_folder['devices'] = API::Firestore.col('devices').get.map { |d| {'deviceID' => d.document_id, 'introducedBy' => '' }}
          @config_obj.folders << new_folder
          Logger.tagged('config_api: ' + @col.singularize + '/add') { Logger.debug @chng_obj.doc.document_id }
        end
        alias_method :folders_modified, :folders_added
      end

    end
  end
end
