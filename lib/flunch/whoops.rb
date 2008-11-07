#!/usr/bin/env ruby
#
# Removes a method from an object at random.  Whoops!
#
# == Authors
#
# * John Guenin <john@guen.in>
#
# == Copyright
#
# Copyright (c) 2008 John Guenin
#
# This code released under the terms of the DO WHAT THE FUCK YOU WANT TO PUBLIC
# LICENSE.
#

module Flunch::Whoops
  def look_at_all_the_things_im_not_doing!
    # pick a method at random to not do anymore, except...
    #   * class or methods, because we need them to undef more methods later
    #   * any of the __ methods because we'll give your program a fighting chance
    #       of not immediately segfaulting
    random_method = methods.
                      reject { |m| m =~ /^__|^class$|^methods$/ }.
                      sort_by { rand }.
                      first
    
    # remove it from the instance
    self.class.class_eval do
      undef_method random_method
    end if random_method
    
    random_method
  end
end
