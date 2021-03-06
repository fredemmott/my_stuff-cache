# -*- encoding: utf-8 -*-
require 'rake'

Gem::Specification.new do |s|
  s.name          = 'my_stuff-cache'
  s.version       = '0.0.3'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Fred Emmott']
  s.email         = ['mail@fredemmott.co.uk']
  s.homepage      = 'https://github.com/fredemmott/my_stuff-cache'
  s.summary       = %q{MyStuff.ws's caching library}
  s.description   = %q{A thin, multi-backend caching library}
  s.license       = 'ISC'

  s.files         = FileList[
    'COPYING',
    'README.rdoc',
    'lib/**/*.rb',
  ].to_a
end
