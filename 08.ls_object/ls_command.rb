# frozen_string_literal: true

class LsCommand
  def initialize(options)
    @options = Option.new(options)
  end

  def select_files_in_directory
    files_names = @options.all ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files_names.map { |file_name| MyFile.new(file_name) }
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

  def get_total_blocks(files)
    files.map(&:blocks).sum
  end

  def create_columns(files)
    columns = []
    files_per_column = (files.count / 3.0).ceil
    files.each_slice(files_per_column) { |file| columns << file }
    columns.last << '' while columns.last.size < files_per_column

    columns.transpose
  end

  def columns_max_width(columns)
    columns_max_width = []
    columns.each do |column|
      column_widths = column.map do |file|
        if file.instance_of?(MyFile)
          file.name.length + 1
        else
          file.to_s.length
        end
      end
      columns_max_width << column_widths
    end
    columns_max_width.transpose.map(&:max)
  end

  def output_files
    files = select_files
    columns_max_width = lists_column_max_width(files)

    if @options.long
      puts "total #{get_total_blocks(files)}"

      files.each do |file|
        print "#{file.permission.ljust(columns_max_width[:permission])} #{file.hard_link.to_s.ljust(columns_max_width[:hard_link])}  "
        print "#{file.owner_name.ljust(columns_max_width[:owner])} #{file.group_name.ljust(columns_max_width[:group])}  "
        print "#{file.size.to_s.rjust(columns_max_width[:size])} #{file.update_day.rjust(columns_max_width[:date])} "
        print "#{file.update_time.ljust(columns_max_width[:time])} #{file.name}"
        puts ''
      end
    else
      columns = create_columns(files)
      columns_max_width = columns_max_width(columns)
      columns.each do |column|
        print "#{column[0].name.ljust(columns_max_width[0])}  "
        print "#{column[1].instance_of?(MyFile) ? column[1].name.ljust(columns_max_width[1]) : column[1].ljust(columns_max_width[1])}  "
        puts(column[2].instance_of?(MyFile) ? column[2].name.ljust(columns_max_width[2]) : column[2].ljust(columns_max_width[2]))
      end
    end
  end
end
