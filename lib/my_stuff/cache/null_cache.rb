# Copyright 2011-present Fred Emmott. All Rights Reserved.

module MyStuff
  module Cache
    # No-op implementation that implements the API, but does no caching.
    class NullCache < ::MyStuff::Cache::Base
      def get keys
        [nil] * keys.size
      end

      def set keys
        # nop
      end
    end
  end
end
