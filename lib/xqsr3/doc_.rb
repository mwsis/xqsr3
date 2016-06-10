
# ######################################################################## #
# File:         lib/xqsr3/doc_.rb
#
# Purpose:      Documentation of the ::Xqsr3 modules
#
# Created:      10th June 2016
# Updated:      10th June 2016
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


=begin
=end

# Main module for Xqsr3 library
#
# === Subordinate modules of interest
# * ::Xqsr3::CommandLineUtilities
# * ::Xqsr3::Containers
# * ::Xqsr3::Diagnostics
# * ::Xqsr3::IO
# * ::Xqsr3::Quality
# * ::Xqsr3::StringUtilities
module Xqsr3

	# Command-line Utilities
	#
	# === Subordinate modules of interest
	# * ::Xqsr3::CommandLineUtilities::MapOptionString
	module CommandLineUtilities

	end # module CommandLineUtilities

	# Containers
	#
	module Containers

	end # module Containers

	# Diagnostic facilities
	#
	# === Subordinate modules of interest
	# * ::Xqsr3::Diagnostics::ExceptionUtilities
	#
	module Diagnostics

		# Exception-related utilities
		#
		# === Components of interest
		# * ::Xqsr3::Diagnostics::ExceptionUtilities::raise_with_options
		#
		module ExceptionUtilities
		end # module ExceptionUtilities
	end # module Diagnostics

	# IO
	#
	module IO

	end # module IO

	# Quality
	#
	# === Subordinate modules of interest
	# * ::Xqsr3::Quality::ParameterChecking
	module Quality

	end # module Quality

	# String utilities
	#
	# === Subordinate modules of interest
	# * ::Xqsr3::StringUtilities::ToSymbol
	module StringUtilities

	end # module StringUtilities

end # module Xqsr3

# ############################## end of file ############################# #
