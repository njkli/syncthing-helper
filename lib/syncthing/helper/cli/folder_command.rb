module Syncthing
  module Helper
    module CLI
      class FolderCreateCommand < AbstractCommand
        parameter 'ID:PATH:LABEL ...', 'Folder ID:PATH:LABEL', attribute_name: :folders, required: true

        def execute
          super
          folders.each do |f|
            folder_id, folder_path, folder_label = f.split ':'

            folder = {"id" => folder_id,
                      "path" => folder_path,
                      "label" => folder_label,
                      "type" =>"readwrite",
                      "devices" => [],
                      "maxConflicts" => -1}
            API::Firestore.doc('folders/' + folder_id).set(folder)
          end
        end
      end

      class FolderReadCommand < AbstractCommand
        def execute
          super
          col = 'folders'
          docs = API::Firestore.col(col).get.map(&:document_id)
          res = docs.map do |d|
            dr = API::Firestore.doc(col + '/' + d).get.data
            [dr[:id], dr[:path], dr[:label]]
          end
          tabled_stdout header: ['Folder Id', 'Path', 'Label'], rows: res
        end
      end

      class FolderDeleteCommand < AbstractCommand
        parameter 'FOLDER_IDS ...', 'Syncthing device ids or names', attribute_name: :idents, required: true

        def execute
          super
          idents.each do |ident|
            document_id = (doc_ref col: 'folders', ident: ident).document_id
            API::Firestore.doc('folders/' + document_id).delete
          end
        end
      end

      class FolderCommand < AbstractCommand
        self.default_subcommand = 'ls'
        subcommand ['add', 'create'], 'Create device', FolderCreateCommand
        subcommand ['ls', 'read'], 'Read device tables', FolderReadCommand
        # subcommand ['set', 'update'], 'Update devices', FolderUpdateCommand
        subcommand ['rm', 'delete'], 'Delete devices', FolderDeleteCommand
      end

    end
  end
end
