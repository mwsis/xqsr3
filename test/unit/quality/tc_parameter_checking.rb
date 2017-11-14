#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../../..', 'lib')

require 'xqsr3/quality/parameter_checking'

require 'test/unit'

class Test_parameter_checks_as_separate_module < Test::Unit::TestCase

	module TestConstants
	end
	include TestConstants

	include ::Xqsr3::Quality::ParameterChecking


	# test 1

	def check_method_1 a

		self.class.check_param a, 'a'
	end

	def test_1

		assert_raise ArgumentError do
			check_method_1(nil)
		end

		assert_equal true, check_method_1(true)
		assert_equal '', check_method_1('')
		assert_equal [], check_method_1([])
		assert_equal Hash.new, check_method_1(Hash.new)
	end


	# test 2

	def check_method_2 a, types, options = {}

		self.class.check_param a, 'a', options.merge({ types: types })
	end

	def test_2

		assert_equal true, check_method_2(true, [ ::TrueClass ])
		assert_equal true, check_method_2(true, [ ::TrueClass, ::String, ::Symbol ])
		assert_raise TypeError do
			check_method_2(true, [ ::String, ::Symbol, ::FalseClass ])
		end
		assert_equal true, check_method_2(true, [ ::TrueClass ], nothrow: true)
		assert_nil check_method_2(true, [ ::FalseClass ], nothrow: true)
	end


	# test 3

	def check_method_3 a, types, values, options = {}

		self.class.check_param a, 'a', options.merge({ types: types, values: values })
	end

	def test_3

		assert_raise RangeError do
			check_method_3(-1, nil, [ 0..2 ])
		end
		assert_equal 0, check_method_3(0, nil, [ 0..2 ])
		assert_equal 1, check_method_3(1, nil, [ 0..2 ])
		assert_equal 2, check_method_3(2, nil, [ 0..2 ])
		assert_raise RangeError do
			check_method_3(3, nil, [ 0..2 ])
		end
	end


	# test 4

	def check_method_4 a, types, values, options = {}, &block

		self.class.check_param a, 'a', options.merge({ types: types, values: values }), &block
	end

	def test_4

		assert_equal 0, check_method_4(0, nil, nil)
		assert_equal 0, check_method_4(0, nil, nil) { |n| 0 == n }

		assert_raise RangeError do
			check_method_4(-1, nil, nil) { |n| 0 == n }
		end

		assert_raise ArgumentError do
			check_method_4('-1', nil, nil) { |n| 0 == n }
		end

		assert_raise TypeError do
			check_method_4('-1', [ ::Numeric ], nil)
		end
		assert_raise ArgumentError do
			check_method_4('-1', [ ::String ], [ '-2', '0', '+1', '+2' ])
		end
		assert_equal '-1', check_method_4('-1', [ ::String ], [ '-2', '-1', '0', '+1', '+2' ])
#		assert_raise RangeError do
#			check_method_4('-1', [ ::String ], [ '-2', '0', '+1', '+2' ]) {
#		end

#		check_param(id, 'id', types: ::Integer) { |v| raise ArgumentError, "'id' must be a positive integer" unless v > 0 }

	end



	# test 5

	def check_method_5 a, options = {}

		self.class.check_param a, 'a', options
	end

	def test_5

		assert_equal "", check_method_5("", require_empty: true)
		assert_equal "a", check_method_5("a", reject_empty: true)

		assert_raise ArgumentError do
			check_method_5("", reject_empty: true)
		end

if false
		assert_raise ArgumentError do
			check_method_5(nil)
		end

		assert_equal true, check_method_5(true)
		assert_equal '', check_method_5('')
		assert_equal [], check_method_5([])
		assert_equal Hash.new, check_method_5(Hash.new)
end
	end


	# test 6

	def check_method_6 a, types, values, options = {}, &block

		self.class.check_param a, 'a', options.merge({ types: types, values: values }), &block
	end

	def test_6

		begin
			check_method_6 '', [ ::Hash ], []

			assert(false, 'should not get here')
		rescue TypeError => ax

			assert_match(/^parameter 'a' \(String\) must be an instance of Hash$/, ax.message)
		rescue => x

			assert(false, "wrong exception type #{x.class} (with message '#{x.message}')")
		end


		begin
			check_method_6 '', [ ::String ], [ 'b', 'c', 'd' ]

			assert(false, 'should not get here')
		rescue ArgumentError => ax

			assert_match(/^parameter 'a' value '' not found equal\/within any of required values or ranges$/, ax.message)
		rescue => x

			assert(false, "wrong exception type #{x.class} (with message '#{x.message}')")
		end
	end


	# test 7 - verify that can include an array of types in the array of types

	def check_method_7 a, types, values, options = {}, &block

		self.class.check_param a, 'a', options.merge({ types: types, values: values }), &block
	end

	def test_7

		assert_equal [], check_method_7([], [ ::Array ], nil)

		assert_equal [ 'abc' ], check_method_7([ 'abc' ], [ ::Array ], nil)

		assert_equal [ 'abc' ], check_method_7([ 'abc' ], [ [ ::String ] ], nil)

		assert_equal [ 'abc' ], check_method_7([ 'abc' ], [ [ ::Regexp, ::String ] ], nil)

		assert_equal [ :'abc' ], check_method_7([ :'abc' ], [ [ ::Regexp, ::Symbol ] ], nil)


		begin
			check_method_7 [ 'abc' ], [ ::Symbol, [ ::Regexp, ::Symbol ], ::Hash ], nil

			assert(false, 'should not get here')
		rescue TypeError => ax

			assert_match(/^parameter 'a' \(Array\) must be an instance of Symbol or Hash, or an array containing instance\(s\) of Regexp or Symbol$/, ax.message)
		rescue => x

			assert(false, "wrong exception type #{x.class}) (with message '#{x.message}'")
		end


		begin
			check_method_7 [ 'abc' ], [ [ ::Regexp, ::Symbol ] ], nil

			assert(false, 'should not get here')
		rescue TypeError => ax

			assert_match(/^parameter 'a' \(Array\) must be an array containing instance\(s\) of Regexp or Symbol$/, ax.message)
		rescue => x

			assert(false, "wrong exception type #{x.class}) (with message '#{x.message}'")
		end
	end


	# responds_to

	def check_responds_to a, messages, options = {}, &block

		self.class.check_param a, 'a', options.merge({ responds_to: messages }), &block
	end

	def test_responds_to

		assert check_responds_to Hash.new, [ :[], :map, :to_s ]
		assert_raise ::TypeError do

			check_responds_to Hash.new, [ :this_is_not_a_Hash_method ]
		end
	end



	# test type:

	def check_method_type a, type

		self.class.check_parameter a, 'a', type: type
	end

	def test_type

		check_method_type '', ::String

		assert_raise TypeError do

			check_method_type :sym, ::String
		end
	end
end

