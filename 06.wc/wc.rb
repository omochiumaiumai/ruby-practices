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

def output(values_and_filenames, options)
  values_and_filenames = values_and_filenames[0]

  line_option = options['l']
  word_option = options['w']
  character_count_option = options['c']

  file_count = values_and_filenames[:file_names].count

  file_count.times do |count|
    print values_and_filenames[:line_count][count].to_s.rjust(8) if line_option
    print values_and_filenames[:word_count][count].to_s.rjust(8) if word_option
    print values_and_filenames[:character_count][count].to_s.rjust(8) if character_count_option
    print (values_and_filenames[:file_names][count]).to_s

    puts ''

    print values_and_filenames[:line_count].sum.to_s.rjust(8) if line_option && count > 1
    print values_and_filenames[:word_count].sum.to_s.rjust(8) if word_option && count > 1
    print values_and_filenames[:character_count].sum.to_s.rjust(8) if character_count_option && count > 1
    print ' total' if count > 1
  end
end

def main
  options = ARGV.getopts('c', 'l', 'w')
  filename_and_contents = check_input_source
  values_and_filenames  = calculate_values(filename_and_contents)
  output(values_and_filenames, options)
end

main
