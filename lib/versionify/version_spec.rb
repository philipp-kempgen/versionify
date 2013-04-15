module Versionify
	class VersionSpec < ::Array
		
		# Get rid of methods from Array that we don't want.
		#OPTIMIZE Remove all inherited methods, except some selected ones?
		[  # (In Ruby 2.0 we could use %i() notation for an array of symbols.)
			:'-',
			:'*',
			:'&',
			:'+',
			:'<<',
			:'|',
			:assoc,
			:clear,
			:collect!,
			:compact!,
			:concat,
			:delete,
			:delete_at,
			:delete_if,
			:drop,
			:drop_while,
			:fill,
			:flatten,
			:flatten!,
			:include?,
			:index,
			:insert,
			:keep_if,
			:map!,
			:pop,
			:push,
			:rassoc,
			:reject!,
			:replace,
			:reverse!,
			:rindex,
			:rotate!,
			:sample,
			:select!,
			:shift,
			:shuffle!,
			:sort,
			:sort!,
			:sort_by!,
			:uniq,
			:uniq!,
			:zip,
		].each { |m|
			#undef m  if self.superclass.new.respond_to?( m )
			#define_method( m ) { |*args|
			#	raise ::NoMethodError, "Method #{m}() isn't allowed for #{self.class.name.split('::').last}."
			#}
			undef_method( m )  if self.superclass.new.respond_to?( m )  #OPTIMIZE
		}
		
		#puts "CLASS:   #{self.superclass.new.respond_to?( :'+' )}  "
		
		
		include ::Comparable
		
		NONE_STR = 'none'.freeze  # / 'unknown'
		
		# v = VersionSpec.new( '1.2.3' )
		# v = VersionSpec.new( nil )
		# v = VersionSpec.new( false )
		def initialize( arg )
			if arg
				if arg.kind_of?( ::String )
					parts = arg.to_s.strip.split('.').map( & :to_i )
				elsif arg.kind_of?( ::Array )
					parts = arg.map( & :to_i )
				else
					raise ::ArgumentError.new( "Expected a String or Array, #{arg.class.name} given." )
				end
			else
				parts = []
			end
			
			super( parts )
		end
		
		## v = VersionSpec.parse( '1.2.3' )
		#def self.parse( arg )
		#	self.new( arg )
		#end
		
		def null?
			#self.count == 0
			self.empty?
		end
		
		def comparable?
			! self.null?
		end
		
		def ==( other )
			cmp = (self <=> other)
			#return case cmp
			#	when 0      ; true
			#	when [-1,1] ; false
			#	when nil    ; false
			#	else        ; false
			#end
			return cmp == 0
		end
		
		def !=( other )
			return ! (self == other)
		end
		
		def <=>( other )
			if other.kind_of?( ::String )
				other = self.class.new( other )
			end
			return nil  if (! other.kind_of?( self.class ))
			return nil  if (null? || other.null?)
			super
		end
		
		def join( separator='.' )
			super( separator )
		end
		
		def to_s
			self.join('.')
		end
		
		def inspect
			"%s( %s )" % [ self.class.name, self.to_s.inspect ]
		end
		
		# Like to_s(), but don't return an empty string in case
		# there are no parts.
		def to_display
			comparable? ? self.to_s : NONE_STR
		end
		
		def to_s_nil
			comparable? ? self.to_s : nil
		end
		
		def empty?
			super
		end
		
		def to_a
			super
		end
		
		def to_ary
			to_a
		end
		
		def length
			super
		end
		alias :size  :length
		alias :count :length
		
		def slice( *args )
			super
		end
		
		def at( index )
			super
		end
		
		def fetch( idx, *args )
			super
		end
		
		def pack( fmt )
			super
		end
		
		def frozen?
			super
		end
		
		def freeze
			super
		end
		
		def freeze!
			freeze
		end
		
		#OPTIMIZE Implement first(...), last(...)
		
	end
	
	def VersionSpec( arg )
		VersionSpec.new( arg )
	end
end

