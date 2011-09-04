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
      def initialize memcached, options = {}
        @mc = memcached
        super options
      end

      def get keys, options = {}
        begin
          if prefix.nil? || prefix.empty?
            mc_keys = keys
          else
            mc_keys = keys.map{|x| prefix + x}
          end
          results = @mc.get(mc_keys) unless keys.empty?
          keys.map{|k| results[k]}
        rescue Memcached::Error => e
          logger.warn e.inspect
          [nil] * keys.size
        end
      end

      def set values, options = {}
        options[:ttl] ||= 0
        begin
          values.each do |k,v|
            prefix = self.prefix || ''
            @mc.set(prefix + k, v, options[:ttl])
          end
        rescue Memcached::Error => e
          logger.warn e
        end
      end
    end
  end
end
