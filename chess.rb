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

class WhitePawn
  attr_reader :symbol, :color, :starting_location, :capture_moves
  attr_accessor :current_location, :possible_moves, :initial_turn

  def initialize(location)
    @color = 'white'
    @symbol = 'Wp' # "#{color[0].upcase}p"
    @current_location = location
    @starting_location = location
    @possible_moves = [0, 1], [0, 2]
    @capture_moves = [-1, 1], [1, 1]
    @initial_turn = 0
  end

  def makes_first_move(ending_space, move_number)
    self.possible_moves = [0, 1]
    self.initial_turn = move_number if starting_location[0] - ending_space[0] == 2
    # game.passant_vulnerable?(starting_space, ending_space)
  end

  # def passant_vulnerable?(starting_space, ending_space)
  #   (starting_space[1] - ending_space[1]).abs == 2
  # end
end

class BlackPawn
  attr_reader :symbol, :color, :starting_location, :capture_moves
  attr_accessor :current_location, :possible_moves, :initial_turn

  def initialize(location)
    @color = 'black'
    @symbol = 'Bp' # "#{color[0].upcase}p"
    @current_location = location
    @starting_location = location
    @possible_moves = [0, -1], [0, -2]
    @capture_moves = [-1, -1], [1, -1]
    @initial_turn = 0
  end

  def makes_first_move(ending_space, move_number)    
    self.possible_moves = [0, -1]
    self.initial_turn = move_number if starting_location[0] - ending_space[0] == -2
  end

  # def passant_vulnerable?(starting_space, ending_space)
  #   (starting_space[1] - ending_space[1]).abs == 2
  # end
end

# Game
class Game

  attr_reader :white_king, :black_king, :black_queen, :white_queen,
              :black_bishop_c, :black_bishop_f, :white_bishop_c, :white_bishop_f,
              :black_knight_b, :black_knight_g, :white_knight_b, :white_knight_g, 
              :black_rook_a, :black_rook_h, :white_rook_a, :white_rook_h, 
              :black_pawn_a, :black_pawn_b, :black_pawn_c, :black_pawn_d, 
              :black_pawn_e, :black_pawn_f, :black_pawn_g, :black_pawn_h, 
              :white_pawn_a, :white_pawn_b, :white_pawn_c, :white_pawn_d, 
              :white_pawn_e, :white_pawn_f, :white_pawn_g, :white_pawn_h,
              :start_input, :finish_input, :valid_input, :piece_type, :start, 
              :finish
  attr_accessor :gameboard, :turn, :total_turn_counter, :travel_path #travel_path to reader?

  def initialize(board)
    @gameboard = board
    @turn = 'white'
    @total_turn_counter = 0
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
    @black_pawn_a = BlackPawn.new([1, 0])
    @black_pawn_b = BlackPawn.new([1, 1])
    @black_pawn_c = BlackPawn.new([1, 2])
    @black_pawn_d = BlackPawn.new([1, 3])
    @black_pawn_e = BlackPawn.new([1, 4])
    @black_pawn_f = BlackPawn.new([1, 5])
    @black_pawn_g = BlackPawn.new([1, 6])
    @black_pawn_h = BlackPawn.new([1, 7])
  end

  def initialize_white_pawns
    @white_pawn_a = WhitePawn.new([6, 0])
    @white_pawn_b = WhitePawn.new([6, 1])
    @white_pawn_c = WhitePawn.new([6, 2])
    @white_pawn_d = WhitePawn.new([6, 3])
    @white_pawn_e = WhitePawn.new([6, 4])
    @white_pawn_f = WhitePawn.new([6, 5])
    @white_pawn_g = WhitePawn.new([6, 6])
    @white_pawn_h = WhitePawn.new([6, 7])
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
    gameboard.mapping_hash.key?(space.to_sym)
  end

  def valid_piece_to_move?(starting_space, player_color = turn)
    space = gameboard.board_array[starting_space[0]][starting_space[1]]
    space != '__' && space.color == player_color
  end

  def valid_target_space?(target_space, player_color = turn)
    space = gameboard.board_array[target_space[0]][target_space[1]]
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
    @start = gameboard.mapping_hash.fetch(start.to_sym)
    # error handling here or outside ?
    @finish = gameboard.mapping_hash.fetch(finish.to_sym)
  end

  def take_turn # WIP
    while true
      choose_move
      display_to_array_map
      # piece = identify_piece()
      break if commit_move?(identify_piece(), finish)
      puts 'Illegal move. Please try again.'
    end
    move_piece(identify_piece(), finish)
    # pawn handling
    total_turn_counter += 1
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

    # destroy_enemy(desired_space) if desired_space_occupied?(desired_space) && attacking_opponent?(piece, desired_space)
    # white_pawn_has_moved(piece, desired_space) if piece.class == WhitePawn
    first_move_for_white_pawn(piece, desired_space) if piece.class == WhitePawn &&
                                        piece.current_location == piece.starting_location
    capture_opponent(piece, desired_space)
    update_board(piece, desired_space)
    piece.current_location = desired_space
  end

  def capture_opponent(piece, desired_space)
    if piece.class == WhitePawn && piece.capture_moves.include?(travel_path)
      white_pawn_captures(piece, desired_space)
    elsif desired_space_occupied?(desired_space) && attacking_opponent?(piece, desired_space)
      destroy_enemy(desired_space)
    end
  end

  def first_move_for_white_pawn(piece, desired_space)
    piece.makes_first_move(desired_space, total_turn_counter)
  end

  def white_pawn_captures(piece, desired_space)
    if desired_space_occupied?(desired_space) && attacking_opponent?(piece, desired_space)
      destroy_enemy(desired_space)
    elsif white_can_en_passant?(piece, desired_space)
      destroy_enemy([desired_space[0], desired_space[1] + 1])
    end
  end

  # def passant_vulnerable?(starting_space, ending_space)
  #   (starting_space[1] - ending_space[1]).abs == 2
  # end

  def commit_move?(piece, desired_space)
    @travel_path = [] # think regular x,y coordinates
    travel_path[0] = desired_space[1] - piece.current_location[1] # horizontal plane
    travel_path[1] = piece.current_location[0] - desired_space[0] # vertical plane
    # e.g rook travel path, 7,7 --> 5, 7 = [-2, 0]
      # pawn [6,7] > [5,7]
      # tp[0] = 7 - 7
      # tp[1] = 6 - 5
      # tp = [0, 1]
    valid_move?(piece, travel_path, desired_space)
  end

  def possible_move?(piece, travel_path) # direction possible for type of piece
    piece.possible_moves.include?(travel_path)
  end

  def valid_move?(piece, travel_path, desired_space)
    case piece.class
    when Knight
      return possible_move?(piece, travel_path) # if piece.class = Knight
    when WhitePawn
      return valid_white_pawn_move?(piece, travel_path, desired_space) # if piece.class = WhitePawn
    else
      possible_move?(piece, travel_path) && !impeding_piece?(piece, travel_path)
    end
  end

  def valid_white_pawn_move?(piece, travel_path, desired_space)
    # refactor into white and black
    # split white and black pawns into separate classes?
    
    # answer = nil
    if piece.possible_moves.include?(travel_path)
      answer =  true if !desired_space_occupied?(desired_space) && !impeding_piece?(piece, travel_path)
    elsif piece.capture_moves.include?(travel_path)
      answer =  true if desired_space_occupied?(desired_space) && attacking_opponent?(piece, desired_space)
      answer =  true if white_can_en_passant?(piece, desired_space)
    else
      answer = false
    end
    answer
  end

  def white_can_en_passant?(piece, desired_space, board_array = gameboard.board_array)
    # desired space is empty...redundant if can only happen on next turn
    # travel_path in capture_moves...redundant from valid_white_pawn_move?
    piece_attacked = board_array[desired_space[0] + 1][desired_space[1]]
    piece_attacked.class == BlackPawn && (total_turn_counter - piece_attacked.initial_turn == 1)
  end

  def pawn_initial_move?(piece)
    piece.current_location == piece.starting_location
  end
  # def valid_knight_move?(piece, travel_path)
  #   possible_move?(piece, travel_path)
  # end

  def impeding_piece?(piece, travel_path)
    horizontal_impediment?(piece, travel_path) #|| vertical_impediment? || diag_impediment?
  end

  def horizontal_impediment?(piece, travel_path, board = gameboard.board_array)
    space_check = piece.current_location[0]
    vertical_coord = piece.current_location[1]
    if travel_path[0].positive?
      (travel_path[0] - 1).times do
        space_check += 1
        return true if piece_exists?(vertical_coord, space_check)
      end
      space_check += 1 
    else
      (travel_path[0].abs() - 1).times do
      # (-1 * travel_path[0]).times do
        space_check -= 1
        return true if piece_exists?(vertical_coord, space_check)
      end
      space_check -= 1
    end
    return true if piece_exists?(vertical_coord, space_check) && 
        color_match?(piece, vertical_coord, space_check)

    false
  end

  def piece_exists?(vertical_coord, horizontal_coord, board = gameboard.board_array)
    board[vertical_coord][horizontal_coord].class != String
  end
  
  def color_match?(piece, vertical_coord, horizontal_coord, board = gameboard.board_array)
    board[vertical_coord][horizontal_coord].color == piece.color
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
