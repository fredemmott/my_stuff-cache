# Copyright 2011-present Fred Emmott. See COPYING file.
require 'openssl'

class Foo
  def initialize cache
    @cache = cache
  end

  def do_stuff ids
    puts "Lookup for #{ids.inspect}"
    s = Time.new
    @cache.get_with_multi_fallback(ids, 'FOO:%d') do |ids|
      puts "Cache miss for #{ids.inspect}"
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
    do_stuff (1..5).to_a
    do_stuff (1..5).to_a
    do_stuff (1..5).to_a
    do_stuff (5..9).to_a
    do_stuff (5..9).to_a
    do_stuff (5..9).to_a
    puts "Total: %dms" % ((Time.new - s) * 1000)
  end
end
