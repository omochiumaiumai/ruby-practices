# frozen_string_literal: true

require 'optparse' # オプション

file_names = Dir.glob('*')
countfile = file_names.map(&:length).max # 最大文字数を算出

files_count = file_names.count
quotient, surplus = files_count.divmod(3) #商と余り
quotient += 1 if surplus.positive?

slice_files = file_names.each_slice(quotient).to_a

max_array_size = slice_files.map(&:size).max
files_transposed = slice_files.map { |file| (file + [nil] * max_array_size)[0...max_array_size] }.transpose # 配列の要素数を揃える

files_transposed.map { |array| puts array.join(' ' * (countfile + 4)) }
