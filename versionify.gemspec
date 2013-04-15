# -*- encoding: utf-8 -*-

lib_dir = File.expand_path( '../lib/', __FILE__ )
$LOAD_PATH.unshift( lib_dir )

#require 'my_lib/version'

spec = Gem::Specification.new { |s|
	s.name         = 'versionify'
	s.version      = '0.1.1'
	s.summary      = "Parser for version strings."
	s.description  = "Parser for version strings such as \"1.2.3\"."
	s.author       = "Philipp Kempgen"
	s.homepage     = 'https://github.com/philipp-kempgen/versionify'
	s.platform     = Gem::Platform::RUBY
	s.require_path = 'lib'
	s.executables  = []
	s.files        = Dir.glob( '{lib,bin}/**/*' ) + %w(
		README.md
	)
	
	s.add_development_dependency "test-unit", "~> 2.5", ">= 2.5.0"
}


# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# End:

