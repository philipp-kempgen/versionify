require 'test/unit'
require 'versionify'

module Versionify
	module Tests  # :nodoc:
		class TestMy < ::Test::Unit::TestCase  # :nodoc:
			
			include Versionify
			
			def test_new_with_empty_string
				assert_nothing_raised {
					vers = VersionSpec.new( '' )
					assert_kind_of( VersionSpec, vers )
				}
			end
			
			def test_new_with_nil
				assert_nothing_raised {
					vers = VersionSpec.new( nil )
					assert_kind_of( VersionSpec, vers )
				}
			end
			
			def test_new_with_false
				assert_nothing_raised {
					vers = VersionSpec.new( false )
					assert_kind_of( VersionSpec, vers )
				}
			end
			
			def test_new_with_array
				assert_nothing_raised {
					vers = VersionSpec.new( [ 1, 2, 3 ] )
					assert_kind_of( VersionSpec, vers )
					assert_equal( VersionSpec.new( '1.2.3' ), vers )
				}
			end
			
			def test_new_with_invalid_input
				[
					true,
					:sym,
					proc{},
					123,
				].each { |input|
					assert_raise( ArgumentError ) {
						vers = VersionSpec.new( input )
					}
				}
			end
			
			def test_to_s
				{
					'2.3.4'    => '2.3.4',
					'2.3.4.'   => '2.3.4',
					'2.03.4'   => '2.3.4',
					'02.3.004' => '2.3.4',
					'.2.3.4'   => '0.2.3.4',
					'0'        => '0',
					'0.0'      => '0.0',
					'1.00'     => '1.0',
					''         => '',
					nil        => '',
					false      => '',
				}.each { |str, to_s|
					vers = VersionSpec.new( str )
					assert_equal( to_s, vers.to_s )
				}
			end
			
			def test_inspect
				[
					'2.3.4',
					'2.3.4.',
					'2.03.4',
					'02.3.004',
					'.2.3.4',
					'0',
					'0.0',
					'1.00',
					'',
					nil,
					false,
				].each { |str|
					vers = VersionSpec.new( str )
					inspect = "%s( %s )" % [ "Versionify::VersionSpec", vers.to_s.inspect ]
					assert_equal( inspect, vers.inspect )
				}
			end
			
			def test_empty
				{
					'2.3.4'    => false,
					'2.3.4.'   => false,
					'2.03.4'   => false,
					'02.3.004' => false,
					'.2.3.4'   => false,
					'0'        => false,
					'0.0'      => false,
					'1.00'     => false,
					''         => true,
					nil        => true,
					false      => true,
				}.each { |str, empty|
					vers = VersionSpec.new( str )
					assert_equal( empty, vers.empty? )
				}
			end
			
			def test_to_a
				{
					'2.3.4'    => [ 2, 3, 4 ],
					'2.3.4.'   => [ 2, 3, 4 ],
					'2.03.4'   => [ 2, 3, 4 ],
					'02.3.004' => [ 2, 3, 4 ],
					'.2.3.4'   => [ 0, 2, 3, 4 ],
					'0'        => [ 0 ],
					'0.0'      => [ 0, 0 ],
					'1.00'     => [ 1, 0 ],
					''         => [],
					nil        => [],
					false      => [],
				}.each { |str, a|
					vers = VersionSpec.new( str )
					assert_equal( ::Array, vers.to_a.class )
					assert_equal( ::Array, vers.to_ary.class )
					assert_equal( a, vers.to_a )
					assert_equal( a, vers.to_ary )
				}
			end
			
			def test_length
				{
					'2.3.4'    => 3,
					'2.3.4.'   => 3,
					'2.03.4'   => 3,
					'02.3.004' => 3,
					'.2.3.4'   => 4,
					'0'        => 1,
					'0.0'      => 2,
					'1.00'     => 2,
					''         => 0,
					nil        => 0,
					false      => 0,
				}.each { |str, a|
					vers = VersionSpec.new( str )
					assert_equal( a, vers.length )
					assert_equal( a, vers.size )
					assert_equal( a, vers.count )
				}
			end
			
			def test_at
				{
					'2.3.4'    => [ 2, 3, 4 ],
					'2.3.4.'   => [ 2, 3, 4 ],
					'2.03.4'   => [ 2, 3, 4 ],
					'02.3.004' => [ 2, 3, 4 ],
					'.2.3.4'   => [ 0, 2, 3, 4 ],
					'0'        => [ 0 ],
					'0.0'      => [ 0, 0 ],
					'1.00'     => [ 1, 0 ],
					''         => [],
					nil        => [],
					false      => [],
				}.each { |str, a|
					vers = VersionSpec.new( str )
					a.each_with_index { |at, idx|
						assert_kind_of( ::Fixnum, vers.at(idx) )
						assert_equal( at, vers.at(idx), "VersionSpec.new( %{str} ).at(%{idx}) should be %{at}." % {
							:idx => idx, :at => at.inspect,
							:str => str.inspect,
						})
					}
				}
				assert_equal(   4, VersionSpec.new( '2.3.4' ).at( -1 ))
				assert_equal( nil, VersionSpec.new( '2.3.4' ).at(  3 ))
				assert_equal( nil, VersionSpec.new( '2.3.4' ).at( -4 ))
			end
			
			def test_fetch
				{
					{ :vers => '2.3.4', :fetch => [ 0] } => 2,
					{ :vers => '2.3.4', :fetch => [-1] } => 4,
					{ :vers => '2.3.4', :fetch => [ 1] } => 3,
					{ :vers => '2.3.4', :fetch => [ 2] } => 4,
					{ :vers => '2.3.4', :fetch => [ 5, 88 ] } => 88,
					{ :vers => '2.3.4', :fetch => [ 5, proc{|i| 87} ] } => 87,
				}.each { |info, ret|
					vers = VersionSpec.new( info[:vers] )
					if info[:fetch].last.kind_of?( ::Proc )
						assert_equal( ret, vers.fetch( info[:fetch][0], & info[:fetch].last ))
					else
						assert_equal( ret, vers.fetch( *info[:fetch] ))
					end
				}
				
				{
					{ :vers => '2.3.4', :fetch => [ 3] } => ::IndexError,
					{ :vers => '2.3.4', :fetch => [-4] } => ::IndexError,
				}.each { |info, ret|
					vers = VersionSpec.new( info[:vers] )
					assert_raise( ::IndexError ) {
						vers.fetch( *info[:fetch] )
					}
				}
			end
			
			def test_none_display_string
				assert_equal( 'none', VersionSpec::NONE_STR )
			end
			
			def test_to_display
				{
					'2.3.4'    => '2.3.4',
					' 2.3.4 '  => '2.3.4',
					'2.3.4.'   => '2.3.4',
					'2.03.4'   => '2.3.4',
					'02.3.004' => '2.3.4',
					'.2.3.4'   => '0.2.3.4',
					'0'        => '0',
					'0.0'      => '0.0',
					'1.00'     => '1.0',
					''         => VersionSpec::NONE_STR,
					' '        => VersionSpec::NONE_STR,
					nil        => VersionSpec::NONE_STR,
					false      => VersionSpec::NONE_STR,
				}.each { |str, to_display|
					vers = VersionSpec.new( str )
					assert_equal( to_display, vers.to_display )
				}
			end
			
			def test_s
				{
					'2.3.4'    => '2.3.4',
					' 2.3.4 '  => '2.3.4',
					'2.3.4.'   => '2.3.4',
					'2.03.4'   => '2.3.4',
					'02.3.004' => '2.3.4',
					'.2.3.4'   => '0.2.3.4',
					'0'        => '0',
					'0.0'      => '0.0',
					'1.00'     => '1.0',
					''         => nil,
					' '        => nil,
					nil        => nil,
					false      => nil,
				}.each { |str, to_s_nil|
					vers = VersionSpec.new( str )
					assert_equal( to_s_nil, vers.to_s_nil )
				}
			end
			
			def test_equality
				versA = VersionSpec.new( '2.3.04' )
				[
					'2.3.4',
					'2.3.4.',
					'2.03.4',
					'02.3.004',
				].each { |str|
					versB = VersionSpec.new( str )
					assert_equal( versA, versB )
					assert_equal( 0, versA <=> versB )
					assert_equal( 0, versB <=> versA )
					assert( versA == versB )
					assert( versB == versA )
				}
			end
			
			def test_nil_comparision
				versA = VersionSpec.new( '' )
				versB = VersionSpec.new( '' )
				assert_not_equal( versA, versB )
				assert_equal( nil, versA <=> versB )
				assert( versA != versB )
				assert( versB != versA )
				assert( versA != nil )
				assert( versB != nil )
				assert( nil != versA )
				assert( nil != versB )
			end
			
			def test_vers_to_nil_comparision
				versOK  = VersionSpec.new( '2.3.4' )
				versNil = VersionSpec.new( '' )
				assert_not_equal( versOK, versNil )
				assert_equal( nil, versOK  <=> versNil )
				assert_equal( nil, versNil <=> versOK )
				assert( versOK  != versNil )
				assert( versNil != versOK )
			end
			
			def test_stuff1
				versA = VersionSpec.new( '2.3.4' )
				versB = VersionSpec.new( '2.3.10' )
				assert_not_equal( versA, versB )
				assert( versA != versB )
				assert( versB != versA )
				assert( versA < versB )
				assert( versB > versA )
				assert_equal( -1, versA <=> versB )
				assert_equal(  1, versB <=> versA )
			end
			
			def test_stuff2
				versA = VersionSpec.new( '0.5' )
				versB = VersionSpec.new( '0.5.0' )
				assert_not_equal( versA, versB )
				assert( versA != versB )
				assert( versB != versA )
				assert( versA < versB )
				assert( versB > versA )
				assert_equal( -1, versA <=> versB )
				assert_equal(  1, versB <=> versA )
			end
			
			def test_stuff3
				versA = VersionSpec.new( '0.5' )
				versB = VersionSpec.new( '0.4.0' )
				assert_not_equal( versA, versB )
				assert( versA != versB )
				assert( versB != versA )
				assert( versA > versB )
				assert( versB < versA )
				assert_equal(  1, versA <=> versB )
				assert_equal( -1, versB <=> versA )
			end
			
			def test_sort
				sorted = [
				#	'',
					'0.1',
					'0.1.0',
					'0.1.1',
					'1',
					'1.0',
					'9.04',
					'10.4',
				].map!{ |str| VersionSpec.new( str ) }
				3.times {
					assert_equal( sorted, sorted.shuffle.sort )
				}
			end
			
			def test_vers_to_string_comparision
				vers  = VersionSpec.new( '2.03.4' )
				assert( vers== '2.3.4' )
				assert( vers== '02.03.04' )
				assert( vers > '2.3.0' )
				assert( vers > '2.3' )
				assert( vers < '2.3.4.1' )
				assert( vers < '2.3.5' )
				assert( vers < '2.4' )
				assert( vers != '2.3.4.1' )
				assert( vers != '2.30.4' )
			end
			
			def test_vers_to_invalid_string_comparision
				vers  = VersionSpec.new( '2.03.4' )
				assert( vers != '' )
			end
			
			def test_negated
				vers  = VersionSpec.new( '2.3.4' )
				assert_equal( false, ! vers )
			end
			
			def test_valid_methods
				vers = VersionSpec.new( '2.3.4' )
				assert_nothing_raised {
					vers.map( & :to_i )
					vers.map{ |i| i.to_i }
					vers.collect{ |i| i.to_i }
					vers.join('.')
					vers.count
					vers.length
					vers.size
					vers.take(1)
					vers.to_a
					vers.to_ary
				}
			end
			
			def test_invalid_methods
				#array_method_error_cls = ::RuntimeError
				array_method_error_cls = ::NoMethodError
				versA = VersionSpec.new( '2.3.4' )
				versB = VersionSpec.new( '2.3.4' )
				assert_raise( array_method_error_cls ) {
					versA + versB
				}
				assert_raise( array_method_error_cls ) {
					versA - versB
				}
				assert_raise( array_method_error_cls ) {
					versA * versB
				}
				assert_raise( array_method_error_cls ) {
					versA << versB
				}
				assert_raise( array_method_error_cls ) {
					versA.map!{ |i| i.to_i }
				}
				assert_raise( array_method_error_cls ) {
					versA.collect!{ |i| i.to_i }
				}
				assert_raise( array_method_error_cls ) {
					versA.compact!
				}
				assert_raise( array_method_error_cls ) {
					versA.concat([])
				}
				assert_raise( array_method_error_cls ) {
					versA.delete( 2 )
				}
				assert_raise( array_method_error_cls ) {
					versA.delete_at( 0 )
				}
				assert_raise( array_method_error_cls ) {
					versA.delete_if{ |x| true }
				}
				assert_raise( array_method_error_cls ) {
					versA.drop(1)
				}
				assert_raise( array_method_error_cls ) {
					versA.drop_while{ |x| true }
				}
				assert_raise( array_method_error_cls ) {
					versA.fill( 1 )
				}
				assert_raise( array_method_error_cls ) {
					versA.index( 1 )
				}
				assert_raise( array_method_error_cls ) {
					versA.keep_if{ |x| true }
				}
				assert_raise( array_method_error_cls ) {
					versA.reject!{ |x| true }
				}
				assert_raise( array_method_error_cls ) {
					versA.replace( [] )
				}
				assert_raise( array_method_error_cls ) {
					versA.reverse!
				}
				assert_raise( array_method_error_cls ) {
					versA.rotate!( 1 )
				}
				assert_raise( array_method_error_cls ) {
					versA.select!{ |x| true }
				}
				assert_raise( array_method_error_cls ) {
					versA.shift
				}
				assert_raise( array_method_error_cls ) {
					versA.shuffle!
				}
				assert_raise( array_method_error_cls ) {
					versA.sort
				}
				assert_raise( array_method_error_cls ) {
					versA.sort!
				}
				assert_raise( array_method_error_cls ) {
					versA.sort_by!
				}
				assert_raise( array_method_error_cls ) {
					versA.uniq
				}
				assert_raise( array_method_error_cls ) {
					versA.uniq!
				}
				assert_raise( array_method_error_cls ) {
					versA.zip([])
				}
				assert_raise( array_method_error_cls ) {
					versA | versB
				}
			end
			
		end
	end
end
