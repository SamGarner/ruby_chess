# frozen_string_literal: false

require 'pry'
require_relative 'pieces/king.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/white_pawn.rb'
require_relative 'pieces/black_pawn.rb'
require_relative 'in_check_conditions.rb'

# Board
class Board
  include InCheckConditions

  attr_reader :mapping_hash
  attr_accessor :board_array

  def initialize
    @board_array = Array.new(8) { Array.new(8) { '__' } }
    @mapping_hash = Hash[A1: [7, 0], A2: [6, 0], A3: [5, 0], A4: [4, 0],
                         A5: [3, 0], A6: [2, 0], A7: [1, 0], A8: [0, 0],
                         B1: [7, 1], B2: [6, 1], B3: [5, 1], B4: [4, 1],
                         B5: [3, 1], B6: [2, 1], B7: [1, 1], B8: [0, 1],
                         C1: [7, 2], C2: [6, 2], C3: [5, 2], C4: [4, 2],
                         C5: [3, 2], C6: [2, 2], C7: [1, 2], C8: [0, 2],
                         D1: [7, 3], D2: [6, 3], D3: [5, 3], D4: [4, 3],
                         D5: [3, 3], D6: [2, 3], D7: [1, 3], D8: [0, 3],
                         E1: [7, 4], E2: [6, 4], E3: [5, 4], E4: [4, 4],
                         E5: [3, 4], E6: [2, 4], E7: [1, 4], E8: [0, 4],
                         F1: [7, 5], F2: [6, 5], F3: [5, 5], F4: [4, 5],
                         F5: [3, 5], F6: [2, 5], F7: [1, 5], F8: [0, 5],
                         G1: [7, 6], G2: [6, 6], G3: [5, 6], G4: [4, 6],
                         G5: [3, 6], G6: [2, 6], G7: [1, 6], G8: [0, 6],
                         H1: [7, 7], H2: [6, 7], H3: [5, 7], H4: [4, 7],
                         H5: [3, 7], H6: [2, 7], H7: [1, 7], H8: [0, 7]
                       ]
  end

  def place_starting_pieces
    place_starting_kings
    place_starting_queens
    place_starting_bishops
    place_starting_knights
    place_starting_rooks
    place_starting_white_pawns
    place_starting_black_pawns
  end

  def display_board
    puts '   | A  | B  | C  | D  | E  | F  | G  | H  |'
    puts display_rows
    puts '   | A  | B  | C  | D  | E  | F  | G  | H  |'
  end

  def display_rows
    text = ''
    (0..7).each do |n|
      text << "#{8 - n}  |"
      board_array[n].each do |space|
        text << display_piece(space)
      end
      text << " #{8 - n}\n"
    end
    text
  end

  def display_piece(space)
    if space == '__'
      " #{space} |"
    else
      " #{space.symbol} |"
    end
  end

  def piece_exists?(coordinates)
    board_array[coordinates[0]][coordinates[1]].class != String
  end

  # def color_match?(piece, coordinates)
  #   board_array[coordinates[0]][coordinates[1]].color == piece.color
  # end

  def attacking_opponent?(piece, desired_space)
    piece.color != board_array[desired_space[0]][desired_space[1]].color
  end

  def update_board(piece, desired_space)
    ds = desired_space
    old_space = piece.current_location
    board_array[ds[0]][ds[1]] = piece
    board_array[old_space[0]][old_space[1]] = '__'
  end

  def add_new_promoted_piece_to_board(end_space, new_promoted_piece)
    board_array[end_space[0]][end_space[1]] = new_promoted_piece
  end

  def destroy_enemy(desired_space)
    attacked_piece = board_array[desired_space[0]][desired_space[1]]
    attacked_piece.current_location = nil
    board_array[desired_space[0]][desired_space[1]] = '__'
  end

  private

  def place_starting_kings
    board_array[0][4] = King.new(:black, [0, 4])
    board_array[7][4] = King.new(:white, [7, 4])
  end

  def place_starting_queens
    board_array[0][3] = Queen.new(:black, [0, 3])
    board_array[7][3] = Queen.new(:white, [7, 3])
  end

  def place_starting_bishops
    board_array[0][2] = Bishop.new(:black, [0, 2])
    board_array[0][5] = Bishop.new(:black, [0, 5])
    board_array[7][2] = Bishop.new(:white, [7, 2])
    board_array[7][5] = Bishop.new(:white, [7, 5])
  end

  def place_starting_knights
    board_array[0][1] = Knight.new(:black, [0, 1])
    board_array[0][6] = Knight.new(:black, [0, 6])
    board_array[7][1] = Knight.new(:white, [7, 1])
    board_array[7][6] = Knight.new(:white, [7, 6])
  end

  def place_starting_rooks
    board_array[0][0] = Rook.new(:black, [0, 0])
    board_array[0][7] = Rook.new(:black, [0, 7])
    board_array[7][0] = Rook.new(:white, [7, 0])
    board_array[7][7] = Rook.new(:white, [7, 7])
  end

  def place_starting_black_pawns
    board_array[1][0] = BlackPawn.new([1, 0])
    board_array[1][1] = BlackPawn.new([1, 1])
    board_array[1][2] = BlackPawn.new([1, 2])
    board_array[1][3] = BlackPawn.new([1, 3])
    board_array[1][4] = BlackPawn.new([1, 4])
    board_array[1][5] = BlackPawn.new([1, 5])
    board_array[1][6] = BlackPawn.new([1, 6])
    board_array[1][7] = BlackPawn.new([1, 7])
  end

  def place_starting_white_pawns
    board_array[6][0] = WhitePawn.new([6, 0])
    board_array[6][1] = WhitePawn.new([6, 1])
    board_array[6][2] = WhitePawn.new([6, 2])
    board_array[6][3] = WhitePawn.new([6, 3])
    board_array[6][4] = WhitePawn.new([6, 4])
    board_array[6][5] = WhitePawn.new([6, 5])
    board_array[6][6] = WhitePawn.new([6, 6])
    board_array[6][7] = WhitePawn.new([6, 7])
  end
end
