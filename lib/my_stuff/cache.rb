# Copyright 2011-present Fred Emmott. All Rights Reserved.
#
# Why not just use ActiveRecord::Cache?
# - No automatic serialization
#   - cross-language - don't want Ruby-Marshal'ed data anywhere
#   - performance
# - get_with_fallback is more self-documenting than #fetch with a block
# - Control over key format (key_pattern)

require 'my_stuff/cache/base'

module MyStuff
  module Cache
    autoload :NullCache,      'my_stuff/cache/null_cache'
    autoload :MemoryCache,    'my_stuff/cache/memory_cache'
    autoload :MemcachedCache, 'my_stuff/cache/memcached_cache'
  end
end
