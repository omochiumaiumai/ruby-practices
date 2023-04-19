# frozen_string_literal: true

class List
  COLUMNS_COUNT = 3

  def initialize(files)
    @files = files
  end

  def lists_column_max_width
    max_permissions = @files.map { |file| file.permission.length }.max
    max_hard_links = @files.map { |file| file.hard_link.to_s.length }.max
    max_owner = @files.map { |file| file.owner_name.length }.max
    max_group = @files.map { |file| file.group_name.length }.max
    max_size = @files.map { |file| file.size.to_s.length }.max
    max_date = @files.map { |file| file.update_day.length }.max
    max_time = @files.map { |file| file.update_time.length }.max
    { permission: max_permissions, hard_link: max_hard_links, owner: max_owner,
      group: max_group, size: max_size, date: max_date, time: max_time }
  end

  def total_blocks
    @files.map(&:blocks).sum
  end

  def create_columns
    columns = []
    files_per_column = (@files.count / COLUMNS_COUNT.to_f).ceil
    @files.each_slice(files_per_column) { |file| columns << file }
    columns.last << nil while columns.last.size < files_per_column

    columns.transpose
  end

  def columns_max_width
    columns = create_columns
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
end
