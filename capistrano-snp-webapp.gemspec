# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = 'capistrano-snp-webapp'
  spec.version = '1.0'
  spec.authors = ['Psh']
  spec.email = ['psh@fruitcode.net']
  spec.description = %q{systemd+nginx+puma-powered webapp scripts}
  spec.summary = %q{systemd+nginx+puma-powered webapp scripts}
  spec.homepage = 'https://github.com/ppsshh/capistrano-webapp'
  spec.license = 'MIT'

  spec.required_ruby_version     = '>= 2.5.1'

#  spec.files = `git ls-files`.split($/)
  spec.files = Dir['lib/**/*'] + %w(Gemfile Rakefile capistrano-snp-webapp.gemspec)
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '~> 3.7'
end
