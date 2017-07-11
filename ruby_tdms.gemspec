# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_tdms/version'

Gem::Specification.new do |spec|
	spec.name = 'ruby_tdms'
	spec.version = RubyTDMS::VERSION
	spec.authors = ['Mike Naberezny', 'Aaron Ten Clay']
	spec.email = ['aarontc@aarontc.com']

	spec.summary = %q{Reads TDMS files. TDMS is a binary file format for measurement data created by National Instruments.}
	spec.description = <<-DESCRIPTION
TDMS is a binary file format for measurement data. It was created by National Instruments.

National Instruments software such as LabVIEW, DIAdem, and Measurement Studio support reading and writing TDMS files. NI also provides a DLL written in C for using TDMS files on Windows.

TDMS for Ruby was written to provide a convenient way to work with TDMS files on Unix-like platforms.
DESCRIPTION
	spec.homepage = 'https://github.com/aarontc/ruby_tdms'
	spec.license = 'BSD'


	spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
	spec.bindir = 'exe'
	spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
	spec.require_paths = ['lib']

	spec.add_dependency 'coalesce'
	spec.add_dependency 'require_all'

	spec.add_development_dependency 'bundler', '>= 1.7'
	spec.add_development_dependency 'rake', '~> 10.0'
	spec.add_development_dependency 'minitest'
	spec.add_development_dependency 'simplecov'
end
