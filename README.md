Parser for versions strings such as `"1.2.3"`.

Usage:

	require 'versionify'
	
	V = Versionify::VersionSpec
	
	puts (      "1.0.10"  >       "1.0.2" )  # => false
	puts (V.new("1.0.10") > V.new("1.0.2"))  # => true

Author: Philipp Kempgen, [http://kempgen.net](http://kempgen.net)

