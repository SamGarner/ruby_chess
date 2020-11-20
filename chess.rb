# frozen_string_literal: false

require 'pry'

# display board (.each with .each to print [0][0] through [7][7]?)
# figure out king with unicode piece
# check/make board display with King pieces on all the piece squares
# dive into piece specifics/other pieces

# Board
class Board
  attr_accessor :board_array

  def initialize
    @board_array = Array.new(8) { Array.new(8) { '__' } }
  end

  def display_board
    puts '   | A  | B  | C  | D  | E  | F  | G  | H  |'
    puts display_rows
    puts '   | A  | B  | C  | D  | E  | F  | G  | H  |'
  end

  def display_rows
    text = ""
    (0..7).each do |n|
      text << "#{n + 1}  |"
      board_array[n].each do |space|
        text << " #{space} |"
      end
      text << " #{n + 1}\n"
    end
    text
  end
end

# class ChessPiece
#   attr_accessor :current_location

#   def inititalize(location)
#     # @color = color
#     @current_location = location
#   end
# end

# King
class King #s < Piece
  attr_reader :symbol

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}K"
    @current_location = location
    # @possible_moves

    # U+2654 White Chess King
    # U+265A Black Chess King
  end
end

class Queen # < ChessPiece
  attr_reader :symbol

  def initialize(color, location)
    # super(location)
    @color = color
    @symbol = "#{color[0].upcase}Q"
    @current_location = location
  end
end

class Bishop
  attr_reader :symbol

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}B"
    @current_location = location
  end
end

class Knight
  attr_reader :symbol

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}k"
    @current_location = location
  end
end

class Rook
  attr_reader :symbol

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}R"
    @current_location = location
  end
end

class Pawn
  attr_reader :symbol

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}p"
    @current_location = location
  end
end

# Game
class Game

  attr_reader :white_king, :black_king, :black_queen, :white_queen, \
              :black_bishop_c, :black_bishop_f, :white_bishop_c, :white_bishop_f, \
              :black_knight_b, :black_knight_g, :white_knight_b, :white_knight_g, \
              :black_rook_a, :black_rook_h, :white_rook_a, :white_rook_h, \
              :black_pawn_a, :black_pawn_b, :black_pawn_c, :black_pawn_d, \
              :black_pawn_e, :black_pawn_f, :black_pawn_g, :black_pawn_h, \
              :white_pawn_a, :white_pawn_b, :white_pawn_c, :white_pawn_d, \
              :white_pawn_e, :white_pawn_f, :white_pawn_g, :white_pawn_h
  attr_accessor :gameboard

  def initialize(board)
    @gameboard = board
  end

  def initialize_pieces
    initialize_kings
    initialize_queens
    initialize_bishops
    initialize_knights
    initialize_rooks
    initialize_black_pawns
    initialize_white_pawns
  end

  def initialize_kings
    @black_king = King.new('black', [0, 4])
    @white_king = King.new('white', [7, 4])
  end

  def initialize_queens
    @black_queen = Queen.new('black', [0, 3])
    @white_queen = Queen.new('white', [7, 3])
  end

  def initialize_bishops
    @black_bishop_c = Bishop.new('black', [0, 2])
    @black_bishop_f = Bishop.new('black', [0, 5])
    @white_bishop_c = Bishop.new('white', [7, 2])
    @white_bishop_f = Bishop.new('white', [7, 5])
  end

  def initialize_knights
    @black_knight_b = Knight.new('black', [0, 1])
    @black_knight_g = Knight.new('black', [0, 6])
    @white_knight_b = Knight.new('white', [7, 1])
    @white_knight_g = Knight.new('white', [7, 6])
  end

  def initialize_rooks
    @black_rook_a = Rook.new('black', [0, 0])
    @black_rook_h = Rook.new('black', [0, 7])
    @white_rook_a = Rook.new('white', [7, 0])
    @white_rook_h = Rook.new('white', [7, 7])
  end

  def initialize_black_pawns
    @black_pawn_a = Pawn.new('black', [1, 0])
    @black_pawn_b = Pawn.new('black', [1, 1])
    @black_pawn_c = Pawn.new('black', [1, 2])
    @black_pawn_d = Pawn.new('black', [1, 3])
    @black_pawn_e = Pawn.new('black', [1, 4])
    @black_pawn_f = Pawn.new('black', [1, 5])
    @black_pawn_g = Pawn.new('black', [1, 6])
    @black_pawn_h = Pawn.new('black', [1, 7])
  end

  def initialize_white_pawns
    @white_pawn_a = Pawn.new('white', [6, 0])
    @white_pawn_b = Pawn.new('white', [6, 1])
    @white_pawn_c = Pawn.new('white', [6, 2])
    @white_pawn_d = Pawn.new('white', [6, 3])
    @white_pawn_e = Pawn.new('white', [6, 4])
    @white_pawn_f = Pawn.new('white', [6, 5])
    @white_pawn_g = Pawn.new('white', [6, 6])
    @white_pawn_h = Pawn.new('white', [6, 7])
  end

  def place_starting_pieces(board = gameboard.board_array)  # module?
    starting_kings(board)
    starting_queens(board)
    starting_bishops(board)
    starting_knights(board)
    starting_rooks(board)
    starting_pawns_black(board)
    starting_pawns_white(board)
  end

  def starting_kings(board)
    board[0][4] = black_king.symbol
    board[7][4] = white_king.symbol
  end

  def starting_queens(board)
    board[0][3] = black_queen.symbol
    board[7][3] = white_queen.symbol
  end

  def starting_bishops(board)
    board[0][2] = black_bishop_c.symbol
    board[0][5] = black_bishop_f.symbol
    board[7][2] = white_bishop_c.symbol
    board[7][5] = white_bishop_f.symbol
  end

  def starting_knights(board)
    board[0][1] = black_knight_b.symbol
    board[0][6] = black_knight_g.symbol
    board[7][1] = white_knight_b.symbol
    board[7][6] = white_knight_g.symbol
  end

  def starting_rooks(board)
    board[0][0] = black_rook_a.symbol
    board[0][7] = black_rook_h.symbol
    board[7][0] = white_rook_a.symbol
    board[7][7] = white_rook_h.symbol
  end

  def starting_pawns_black(board)
    (0..7).each { |space| board[1][space] = 'Bp' }
  end

  def starting_pawns_white(board)
    (0..7).each { |space| board[6][space] = 'Wp' }
  end
end

board = Board.new
game = Game.new(board)
game.initialize_pieces
game.place_starting_pieces
binding.pry

# king = King.new
