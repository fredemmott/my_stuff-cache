# Copyright 2011-present Fred Emmott. See COPYING file.

autoload :Memcached, 'memcached'

module MyStuff
  module Cache
    # Memcache-base cached.
    #
    # If you want to use this, you know what it does.
    class MemcachedCache < MyStuff::Cache::Base
      # Create an instance of this cache.
      #
      # +memcached+ is a Memcached object, provided by the memcached gem.
      def initialize memcached
        @mc = memcached
      end

      def get keys, options = {}
        begin
          results = @mc.get(keys) unless keys.empty?
          keys.map{|k| results[k]}
        rescue Memcached::Error => e
          LOG :warning, e
          [nil] * keys.size
        end
      end

      def set values, options = {}
        options[:ttl] ||= 0
        begin
          values.each do |k,v|
            @mc.set(k, v, options[:ttl])
          end
        rescue Memcached::Error => e
          LOG :warning, e
        end
      end
    end
  end
end
