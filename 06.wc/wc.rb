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

  lines.zip(words, byte_size)
end

def options_select(values, options)
  return values if !options['c'] && !options['w'] && !options['l']

  values_hash = { line_count: values[0], word_count: values[1], character_count: values[2] }
  values_hash.delete(:character_count) unless options['c']
  values_hash.delete(:word_count) unless options['w']
  values_hash.delete(:line_count) unless options['l']
  values_hash.values
end

def prepare_output(calculated_values, file_names, options)
  total_values = calculated_values.transpose
  calculated_values.map! do |values|
    values.map { |value| value.to_s.rjust(8, ' ') }
  end
  calculated_values = calculated_values.transpose
  calculated_values = options_select(calculated_values, options)

  total_values.map!(&:sum)
  total_values.map! { |value| value.to_s.rjust(8, ' ') }
  total_values = options_select(total_values, options)
  total_values.insert(-1, ' ', 'total')
  max_length = file_names.max.length
  file_names.map! { |file_name| file_name.ljust(max_length, ' ') }

  calculated_values = calculated_values.push(file_names).transpose
  calculated_values.map! do |values|
    values.insert(-2, ' ')
    values.join
  end
  { calculated_values: calculated_values, total_values: total_values.join }
end

def output(values_and_filenames)
  puts values_and_filenames[:calculated_values]
  puts values_and_filenames[:total_values] if values_and_filenames[:calculated_values].count > 1
end

def main
  options = ARGV.getopts('c', 'l', 'w')
  strings_in_files = check_input_source
  calculated_values = calculate_values(strings_in_files)
  file_names = collect_file_names
  values_and_filenames = prepare_output(calculated_values, file_names, options)
  output(values_and_filenames)
end

main
