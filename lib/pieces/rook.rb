# frozen_string_literal: false

class Rook
  attr_reader :symbol, :possible_moves, :color, :starting_location
  attr_accessor :current_location, :has_moved

  def initialize(color, location)
    @color = color
    # @symbol = "#{color[0].upcase}R" # uncomment line to use with WSL
    @symbol = (color == :black ? "\u2656" : "\u265C") # comment line to use with WSL
    @current_location = location
    @starting_location = location
    @possible_moves = [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                      [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                      [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
                      [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]
    @has_moved = false
  end
end