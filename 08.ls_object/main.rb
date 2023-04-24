# frozen_string_literal: true

require 'optparse'
require_relative 'my_file'
require_relative 'option'
require_relative 'list'

options = ARGV.getopts('a', 'r', 'l')
List.new(options).output_list
