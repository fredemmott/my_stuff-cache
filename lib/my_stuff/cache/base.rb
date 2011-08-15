# Copyright 2011-present Fred Emmott. See COPYING file.

module MyStuff
  module Cache
    # Base implementation.
    #
    # You probably want a subclass instead:
    # - MyStuff::Cache::NullCache (not likely)
    # - MyStuff::Cache::MemoryCache
    # - MyStuff::Cache::MemcachedCache
    class Base
      # Try to get ids from cache, falling back to the given block.
      #
      # See #get_with_multi_fallback for documentation.
      #
      # Unlike get_with_multi_fallback, fallback gets called once for each
      # id. You almost certainly want to use #get_with_multi_fallback
      # instead.
      def get_with_fallback ids, key_pattern, options = {}, &fallback
        get_with_multi_fallback(ids, key_pattern, options) do |ids|
          result = ids.map{|id| fallback.call(id) }
          result
        end
      end

      # Try to get ids from cache, falling back to to the given block.
      #
      # - +ids+ is an array of ids
      # - +key_pattern+ is a printf string to turn an id into a cache key
      # 
      # The following options are supported:
      # +update_cache+:: If fallback is called, cache the result (default
      #                  true)
      # +force_update+:: Fetch from the database, even if there's a value
      #                  in cache.
      # +ttl+: Keep fetched values in cache for the specified number of
      #        seconds. Defaults to forever (0). May be completely ignored.
      #
      # The block gets passed the list of ids which missed the cache.
      def get_with_multi_fallback ids, key_pattern, options = {}, &fallback
        options = {
          :update_cache => true,
        }.merge(options)
  
        to_cache = Hash.new
        if options[:force_update]
          data = Hash[ids.zip([nil] * ids.size)]
        else
          data = Hash[ids.zip(get(ids.map{|x| key_pattern % x}))]
        end
        misses = data.select{|k,v| !v}.keys
        from_fallback = fallback.call(misses)
        Hash[misses.zip(from_fallback)].each do |k,v|
          to_cache[key_pattern % k] = v
          data[k] = v;
        end
        set(to_cache) unless to_cache.empty? || !options[:update_cache]
        ids.map{|k| data[k]}
      end
 
      # Fetch values from cache.
      #
      # Returns an array of values. If a key is not in the cache, nil is
      # returned instead.
      #
      # +keys+ is an array of cache keys.
      # 
      # Currently, no options are supported.
      def get keys, options = {}
        raise NotImplementedError.new
      end
 
      # Set values in the cache.
      #
      # +values+ is a hash of cache key => values.
      #
      # The following options are supported:
      # +ttl+: Keep fetched values in cache for the specified number of
      #        seconds. Defaults to forever (0). May be completely ignored.
      def set values, options = {}
        raise NotImplementedError.new
      end
    end
  end
end
