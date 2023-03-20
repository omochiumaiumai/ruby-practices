# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(mark)
    @mark = mark
  end

  def split_marks
    @mark.split(',')
  end

  def shots_from_marks
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
    @frames = shots_from_marks.map do |shots|
      Frame.new(shots[0], shots[1], shots[2])
    end
  end

  def calc_score
    bonus_added_scores = set_frames.map do |frame|
      [frame.score, bonus_score(frame)].sum
    end
    bonus_added_scores.sum
  end

  def scores_output
    puts calc_score
  end

  def bonus_score(frame)
    current_frame_index = @frames.index(frame)

    return 0 unless frame.strike? || frame.spare?
    return 0 if current_frame_index == 9

    if frame.strike?
      strike_bonus(current_frame_index)
    elsif frame.spare?
      @frames[current_frame_index + 1].first_shot.score
    end
  end

  def strike_bonus(current_frame_index)
    if @frames[current_frame_index + 1].strike? && current_frame_index < 8
      @frames[current_frame_index + 1].first_shot.score + @frames[current_frame_index + 1 + 1].first_shot.score
    else
      @frames[current_frame_index + 1].first_shot.score + @frames[current_frame_index + 1].second_shot.score
    end
  end
end
