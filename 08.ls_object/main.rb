# frozen_string_literal: true

require 'optparse'
require_relative 'my_file'
require_relative 'option'
require_relative 'ls_command'

options = ARGV.getopts('a', 'r', 'l')
LsCommand.new(options).output_files
