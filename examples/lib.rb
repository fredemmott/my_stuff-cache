# Copyright 2011-present Fred Emmott. See COPYING file.
require 'openssl'

class Foo
  def initialize cache
    @cache = cache
  end

  def do_stuff ids
    s = Time.new
    @cache.get_with_multi_fallback(ids, 'FOO:%d') do |ids|
      puts "Uncached lookup for '#{ids.inspect}'"
      ids.map do |x|
        10000.times do 
          OpenSSL::Digest.hexdigest('sha512', x.inspect)
        end
      end
    end
    puts "Took %dms" % ((Time.new - s) * 1000)
  end

  def run
    s = Time.new
    do_stuff [1,2,3]
    do_stuff [1,2,3]
    do_stuff [1,2,3]
    do_stuff [2,3,4]
    do_stuff [2,3,4]
    do_stuff [2,3,4]
    puts "Total: %dms" % ((Time.new - s) * 1000)
  end
end
