# frozen_string_literal: true

require_relative 'list'

class LsCommand
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

  def output_files
    files = select_files
    files_list = List.new(files)
    if @options.long
      columns_max_width = files_list.lists_column_max_width
      total_blocks = files_list.total_blocks

      puts "total #{total_blocks}"
      files.each do |file|
        print "#{file.permission.ljust(columns_max_width[:permission])} #{file.hard_link.to_s.ljust(columns_max_width[:hard_link])}  "
        print "#{file.owner_name.ljust(columns_max_width[:owner])} #{file.group_name.ljust(columns_max_width[:group])}  "
        print "#{file.size.to_s.rjust(columns_max_width[:size])} #{file.update_day.rjust(columns_max_width[:date])} "
        print "#{file.update_time.ljust(columns_max_width[:time])} #{file.name}"
        puts ''
      end
    else
      columns = files_list.create_columns
      columns_max_width = files_list.columns_max_width
      columns.each do |column|
        print "#{column[0].name.ljust(columns_max_width[0])}  "
        print "#{column[1]&.name&.ljust(columns_max_width[1])}  "
        puts(column[2].instance_of?(FileAndDirectory) ? column[2].name.ljust(columns_max_width[2]) : column[2].ljust(columns_max_width[2]))
      end
    end
  end
end
