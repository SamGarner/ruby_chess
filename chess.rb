# frozen_string_literal: false

require 'pry'

# display board (.each with .each to print [0][0] through [7][7]?)
# figure out king with unicode piece
# check/make board display with King pieces on all the piece squares
# dive into piece specifics/other pieces

# Board
class Board
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

  def display_board
    puts '   | A  | B  | C  | D  | E  | F  | G  | H  |'
    puts display_rows
    puts '   | A  | B  | C  | D  | E  | F  | G  | H  |'
  end

  def display_rows
    text = ''
    (0..7).each do |n|
      text << "#{n + 1}  |"
      board_array[n].each do |space|
        text << display_piece(space)
      end
      text << " #{n + 1}\n"
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
  attr_reader :symbol, :possible_moves
  attr_accessor :current_location

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}K"
    @current_location = location
    @possible_moves = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1],
                       [-1, 0], [-1, 1]]

    # U+2654 White Chess King
    # U+265A Black Chess King
  end
end

class Queen # < ChessPiece
  attr_reader :symbol, :possible_moves
  attr_accessor :current_location

  def initialize(color, location)
    # super(location)
    @color = color
    @symbol = "#{color[0].upcase}Q"
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

class Bishop
  attr_reader :symbol, :possible_moves
  attr_accessor :current_location

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}B"
    @current_location = location
    @possible_moves = [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
                      [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
                      [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                      [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]
    # share with Queen ?
  end
end

class Knight
  attr_reader :symbol, :possible_moves
  attr_accessor :current_location

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}k"
    @current_location = location
    @possible_moves = [1, 2], [2, 1], [1, -2], [2, -1], [-1, -2], [-2, -1],
                      [-1, 2], [-2, 1]
  end
end

class Rook
  attr_reader :symbol, :possible_moves, :color
  attr_accessor :current_location

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}R"
    @current_location = location
    @possible_moves = [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                      [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                      [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
                      [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]
  end
end

class Pawn
  attr_reader :symbol, :possible_moves, :color
  attr_accessor :current_location

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}p"
    @current_location = location
    # possible_moves does not include en passant, 2 square start, or diagonal capture
    @possible_moves = [0, 1]
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
              :white_pawn_e, :white_pawn_f, :white_pawn_g, :white_pawn_h,
              :start_input, :finish_input, :valid_input, :piece_type
  attr_accessor :gameboard, :turn

  def initialize(board)
    @gameboard = board
    @turn = 'white'
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
    board[0][4] = black_king
    board[7][4] = white_king
  end

  def starting_queens(board)
    board[0][3] = black_queen
    board[7][3] = white_queen
  end

  def starting_bishops(board)
    board[0][2] = black_bishop_c
    board[0][5] = black_bishop_f
    board[7][2] = white_bishop_c
    board[7][5] = white_bishop_f
  end

  def starting_knights(board)
    board[0][1] = black_knight_b
    board[0][6] = black_knight_g
    board[7][1] = white_knight_b
    board[7][6] = white_knight_g
  end

  def starting_rooks(board)
    board[0][0] = black_rook_a
    board[0][7] = black_rook_h
    board[7][0] = white_rook_a
    board[7][7] = white_rook_h
  end

  def starting_pawns_black(board)
    # (0..7).each { |space| board[1][space] = 'Bp' }
    board[1][0] = black_pawn_a
    board[1][1] = black_pawn_b
    board[1][2] = black_pawn_c
    board[1][3] = black_pawn_d
    board[1][4] = black_pawn_e
    board[1][5] = black_pawn_f
    board[1][6] = black_pawn_g
    board[1][7] = black_pawn_h
  end

  def starting_pawns_white(board)
    # (0..7).each { |space| board[6][space] = 'Wp' }
    board[6][0] = white_pawn_a
    board[6][1] = white_pawn_b
    board[6][2] = white_pawn_c
    board[6][3] = white_pawn_d
    board[6][4] = white_pawn_e
    board[6][5] = white_pawn_f
    board[6][6] = white_pawn_g
    board[6][7] = white_pawn_h
  end

  def choose_move
    #update to be player specific
    choose_piece_to_move
    # get the name type of the piece to output to the user (e.g. '..move your rook?')
    which_piece_selected
    choose_where_to_move
  end

  def choose_piece_to_move
    puts "#{turn.capitalize}'s turn."
    puts 'Enter the space of the piece you want to move (e.g. a1 or H3):'
    @start_input = gets.chomp.upcase
    if !valid_start_input?(start_input)
      puts 'Invalid piece. Please try again.'
      choose_piece_to_move
    end
  end

  def choose_where_to_move
    puts "Where would you like to move your #{piece_type}?"
    @finish_input = gets.chomp.upcase
    if !valid_finish_input?(finish_input)
      puts 'Invalid space. Please try again.'
      choose_where_to_move
    end
  end

  def valid_finish_input?(finish = finish_input)
    valid_user_input?(finish) && valid_target_space?(finish)
  end

  def valid_start_input?(start = start_input)
    valid_user_input?(start) && valid_piece_to_move?(start)
  end

  def valid_user_input?(space)
    board.mapping_hash.key?(space)
  end

  def valid_piece_to_move?(starting_space, player_color = turn)
    board.board_array[starting_space[0]][starting_space[1]].color == player_color
  end

  def valid_target_space?(target_space, player_color = turn)
    space = board.board_array[starting_space[0]][starting_space[1]]
    return true if space == '__'

    space.color != player_color
  end

  def which_piece_selected(starting_space = self.start_input)
    space = board.board_array[starting_space[0]][starting_space[1]]
    @piece_type = space.class
  end

  # def populate_valid_input_array
  #   @valid_input = []
  #   ('A'..'H').each do |l|
  #     (1..8).each do |n|
  #       @valid_input << (l + n.to_s)
  #     end
  #   end
  # end

  def display_to_array_map(start = start_input, finish = finish_input)
    # include in take_turn or in choose_move ?
    @start = board.mapping_hash.fetch_values(start.to_sym)
    # error handling here or outside ?
    @finish = board.mapping_hash.fetch_values(finish.to_sym)
  end

  def take_turn # WIP
    loop
      choose_move
      display_to_array_map
      # piece = identify_piece()
      break if commit_move?(identify_piece(), finish)
    end
    move_piece(identify_piece(), finish)
    switch_turn_to_opponent
      # loop if invalid input
  end

  def switch_turn_to_opponent
    turn == 'white' ? turn = 'black' : turn = 'white'
  end

  def identify_piece(starting_space = start)
    board.board_array[starting_space[0]][starting_space[1]]
  end

  def move_piece(piece, desired_space) # move to ChessPiece SuperClass once 'working'
    # # desired space (non-converted) example: [6, 4] - white king move forward one
    # travel_path = []
    # travel_path[0] = desired_space[1] - piece.current_location[1] # horizontal plane
    # travel_path[1] = piece.current_location[0] - desired_space[0] # vertical plane
    # # e.g rook travel path, 7,7 --> 5, 7 = [-2, 0]
    # return unless valid_move?(piece, travel_path)
    destroy_enemy(desired_space) if desired_space_occupied?(desired_space) && attacking_opponent?(piece, desired_space)
    update_board(piece, desired_space)
    piece.current_location = desired_space
  end

  def commit_move?(piece, desired_space)
    travel_path = []
    travel_path[0] = desired_space[1] - piece.current_location[1] # horizontal plane
    travel_path[1] = piece.current_location[0] - desired_space[0] # vertical plane
    # e.g rook travel path, 7,7 --> 5, 7 = [-2, 0]
    valid_move?(piece, travel_path)
  end

  def possible_move?(piece, travel_path) # direction possible for type of piece
    piece.possible_moves.include?(travel_path)
  end

  def valid_move?(piece, travel_path)
    possible_move?(piece, travel_path) && !impeding_piece?(piece, travel_path)
  end

  def impeding_piece?(piece, travel_path)
    horizontal_impediment?(piece, travel_path) #|| vertical_impediment? || diag_impediment?
  end

  def horizontal_impediment?(piece, travel_path, board = gameboard.board_array)
    space_check = piece.current_location[0]
    vertical_coord = piece.current_location[1]
    if travel_path[0].positive?
      travel_path[0].times do
        space_check += 1
        return true if board[vertical_coord][space_check].class != String
      end
    else
      # (travel_path[0].abs()).times
      (-1 * travel_path[0]).times do
        space_check -= 1
        return true if board[vertical_coord][space_check].class != String
      end
    end
    false
  end

  def update_board(piece, desired_space, board = gameboard.board_array)
    ds = desired_space
    old_space = piece.current_location
    board[ds[0]][ds[1]] = piece
    board[old_space[0]][old_space[1]] = '__'
  end

  def desired_space_occupied?(desired_space, board = gameboard.board_array)
    board[desired_space[0]][desired_space[1]].class != String
  end

  def attacking_opponent?(piece, desired_space) # update after test to include board default
    piece.color != gameboard.board_array[desired_space[0]][desired_space[1]].color
  end

  def destroy_enemy(desired_space, board = gameboard.board_array)
    attacked_piece = board[desired_space[0]][desired_space[1]]
    attacked_piece.current_location = nil
  end
end

# board = Board.new
# game = Game.new(board)
# game.initialize_pieces
# game.place_starting_pieces
# game.gameboard.display_board
# binding.pry

# king = King.new
