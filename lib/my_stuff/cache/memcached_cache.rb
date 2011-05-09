# Copyright 2011-present Fred Emmott. All Rights Reserved.

autoload :Memcached, 'memcached'

module MyStuff
  module Cache
    # Memcache-base cached.
    #
    # If you want to use this, you know what it does.
    class MemcachedCache < MyStuff::Cache::Base
      def initialize memcached
        @mc = memcached
      end

      def get keys
        results = @mc.get(keys) unless keys.empty?
        keys.map{|k| results[k]}
      end

      def set values
        values.each do |k,v|
          @mc.set(k, v, 0)
        end
      end
    end
  end
end
