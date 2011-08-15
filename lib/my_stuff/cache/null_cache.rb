# Copyright 2011-present Fred Emmott. See COPYING file.

module MyStuff
  module Cache
    # No-op implementation that implements the API, but does no caching.
    class NullCache < ::MyStuff::Cache::Base
      def get keys, options = {}
        [nil] * keys.size
      end

      def set keys, options = {}
        # nop
      end
    end
  end
end
