# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prawn_html/version'

Gem::Specification.new do |spec|
  spec.name          = 'prawn-html'
  spec.version       = PrawnHtml::VERSION
  spec.summary       = 'Prawn PDF - HTML renderer'
  spec.description   = 'HTML to PDF with Prawn PDF'

  spec.required_ruby_version = '>= 2.5.0'

  spec.license  = 'MIT'
  spec.authors  = ['Mattia Roccoberton']
  spec.email    = 'mat@blocknot.es'
  spec.homepage = 'https://github.com/blocknotes/prawn-html'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = Dir['lib/**/*', 'LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'oga', '~> 3.3'
  spec.add_runtime_dependency 'prawn', '~> 2.4'
end
