#!/usr/bin/env ruby
#
# Reverses getters and setters.  Because it's fun!
#
# == Authors
#
# * Ben Bleything <ben@bleything.net>
#
# == Contributors
#
# * Thanks to apeiros of #ruby-lang on freenode for a prototype of the method
#   swapping code
#
# == Copyright
#
# Copyright (c) 2008 Ben Bleything
#
# This code released under the terms of the DO WHAT THE FUCK YOU WANT TO PUBLIC
# LICENSE.
#

module Flunch::StrikeThat
	def reverse_it!
		setters = self.methods.
			select {|m| m =~ /=$/  }.
			reject {|m| m =~ /==$/ }

		setters.each do |setter_name|
			getter_name = setter_name.sub( /=$/, '' )
			
			self.class.instance_eval do
				# stash our methods away for later.  Of special note is that we
				# are subbing in the getter name in both cases, since we don't
				# want the = in there
				alias_method "flunched_#{getter_name}_setter", setter_name
				alias_method "flunched_#{getter_name}_getter", getter_name
				
				# remove the old methods.  mwahaha?
				undef_method setter_name
				undef_method getter_name
				
				# move the setter into the getter
				alias_method getter_name, "flunched_#{getter_name}_setter"
				
				# the setter form is a special case in the parser, so we have to
				# wrap it in a method with arity 1 so you can call it with a
				# throwaway argument
				define_method setter_name do |_|
					eval "flunched_#{getter_name}_getter"
				end
			end
		end
		
		"all done, boss"
	end
end
