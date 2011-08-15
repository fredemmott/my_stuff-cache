# Copyright 2011-present Fred Emmott. See COPYING file.

require 'my_stuff/cache/base'

module MyStuff
  # Simplistic caching module.
  #
  # You probably want to use ActiveSupport::Cache instead. The two major
  # advantages of this are in Base#get_with_fallback (compared to
  # ActiveSupport::Cache::Store#fetch)
  # - you can specify a key pattern
  # - it takes a list of IDs, so the implementation might use a multiget
  #   (MemcachedCache does this)
  #
  # See MyStuff::Cache::Base for interface.
  module Cache
    autoload :NullCache,      'my_stuff/cache/null_cache'
    autoload :MemoryCache,    'my_stuff/cache/memory_cache'
    autoload :MemcachedCache, 'my_stuff/cache/memcached_cache'
  end
end
