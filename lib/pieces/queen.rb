# frozen_string_literal: false

class Queen # < ChessPiece
  attr_reader :symbol, :possible_moves, :color
  attr_accessor :current_location

  def initialize(color, location)
    # super(location)
    @color = color
    # @symbol = "#{color[0].upcase}Q" # uncomment line to use with WSL
    @symbol = (color == :black ? "\u2655" : "\u265B") # comment line to use with WSL
    @current_location = location
    @possible_moves = [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
                      [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
                      [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                      [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
                      [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                      [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                      [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
                      [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]
  end
end