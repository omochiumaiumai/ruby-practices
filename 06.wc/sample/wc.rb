# frozen_string_literal: true

require 'optparse' # オプション

def pipe_input
  @specified_file = $stdin.to_a
  @lines = @specified_file.count # 要素数 ＝ 行数
  @words = @specified_file.map { |x| x.delete("\n") }
  @byte_size = @words.join.bytesize # バイトサイズ
  @words = @words.map { |x| x.split.count }.sum # 単語数
  @aaa = [[@lines, @words, @byte_size]]
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

  @aaa = @lines.zip(@words, @byte_size, @specified_file)

  @total = [@lines.sum, @words.sum, @byte_size.sum]
end

options = ARGV.getopts('c', 'l', 'w')
p File.pipe?($stdin)
if File.pipe?($stdin) == true
  pipe_input
else
  command_line_input
end

ljusted_files = if options.values.any? == true
                  @aaa.each do |array|
                    array.delete_at(2) unless options['c']
                    array.delete_at(1) unless options['w']
                    array.delete_at(0) unless options['l']
                  end
                else
                  @aaa
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

elements = ljusted_files.count
ljusted_files.map! do |array|
  array.map! { |value_and_filename| value_and_filename.to_s.rjust(8, ' ') }
  array.insert(-2, ' ') unless array.count == 1
end

puts ljusted_files
puts @total.join if elements > 1
