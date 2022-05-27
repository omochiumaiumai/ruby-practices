# frozen_string_literal: true

require 'optparse'

def pipe_input
  @specified_file = $stdin.to_a
  @lines = @specified_file.count
  @words = @specified_file.map { |array| array.delete("\n") }
  @byte_size = @words.join.bytesize
  @words = @words.map { |array| array.split.count }.sum
  @various_data = [[@lines, @words, @byte_size]]
  @total = ['']
end

def command_line_input
  @specified_file = ARGV
  open_files = @specified_file.map { |file| File.open(file, 'r') }
  @words = open_files.map { |file| file.read.split.count }

  open_files = @specified_file.map { |file| File.open(file, 'r') }
  @lines = open_files.map { |file| file.read.count("\n") }

  open_files = @specified_file.map { |file| File.open(file, 'r') }
  @byte_size = open_files.map { |file| file.read.bytesize }

  @various_data = @lines.zip(@words, @byte_size, @specified_file)

  @total = [@lines.sum, @words.sum, @byte_size.sum]
end

options = ARGV.getopts('c', 'l', 'w')

if File.pipe?($stdin) == true
  pipe_input
else
  command_line_input
end

ljusted_files = if options.values.any? == true
                  @various_data.each do |array|
                    array.delete_at(2) unless options['c']
                    array.delete_at(1) unless options['w']
                    array.delete_at(0) unless options['l']
                  end
                else
                  @various_data
                end
if options.values.any? == false
  @total
else
  @total.delete_at(2) unless options['c']
  @total.delete_at(1) unless options['w']
  @total.delete_at(0) unless options['l']
end
@total.map! { |total_value| total_value.to_s.rjust(8, ' ') }
@total.push(' total')

files = ljusted_files.count

ljusted_files.map! do |array|
  array.map! { |value_and_filename| value_and_filename.to_s.rjust(8, ' ') }
  array.insert(-2, ' ') unless array.count == 1
  array.join
end
puts ljusted_files
puts @total.join if files > 1
