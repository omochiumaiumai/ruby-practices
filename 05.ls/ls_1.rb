# frozen_string_literal: true

require 'optparse' # オプション

find_files = Dir.glob('*')
countfile = find_files.map(&:length).max # 最大文字数を算出

files_count = find_files.count
quotient = files_count.divmod(3)[0] # 商
surplus = files_count.divmod(3)[1] # 余り

quotient += 1 if surplus.positive?

slice_files = find_files.each_slice(quotient).to_a

max_array_size = slice_files.map(&:size).max
files_transposed = slice_files.map { |file| (file + [nil] * max_array_size)[0...max_array_size] }.transpose # 配列の要素数を揃える

files_transposed.map { |array| puts array.join(' ' * (countfile + 4)) }
