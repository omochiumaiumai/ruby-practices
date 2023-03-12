# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(mark)
    @mark = mark
  end

  def split_marks
    @mark.split(',')
  end

  def slice_marks
    marks = []
    frames = []

    split_marks.each do |mark|
      marks << mark
      frame_size = marks.size / 2
      marks << '0' if frame_size < 9 && mark == 'X'
    end

    marks.each_slice(2) { |mark| frames << mark }

    if frames.size > 10
      frames[9].concat(frames.last)
      frames.delete(frames.last)
    end
    frames
  end

  def frame_array
    slice_marks.map do |shot|
      Frame.new(shot[0], shot[1], shot[2])
    end
  end

  def calc_score
    @frames = frame_array
    scores = []
    @frames.each do |frame|
      current_frame = @frames.index(frame)
      scores << if frame.strike? && current_frame < 9
                       frame.score + bonus_score(frame)
                     elsif frame.spare? && current_frame < 9
                       frame.score + bonus_score(frame)
                     else
                       frame.score
                     end
    end
    puts scores.sum
  end

  def bonus_score(frame)
    current_frame_index = @frames.index(frame)
    if frame.strike?
      if @frames[current_frame_index + 1].strike? && current_frame_index < 8
        @frames[current_frame_index + 1].first_shot.score + @frames[current_frame_index + 1 + 1].first_shot.score
      else
        @frames[current_frame_index + 1].first_shot.score + @frames[current_frame_index + 1].second_shot.score
      end
    else
      @frames[current_frame_index + 1].first_shot.score
    end
  end
end
