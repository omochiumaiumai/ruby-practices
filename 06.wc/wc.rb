# frozen_string_literal: true

require 'readline'
require 'optparse'

def input_check
  if File.pipe?($stdin)
    [$stdin.to_a]
  else
    ARGV.map { |file| File.open(file, 'r').readlines }
  end
end

def file_names_get
  if ARGV.any?
    ARGV
  else
    [' ']
  end
end

def calculate_values(entered_files)
  entered_files.map! do |files|
    files.map { |file| file.delete("\n") }
  end

  lines = entered_files.map(&:count)
  words = entered_files.map do |files|
    files.map { |file| file.split.count }.sum
  end
  byte_size = entered_files.map do |files|
    files.map(&:bytesize).sum
  end

  lines.zip(words, byte_size)
end

def options_select(values, options)
  if options.values.any? == false
    values
  else
    values.delete_at(2) unless options['c']
    values.delete_at(1) unless options['w']
    values.delete_at(0) unless options['l']
  end
end

def prepare_output(file_values, file_names, total_values, options)
  file_values.map! do |values|
    values.map { |value| value.to_s.rjust(8, ' ') }
  end
  file_values = file_values.transpose
  options_select(file_values, options)

  total_values.map!(&:sum)
  total_values.map! { |value| value.to_s.rjust(8, ' ') }
  total_values.insert(-1, ' ', 'total')
  options_select(total_values, options)

  max_character = file_names.max.length
  file_names.map! { |file_name| file_name.ljust(max_character, ' ') }

  file_values = file_values.push(file_names).transpose
  file_values.map! do |values|
    values.insert(-2, ' ')
    values.join
  end
end

def output(values_and_filenames, total_values)
  values_and_filenames.each do |values|
    puts values
  end
  puts total_values.join if values_and_filenames.count > 1
end

def main
  options = ARGV.getopts('c', 'l', 'w')
  entered_files = input_check
  file_values = calculate_values(entered_files)
  file_names = file_names_get
  total_values = file_values.transpose

  values_and_filenames = prepare_output(file_values, file_names, total_values, options)
  output(values_and_filenames, total_values)
end

main
