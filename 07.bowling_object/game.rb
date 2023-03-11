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
    marks_array = []
    frames = []

    split_marks.each do |mark|
      marks_array << mark
      frame = marks_array.size / 2
      marks_array << '0' if frame < 9 && mark == 'X'
    end

    marks_array.each_slice(2) { |mark| frames << mark }

    if frames.size > 10
      frames[9].concat(frames.last)
      frames.delete(frames.last)
    end
    frames
  end

  def frame_array
    frames = slice_marks
    frames.map do |shot|
      Frame.new(shot[0], shot[1], shot[2])
    end
  end

  def calc_score
    @frames = frame_array
    total_score = []
    @frames.each do |frame|
      current_frame = @frames.index(frame)
      total_score << if frame.strike? && current_frame < 9
                       frame.score + bonus_score(@frames, frame)
                     elsif frame.spare? && current_frame < 9
                       frame.score + bonus_score(@frames, frame)
                     else
                       frame.score
                     end
    end
    puts total_score.sum
  end

  def bonus_score(frames, frame)
    current_frame_index = frames.index(frame)
    next_frame_index = frames.index(frame) + 1
    if frame.strike?
      if frames[next_frame_index].strike? && current_frame_index < 8
        frames[next_frame_index].first_shot.score + frames[next_frame_index + 1].first_shot.score
      else
        frames[next_frame_index].first_shot.score + frames[next_frame_index].second_shot.score
      end
    else
      frames[next_frame_index].first_shot.score
    end
  end
end
