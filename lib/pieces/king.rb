# frozen_string_literal: false

# King
class King #s < Piece
  attr_reader :symbol, :possible_moves, :color, :starting_location, :castling_moves
  attr_accessor :current_location, :in_check, :has_moved

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}K"
    @current_location = location
    @starting_location = location
    @possible_moves = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1],
                       [-1, 0], [-1, 1]]
    @castling_moves = [[-2, 0], [2, 0]]
    @in_check = false
    @has_moved = false
    # U+2654 White Chess King
    # U+265A Black Chess King
  end
end