# frozen_string_literal: true

class List
  COLUMNS_COUNT = 3

  def initialize(options)
    @options = Option.new(options)
  end

  def select_files_in_directory
    files_names = @options.all ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files_names.map { |file_name| FileAndDirectory.new(file_name) }
  end

  def select_files
    files = select_files_in_directory
    files = files.reverse if @options.reverse
    files
  end

  def lists_column_max_width(files)
    max_permissions = files.map { |file| file.permission.length }.max
    max_hard_links = files.map { |file| file.hard_link.to_s.length }.max
    max_owner = files.map { |file| file.owner_name.length }.max
    max_group = files.map { |file| file.group_name.length }.max
    max_size = files.map { |file| file.size.to_s.length }.max
    max_date = files.map { |file| file.update_day.length }.max
    max_time = files.map { |file| file.update_time.length }.max
    { permission: max_permissions, hard_link: max_hard_links, owner: max_owner,
      group: max_group, size: max_size, date: max_date, time: max_time }
  end

  def total_blocks(files)
    files.map(&:blocks).sum
  end

  def create_columns(files)
    columns = []
    files_per_column = (files.count / COLUMNS_COUNT.to_f).ceil
    files.each_slice(files_per_column) { |file| columns << file }
    columns.last << nil while columns.last.size < files_per_column

    columns.transpose
  end

  def columns_max_width(columns)
    columns_max_width = []
    columns.each do |column|
      column_widths = column.map do |file|
        if file.instance_of?(FileAndDirectory)
          file.name.length + 1
        else
          file.to_s.length
        end
      end
      columns_max_width << column_widths
    end
    columns_max_width.transpose.map(&:max)
  end

  def long_format_list_output(files)
    columns_max_width = lists_column_max_width(files)
    total_blocks = total_blocks(files)

    puts "total #{total_blocks}"
    files.each do |file|
      print "#{file.permission.ljust(columns_max_width[:permission])} #{file.hard_link.to_s.ljust(columns_max_width[:hard_link])}  "
      print "#{file.owner_name.ljust(columns_max_width[:owner])} #{file.group_name.ljust(columns_max_width[:group])}  "
      print "#{file.size.to_s.rjust(columns_max_width[:size])} #{file.update_day.rjust(columns_max_width[:date])} "
      print "#{file.update_time.ljust(columns_max_width[:time])} #{file.name}"
      puts ''
    end
  end

  def default_format_list_output(files)
    columns = create_columns(files)
    columns_max_width = columns_max_width(columns)
    columns.each do |column|
      column.each_with_index do |file, index|
        print file&.name&.ljust(columns_max_width[index]) || ''.ljust(columns_max_width[index])
        print '  '
      end
      puts ''
    end
  end

  def output_list
    files = select_files
    if @options.long
      long_format_list_output(files)
    else
      default_format_list_output(files)
    end
  end
end
