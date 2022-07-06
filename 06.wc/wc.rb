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
  file_names = collect_file_names

  strings_in_files.map! do |files|
    files.map { |file| file.delete("\n") }
  end

  lines = strings_in_files.map(&:count)

  words = strings_in_files.map do |files|
    files.map { |file| file.split.count }.sum
  end

  character_count = strings_in_files.map do |files|
    files.map(&:bytesize).sum
  end

  values = file_names.zip(lines, words, character_count)
  values.map do |x|
    { file_name: x[0], line_count: x[1], word_count: x[2], character_count: x[3] }
  end
end

# def options_select(values_hash, options)
#  return values_hash if !options['c'] && !options['w'] && !options['l']

#  values_hash.delete(:character_count) unless options['c']
#  values_hash.delete(:word_count) unless options['w']
#  values_hash.delete(:line_count) unless options['l']
#  values_hash
# end

def output(values, options)
  file_names = collect_file_names
  max_length = file_names.max.length
  values_and_filenames = values.map(&:values).transpose
  total_values = { line_total: values_and_filenames[1].sum, words_total: values_and_filenames[2].sum, character_total: values_and_filenames[3].sum }

  values.each do |values_hash|
    if options['l']
      p "#{values_hash[:line_count].to_s.rjust(8, ' ')} #{values_hash[:file_name].ljust(max_length, '0')}"
    elsif options['w']
      p "#{values_hash[:word_count].to_s.rjust(8, ' ')} #{values_hash[:file_name].ljust(max_length, '0')}"
    elsif options['c']
      p "#{values_hash[:character_count].to_s.rjust(8, ' ')} #{values_hash[:file_name].ljust(max_length, '0')}"
    end
  end

  if options['l'] && file_names.count > 1
    p "#{total_values[:line_total].to_s.rjust(8, ' ')} total"
  elsif options['w'] && file_names.count > 1
    p "#{total_values[:words_total].to_s.rjust(8, ' ')} total"
  elsif options['c'] && file_names.count > 1
    p "#{total_values[:character_total].to_s.rjust(8, ' ')} total"
  end
end

def main
  options = ARGV.getopts('c', 'l', 'w')
  strings_in_files = check_input_source
  values = calculate_values(strings_in_files)
  output(values, options)
end

main
