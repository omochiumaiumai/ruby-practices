# frozen_string_literal: true

require 'readline'
require 'optparse'

def check_input_source
  if File.pipe?($stdin)
    [{ file_name: '', content: [$stdin.to_a] }]
  else
    file_names = ARGV.map { |file_name| " #{file_name}" }
    [{ file_name: file_names, content: ARGV.map { |file| File.open(file, 'r').readlines } }]
  end
end

def calculate_values(filename_and_contents)
  filename_and_contents.map do |hash|
    lines = hash[:content].map do |contents|
      contents.map { |content| content.delete("\n") }.count
    end
    words = hash[:content].map do |contents|
      contents.map { |content| content.split.count }.sum
    end
    character_count = hash[:content].map do |contents|
      contents.map(&:bytesize).sum
    end
    { file_names: hash[:file_name], line_count: lines, word_count: words, character_count: character_count }
  end
end

def display_line?(options)
  (!options['c'] && !options['w'] && !options['l']) || options['l']
end

def display_word?(options)
  (!options['c'] && !options['w'] && !options['l']) || options['w']
end

def display_character?(options)
  (!options['c'] && !options['w'] && !options['l']) || options['c']
end

def output(values_and_filenames, options)
  values_and_filenames = values_and_filenames[0]
  max_length = values_and_filenames[:file_names].map { _1.length }.max
  file_count = values_and_filenames[:file_names].count

  display_line = display_line?(options)
  display_word = display_word?(options)
  display_character = display_character?(options)

  file_count.times do |count|
    print values_and_filenames[:line_count][count].to_s.rjust(8) if display_line
    print values_and_filenames[:word_count][count].to_s.rjust(8) if display_word
    print values_and_filenames[:character_count][count].to_s.rjust(8) if display_character
    print values_and_filenames[:file_names][count].ljust(max_length)
    puts ''
  end
  output_total(values_and_filenames, options, max_length) if file_count > 1
end

def output_total(values_and_filenames, options, max_length)
  display_line = display_line?(options)
  display_word = display_word?(options)
  display_character = display_character?(options)

  print values_and_filenames[:line_count].sum.to_s.rjust(8) if display_line
  print values_and_filenames[:word_count].sum.to_s.rjust(8) if display_word
  print values_and_filenames[:character_count].sum.to_s.rjust(8) if display_character
  print ' total'.ljust(max_length)
end

def main
  options = ARGV.getopts('c', 'l', 'w')
  filename_and_contents = check_input_source
  values_and_filenames  = calculate_values(filename_and_contents)
  output(values_and_filenames, options)
end

main
