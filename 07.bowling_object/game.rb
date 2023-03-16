# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(mark)
    @mark = mark
  end

  def split_marks
    @mark.split(',')
  end

  def shots_parse
    shots = []
    slice_shots = []

    split_marks.each do |mark|
      frame_size = shots.size / 2
      shots << Shot.new(mark)
      shots << Shot.new('0') if frame_size < 9 && mark == 'X'
    end

    shots.each_slice(2) { |shot| slice_shots << shot }
    if slice_shots.size > 10
      slice_shots[9].concat(slice_shots.last)
      slice_shots.delete(slice_shots.last)
    end
    slice_shots
  end

  def set_frames
    shots_parse.map do |shot|
      Frame.new(shot[0], shot[1], shot[2])
    end
  end

  def calc_score
    @frames = set_frames
    bonus_added_scores = []
    @frames.each do |frame|
      bonus_added_scores << frame.score + bonus_score(frame)
    end
    bonus_added_scores.sum
  end

  def scores_output
    puts calc_score
  end

  def bonus_score(frame)
    current_frame_index = @frames.index(frame)

    return 0 unless frame.strike? || frame.spare?
    return 0 unless current_frame_index < 9

    if frame.strike?
      next_frame_strike_bonus(current_frame_index)
    elsif frame.spare?
      @frames[current_frame_index + 1].first_shot.score
    end
  end

  def next_frame_strike_bonus(current_frame_index)
    if @frames[current_frame_index + 1].strike? && current_frame_index < 8
      @frames[current_frame_index + 1].first_shot.score + @frames[current_frame_index + 1 + 1].first_shot.score
    else
      @frames[current_frame_index + 1].first_shot.score + @frames[current_frame_index + 1].second_shot.score
    end
  end
end
