# gemspec for xqsr3

$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'xqsr3/version'

Gem::Specification.new do |gs|

	gs.name			=	'xqsr3'
	gs.version		=	Xqsr3::VERSION
	gs.date			=	Date.today.to_s
	gs.summary		=	'xqsr3'
	gs.description	=	'xqsr3 Ruby library'
	gs.authors		=	[ 'Matt Wilson' ]
	gs.email		=	'matthew@synesis.com.au'
	gs.files		=	Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")
	gs.homepage		=	'http://github.com/synesissoftware/xqsr3'
	gs.license		=	'Modified BSD'
end

