# Copyright 2011-present Fred Emmott. All Rights Reserved.

module MyStuff
  module Cache
    # Base implementation.
    #
    # You probably want a subclass instead:
    # - MyStuff::Cache::NullCache (not likely)
    # - MyStuff::Cache::MemoryCache
    # - MyStuff::Cache::MemcachedCache
    class Base
      # Try ant get ids from cache, falling back to to the given block.
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
      def get_with_fallback ids, key_pattern, options = {}, &fallback
        options = {
          :update_cache => true,
        }.merge(options)
  
        to_cache = Hash.new
        if options[:force_update]
          data = Hash[ids.zip([nil] * ids.size)]
        else
          data = Hash[ids.zip(get(ids.map{|x| key_pattern % x}))]
        end
        data = data.map do |id, cache_result|
          if cache_result
            cache_result
          else
            result = fallback.call(id)
            to_cache[key_pattern % id] = result
            result
          end
        end
        set(to_cache) unless to_cache.empty? || !options[:update_cache]
        data
      end
  
      def get keys, options = {}
        raise NotImplementedError.new
      end
  
      def set values, options = {}
        raise NotImplementedError.new
      end
    end
  end
end
