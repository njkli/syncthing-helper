=begin
nokogiri
   roxml
   dry-struct
   virtus
# rest-client
# wrest
=end

%w(multi_json
   active_support/core_ext/hash
   roar/client
   roar/json
   roxml
   concurrent
   rio
   tty-table
   clamp
   google/cloud/firestore
   google/cloud/pubsub).each(&method(:require))

require 'pry'

require 'syncthing/helper/version'
require 'syncthing/helper/api'
require 'syncthing/helper/cli'

require 'syncthing/helper/xml/config'

module Syncthing
  module Helper
    # Your code goes here...
  end
end
