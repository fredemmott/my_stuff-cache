# Copyright 2011-present Fred Emmott. All Rights Reserved.

module MyStuff
  module Cache
    # Hash-based cache.
    #
    # This will not be shared between instances of the cache - for example,
    # this means that it won't be shared between all requests in a
    # Passenger or pool-based setup.
    class MemoryCache < MyStuff::Cache::Base
      def initialize
        @cache = Hash.new
      end

      def get keys
        keys.map{|key| @cache[key]}
      end

      def set values
        @cache.merge! values
      end
    end
  end
end
