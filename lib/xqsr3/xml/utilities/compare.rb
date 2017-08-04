
require 'xqsr3/quality/parameter_checking'

require 'nokogiri'

module Xqsr3
module XML
module Utilities

module Compare

	# Class that represents the result of an XML comparison
	#
	# NOTE: Sadly, we cannot create instances of +FalseClass+/+TrueClass+,
	# to which we could then add a +reason+ attribute, so instead we must
	# have a results class
	class Result

		include ::Xqsr3::Quality::ParameterChecking

		protected :check_parameter

		#
		# Options:
		#
		# +:different_child_nodes+
		# +:different_number_of_child_nodes+
		# +:different_ordering_of_child_nodes+
		# +:different_node_names+
		# +:different_node_contents+
		# +:parameter_is_empty+
		# +:parameter_is_nil+
		# +:+
		# +:+
		# +:+

		def initialize succeeded, reason, **options

			check_parameter succeeded, 'succeeded', types: [ ::FalseClass, ::TrueClass ]
			check_parameter reason, 'reason', type: ::Symbol

			@succeeded	=	succeeded
			@reason		=	reason

			@lhs_node	=	options[:lhs_node]
			@rhs_node	=	options[:rhs_node]
		end

		def self.return succeeded, reason, **options

			return self.new succeeded, reason, **options
		end

		def self.same reason = '', **options

			return self.new true, reason, **options
		end

		def self.different reason, **options

			return self.new false, reason, **options
		end

		attr_reader	:succeeded
		attr_reader	:reason

		def details

			r	=	reason.to_s.gsub /_/, ' '

			qualifying	=	''

			if @lhs_node

				qualifying	+=	'; ' unless qualifying.empty?
				qualifying	+=	"lhs-node=#{@lhs_node}"
			end

			if @rhs_node

				qualifying	+=	'; ' unless qualifying.empty?
				qualifying	+=	"rhs-node=#{@rhs_node}"
			end

			r = "#{r}: #{qualifying}" unless qualifying.empty?

			r
		end
	end

	module Internal_Compare_

		extend ::Xqsr3::Quality::ParameterChecking

		def self.one_line_ s

			s = s.to_s.gsub(/\s+/, ' ')
		end

		def self.xml_compare_ lhs, rhs, options

			$stderr.puts "#{self}#{__method__}(lhs (#{lhs.class})=#{self.one_line_ lhs}, rhs (#{rhs.class})=#{self.one_line_ rhs}, options (#{options.class})=#{options})" if $DEBUG

			# validate type(s)

			check_param options, 'options', type: ::Hash if $DEBUG

			validate_params	=	$DEBUG || options[:debug] || options[:validate_params]

			check_param lhs, 'lhs', types: [ ::String, ::Nokogiri::XML::Node ], allow_nil: true if validate_params
			check_param rhs, 'rhs', types: [ ::String, ::Nokogiri::XML::Node ], allow_nil: true if validate_params


			# deal with nil(s)

			return Result.same if lhs.nil? && rhs.nil?

			if lhs.nil?

				return Result.same if options[:equate_nil_and_empty] && ::String === rhs && rhs.empty?

				return Result.different :parameter_is_nil
			end

			if rhs.nil?

				return Result.same if options[:equate_nil_and_empty] && ::String === lhs && lhs.empty?

				return Result.different :parameter_is_nil
			end


			# deal with string(s)

			lhs	=	Nokogiri::XML(lhs) if ::String === lhs
			rhs	=	Nokogiri::XML(rhs) if ::String === rhs


			self.xml_compare_nodes_ lhs, rhs, options
		end

		def self.xml_compare_nodes_ lhs, rhs, options

			$stderr.puts "#{self}#{__method__}(lhs (#{lhs.class})=#{self.one_line_ lhs}, rhs (#{rhs.class})=#{self.one_line_ rhs}, options (#{options.class})=#{options})" if $DEBUG


			# Compare:
			#
			# - name
			# - content
			# - children
			# - 


			# ##########################
			# name

			lhs_name	=	lhs.name
			rhs_name	=	rhs.name

			return Result.different :different_node_names, lhs_node: lhs, rhs_node: rhs if lhs_name != rhs_name


			# ##########################
			# content

			if options.has_key? :normalise_whitespace

				normalise_ws	=	options[:normalise_whitespace]
			elsif options.has_key? :normalize_whitespace

				normalise_ws	=	options[:normalize_whitespace]
			else

				normalise_ws	=	false
			end

			lhs_content	=	normalise_ws ? lhs.content.gsub(/\s+/, ' ').strip : lhs.content
			rhs_content	=	normalise_ws ? rhs.content.gsub(/\s+/, ' ').strip : rhs.content

			return Result.different :different_node_contents, lhs_node: lhs, rhs_node: rhs if lhs_content != rhs_content


			# ##########################
			# children (preparation)

			lhs_children		=	lhs.children.to_a
			rhs_children		=	rhs.children.to_a

			lhs_children.reject! { |child| child.text? && child.content.strip.empty? }
			rhs_children.reject! { |child| child.text? && child.content.strip.empty? }


			# ##########################
			# children - count

			lhs_children_count	=	lhs_children.count
			rhs_children_count	=	rhs_children.count

			return Result.different :different_number_of_child_nodes, lhs_node: lhs, rhs_node: rhs if lhs_children_count != rhs_children_count


			# ##########################
			# children - names

			lhs_children_names	=	lhs_children.map { |ch| ch.name }
			rhs_children_names	=	rhs_children.map { |ch| ch.name }

			if lhs_children_names != rhs_children_names

				# At this point, the lists of names of child elements are
				# different. This may be because there are different
				# elements or because they are in a different order. Either
				# way, in order to provide detailed reasons for
				# inequivalency, we must do an order-independent comparison

				children_sorted_lhs	=	lhs_children.sort { |x, y| x.name <=> y.name }
				children_sorted_rhs	=	rhs_children.sort { |x, y| x.name <=> y.name }

				ch_names_sorted_lhs	=	children_sorted_lhs.map { |ch| ch.name }
				ch_names_sorted_rhs	=	children_sorted_rhs.map { |ch| ch.name }

				ignore_order = options.has_key? :element_order && !options[:element_order]

				if ignore_order

					return Result.different :different_child_nodes, lhs_node: lhs, rhs_node: rhs if ch_names_sorted_lhs != ch_names_sorted_rhs

					# Since they are the same (when reordered), we need to
					# adopt the ordered sequences so that the comparison of
					# the children are meaningful

					lhs_children	=	children_sorted_lhs
					rhs_children	=	children_sorted_rhs
				else

					# failed, so need to determine whether it's due to
					# different nodes or different order

					if ch_names_sorted_lhs == ch_names_sorted_rhs

						return Result.different :different_ordering_of_child_nodes, lhs_node: lhs, rhs_node: rhs
					else

						return Result.different :different_child_nodes, lhs_node: lhs, rhs_node: rhs
					end
				end
			end

			(0 ... lhs_children.count).each do |index|

				ch_lhs	=	lhs_children[index]
				ch_rhs	=	rhs_children[index]

				r = self.xml_compare_nodes_ ch_lhs, ch_rhs, options

				return r unless r.succeeded
			end

			return Result.same
		end
	end

	def self.xml_compare lhs, rhs, **options

		$stderr.puts "#{self}#{__method__}(lhs (#{lhs.class})=#{Internal_Compare_.one_line_ lhs}, rhs (#{rhs.class})=#{Internal_Compare_.one_line_ rhs}, options (#{options.class})=#{options})" if $DEBUG

		Internal_Compare_.xml_compare_ lhs, rhs, options
	end

	def xml_compare lhs, rhs, **options

		$stderr.puts "#{self}#{__method__}(lhs (#{lhs.class})=#{Internal_Compare_.one_line_ lhs}, rhs (#{rhs.class})=#{Internal_Compare_.one_line_ rhs}, options (#{options.class})=#{options})" if $DEBUG

		Internal_Compare_.xml_compare_ lhs, rhs, options
	end

end # module Compare

end # module Utilities
end # module XML
end # module Xqsr3

