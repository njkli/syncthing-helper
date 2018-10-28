gem_reqs = %w(multi_json
              active_support/core_ext/hash
              roar/client
              roar/json
              roxml
              concurrent
              rio
              tty-table
              clamp
              semantic_logger
              google/cloud/firestore
              google/cloud/pubsub)

app_reqs = %w(syncthing/helper/version
              syncthing/helper/api
              syncthing/helper/cli
              syncthing/helper/xml/config)

(gem_reqs + app_reqs).each(&method(:require))
# require 'syncthing/helper/api/model'

module Syncthing
  module Helper
    class LogFormatter < SemanticLogger::Formatters::Color

      def call(log, logger)
        self.log    = log
        self.logger = logger
        self.color = color_map[log.level]

        # [time, level, process_info, tags, named_tags, duration, name, message, payload, exception].compact.join(' ')
        [level, tags, named_tags, duration, message, payload, exception].compact.join(' ')
      end
    end
    Logger = SemanticLogger['Syncthing::Helper']
    SemanticLogger.add_appender(io: STDOUT, formatter: LogFormatter.new)
  end
end
