# frozen_string_literal: true

require 'etc'

class MyFile
  attr_reader :name

  def initialize(name)
    @name = name
    @file = File.stat(name)
  end

  def blocks
    @file.blocks
  end

  def hard_link
    @file.nlink
  end

  def permission
    permission_numbers = @file.mode.to_s(8)[-3, 3].chars
    permission_marks = { 0 => '---', 1 => '--x', 2 => '-w-', 3 => '-wx', 4 => 'r--', 5 => 'r-x', 6 => 'rw-', 7 => 'rwx' }
    permission_strings = permission_numbers.map do |number|
      permission_marks[number.to_i]
    end
    case File.ftype(name)
    when 'directory'
      permission_strings.unshift('d')
    when 'link'
      permission_strings.unshift('l')
    when 'file'
      permission_strings.unshift('-')
    end
    permission_strings.join
  end

  def owner_name
    Etc.getpwuid(File.stat(name).uid).name
  end

  def group_name
    Etc.getgrgid(File.stat(name).gid).name
  end

  def size
    @file.size
  end

  def update_day
    @file.mtime.strftime('%-m %e')
  end

  def update_time
    @file.mtime.strftime('%H:%M')
  end
end
