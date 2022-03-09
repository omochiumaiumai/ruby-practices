# frozen_string_literal: true

require 'optparse' # オプション

file_names = Dir.glob('*')
countfile = file_names.map(&:length).max # 最大文字数を算出

files_count = file_names.count
quotient, surplus = files_count.divmod(3) # 商と余り
quotient += 1 if surplus.positive?

slice_files = file_names.each_slice(quotient).to_a
max_array_size = slice_files.map(&:size).max

files_transposed = slice_files.map { |file| (file + [' '] * max_array_size)[0...max_array_size] }.transpose # 配列の要素数を揃える
columns_max_string = files_transposed.transpose.map { |array| array.sort_by(&:length).last.length }

line_one = []
files_transposed.each do |array|
  line_one << array[0].ljust(*columns_max_string[0], ' ')
end
line_two = []
files_transposed.each do |array|
  line_two << array[1].ljust(*columns_max_string[1], ' ')
end
line_three = []
files_transposed.each do |array|
  line_three << array[2].ljust(*columns_max_string[2], ' ')
end

line_one.zip(line_two, line_three) { |arary| puts arary.join(' ' * countfile) }
