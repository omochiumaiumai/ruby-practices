# frozen_string_literal: true

require_relative 'game'

scores_text = ARGV[0]
Game.new(scores_text).scores_output
