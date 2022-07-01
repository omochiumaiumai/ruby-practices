# frozen_string_literal: true

require 'readline'
require 'optparse'

def check_input_source
  if File.pipe?($stdin)
    [$stdin.to_a]
  else
    ARGV.map { |file| File.open(file, 'r').readlines }
  end
end

def collect_file_names
  if ARGV.any?
    ARGV
  else
    ['']
  end
end

def calculate_values(strings_in_files)
  strings_in_files.map! do |files|
    files.map { |file| file.delete("\n") }
  end

  lines = strings_in_files.map(&:count)
  words = strings_in_files.map do |files|
    files.map { |file| file.split.count }.sum
  end
  byte_size = strings_in_files.map do |files|
    files.map(&:bytesize).sum
  end

  values = lines.zip(words, byte_size).transpose
  { line_count: values[0], word_count: values[1], character_count: values[2] }
end

def options_select(values_hash, options)
  return values_hash if !options['c'] && !options['w'] && !options['l']

  values_hash.delete(:character_count) unless options['c']
  values_hash.delete(:word_count) unless options['w']
  values_hash.delete(:line_count) unless options['l']
  values_hash
end

def prepare_output(calculated_values, options)
  calculated_values = options_select(calculated_values, options)
  total_values = calculated_values.values.map(&:sum)
  calculated_values[:total_values] = total_values
  calculated_values
end

def output(values_and_total_values)
  values = values_and_total_values.each_value do |array|
    array.map! { |value| value.to_s.rjust(8, ' ') }
    array.join
  end

  file_names = collect_file_names
  max_length = file_names.max.length
  file_names.map! { |file_name| file_name.ljust(max_length, ' ') }

  total_values = values[:total_values]
  total_values += [' ', 'total']
  values.delete(:total_values)
  processed_values = values.values.push(file_names)

  output = processed_values.transpose.map do |array|
    array.insert(-2, ' ')
    array.join
  end
  puts output
  puts total_values.join if output.count > 1
end

def main
  options = ARGV.getopts('c', 'l', 'w')
  strings_in_files = check_input_source
  calculated_values = calculate_values(strings_in_files)
  values_and_total_values = prepare_output(calculated_values, options)
  output(values_and_total_values)
end

main
