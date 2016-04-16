
# ######################################################################## #
# File:         lib/xqsr3/command_line_utilities/map_option_string.rb
#
# Purpose:      Definition of the ::Xqsr3::CommandLineUtilities::ToSymbol
#               module
#
# Created:      15th April 2016
# Updated:      17th April 2016
#
# Home:         http://github.com/synesissoftware/xqsr3
#
# Author:       Matthew Wilson
#
# Copyright (c) 2016, Matthew Wilson and Synesis Software
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the names of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ######################################################################## #



# ##########################################################
# ::Xqsr3::CommandLineUtilities::ToSymbol

require 'xqsr3/string_utilities/to_symbol'

module Xqsr3
module CommandLineUtilities

module MapOptionString

	def self.included includer

		raise TypeError, "module #{self} cannot be included into #{includer} because it does not respond to to_str" unless includer.method_defined? :to_str
	end

	private
	module MapOptionString_Helper_

		def self.map_option_string_with_options_ s, option_strings, options

			h = {}

			option_strings.each do |os|

				t	=	os.dup
				v	=	os.dup

				if t =~ /\[.+?\]/

					k = ''
					v = ''

					while t =~ /\[(.+?)\]/

						k	+=	$1
						v	+=	"#$`#$1"
						t	=	$'
					end

					v	+=	t
				else

					k = v
				end

				h[k] = v
				h[v] = v
			end

			r = h[s]

			if r

				r = ::Xqsr3::StringUtilities::ToSymbol.string_to_symbol r
			end

			r
		end
	end
	public

	def self.map_option_string_from_string s, option_strings, options = {}

		MapOptionString_Helper_.map_option_string_with_options_ s, option_strings, options
	end

	def map_option_string option_strings, options = {}

		s = self.kind_of?(::String) ? self : self.to_str

		MapOptionString_Helper_.map_option_string_with_options_ s, option_strings, options
	end
end

end
end

# ############################## end of file ############################# #
