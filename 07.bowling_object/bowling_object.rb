# frozen_string_literal: true

require_relative 'game'

input = ARGV[0]
Game.new(input).calc_score
