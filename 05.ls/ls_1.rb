# frozen_string_literal: true

require 'optparse' # オプション
require 'etc'

option = ARGV.getopts('a', 'r', 'l')
file_names = option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
file_names.reverse! if option['r']
status = file_names.map { |file| File.lstat(file) }

countfile = file_names.map(&:length).max # 最大文字数を算出
files_count = file_names.count
quotient, surplus = files_count.divmod(3) # 商と余り
quotient += 1 if surplus.positive?

slice_files = file_names.each_slice(quotient).to_a
max_array_size = slice_files.map(&:size).max

transposed_files = slice_files.map { |file| (file + [' '] * max_array_size)[0...max_array_size] }.transpose # 配列の要素数を揃える
columns_max_string = transposed_files.transpose.map { |array| array.max_by(&:length).length }

# パーミッション
types = { 'file' => '-', 'directory' => 'd', ' characterSpecial' => 'c', 'blockSpecial' => 'b', 'link' => 'l', 'fifo' => 'p', 'socket' => 's' }
files_type = status.map { |file| types[file.ftype] }

octal_permissions = status.map { |decimal| (decimal.mode.to_s(8).to_i % 1000).digits.reverse }
rwx = { 0 => '---', 1 => '--x', 2 => '-w-', 3 => '-wx', 4 => 'r--', 5 => 'r-x', 6 => 'rw-', 7 => 'rwx' }
rwx_permissions = octal_permissions.each do |array|
  array.map! { |octal| rwx[octal] }
  array.join
end
files_permission = files_type.zip(rwx_permissions).map(&:join)

# 各種情報
hard_links = status.map { |file| file.nlink.to_s }
user = file_names.map { |file| Etc.getpwuid(File.lstat(file).uid).name }
groups = file_names.map { |file| Etc.getgrgid(File.lstat(file).gid).name }
file_size = status.map { |file| file.size.to_s }
update_day = status.map { |time| time.mtime.strftime('%-m %e') }
update_time = status.map { |time| time.mtime.strftime('%H:%M') }
file_blocks = status.map(&:blocks)

# 結合
files_zip = files_permission.zip(hard_links, user, groups, file_size, update_day, update_time, file_names)
status_columns_maxstring = files_zip.transpose.map { |array| array.max_by(&:length).length }

# 出力
if option['l']
  (puts "total #{file_blocks.sum}"
   files_zip.each do |array|
     files_status = array.map.with_index do |item, column_index|
       column_index == 7 ? item.ljust(status_columns_maxstring[column_index]) : item.rjust(status_columns_maxstring[column_index])
     end
     puts files_status.join(' ' * 2)
   end)
end

unless option['l']
  transposed_files.each do |array|
    ljusted_files = array.map.with_index { |item, column_index| item.ljust(columns_max_string[column_index]) }
    puts ljusted_files.join(' ' * countfile)
  end
end
