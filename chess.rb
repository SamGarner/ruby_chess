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

class Queen # < ChessPiece
  attr_reader :symbol, :possible_moves, :color
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
  attr_reader :symbol, :possible_moves, :color
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
  attr_reader :symbol, :possible_moves, :color
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
  attr_reader :symbol, :possible_moves, :color, :starting_location
  attr_accessor :current_location, :has_moved

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}R"
    @current_location = location
    @starting_location = location
    @possible_moves = [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                      [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                      [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
                      [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]
    @has_moved = false
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
    self.possible_moves = [[0, 1]]
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
    self.possible_moves = [[0, -1]]
    self.initial_turn = move_number if starting_location[0] - ending_space[0] == -2
  end

  # def passant_vulnerable?(starting_space, ending_space)
  #   (starting_space[1] - ending_space[1]).abs == 2
  # end
end

# Game
class Game

  attr_reader :black_queen, :white_queen, :white_king, :black_king,
              :black_bishop_c, :black_bishop_f, :white_bishop_c, :white_bishop_f,
              :black_knight_b, :black_knight_g, :white_knight_b, :white_knight_g,
              :black_rook_a, :black_rook_h, :white_rook_a, :white_rook_h,
              :black_pawn_a, :black_pawn_b, :black_pawn_c, :black_pawn_d,
              :black_pawn_e, :black_pawn_f, :black_pawn_g, :black_pawn_h,
              :white_pawn_a, :white_pawn_b, :white_pawn_c, :white_pawn_d,
              :white_pawn_e, :white_pawn_f, :white_pawn_g, :white_pawn_h,
              # :start_input, :finish_input,
              :valid_input, :piece_type, :start,
              :finish, :start_space, :end_space, :winner,
              :enemy_king, :friendly_king
  attr_accessor :gameboard, :turn, :total_turn_counter, :travel_path, #travel_path to reader?
                :start_input, :finish_input, :game_over, :checkmate
                # :white_king, :black_king
                # move :start_input and :finish input to attr_reader after redo testing setup

  def initialize(board)
    @gameboard = board
    @turn = 'white'
    @total_turn_counter = 0
    @game_over = false
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
    choose_move_when_in_check
    #update to be player specific
    choose_piece_to_move
    which_piece_selected
    choose_where_to_move
  end

  def choose_move_when_in_check
    # turn == 'white' ? friendly_king = @white_king : friendly_king = @black_king
    fetch_friendly_king
    resign = checkmate? if friendly_king.in_check
    end_game if resign
  end

  def checkmate?
    puts "\nYou are in check. Do you resign y/n?\n"
    @checkmate = gets.chomp.downcase
    turn == 'white' ? @winner = 'black' : @winner = 'White'
    return true if checkmate == 'y'
    false
  end

  def end_game
    self.game_over = true
    if checkmate != 'y' 
      puts "It's a draw. Good game!"
    else
      puts "\n#{winner} wins !\n"
    end
  end

  def choose_piece_to_move
    puts "#{turn.capitalize}'s turn."
    puts 'Enter the space of the piece you want to move (e.g. a1 or H3):'
    @start_input = gets.chomp.upcase
    unless valid_user_input?(start_input) && valid_piece_to_move?

    # if !valid_start_input?(start_input)
      puts 'Invalid piece. Please try again.'
      choose_piece_to_move
    end
  end

  def choose_where_to_move
    puts "Where would you like to move your #{piece_type}?"
    @finish_input = gets.chomp.upcase
    unless valid_user_input?(finish_input) && valid_target_space?

    # if !valid_finish_input?(finish_input)
      puts 'Invalid space. Please try again.'
      choose_move
    end
  end

  # def display_to_array_map(start = start_input, finish = finish_input)
  #   # # include in take_turn or in choose_move ?
  #   # @start = gameboard.mapping_hash.fetch(start.to_sym)
  #   # # error handling here or outside ?
  #   # @finish = gameboard.mapping_hash.fetch(finish.to_sym)
  # end

  def valid_user_input?(user_input)
    gameboard.mapping_hash.key?(user_input.to_sym)
  end

  def start_display_to_array_map(start = start_input)
    @start_space = gameboard.mapping_hash.fetch(start.to_sym)
  end

  def end_display_to_array_map(finish = finish_input)
    @end_space = gameboard.mapping_hash.fetch(finish.to_sym)
  end

  def valid_piece_to_move?(player_color = turn)
    start_display_to_array_map
    space = gameboard.board_array[start_space[0]][start_space[1]]
    space != '__' && space.color == player_color
  end

  # def valid_piece_to_move?(starting_space, player_color = turn)
  #   space = gameboard.board_array[starting_space[0]][starting_space[1]]
  #   space != '__' && space.color == player_color
  # end

  def valid_target_space?(player_color = turn)
    end_display_to_array_map
    space = gameboard.board_array[end_space[0]][end_space[1]]
    return true if space == '__'

    space.color != player_color
  end

  # def valid_finish_input?(user_input, finish = self.finish)
  #   valid_user_input?(user_input) && valid_target_space?(finish)
  # end

  # def valid_start_input?(user_input, start = self.start)
  #   valid_user_input?(user_input) && valid_piece_to_move?(start)
  # end

  def which_piece_selected(starting_space = self.start_space)
    space = gameboard.board_array[starting_space[0]][starting_space[1]]
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

  def take_turn # WIP
    escape_counter = 0
    while true
      choose_move
      # 11/30 addition so cannot put/leave self in check, refactor START
      start_copy = gameboard.board_array[start_space[0]][start_space[1]].dup
      end_copy = gameboard.board_array[end_space[0]][end_space[1]].dup
      move_piece(identify_piece(), end_space)
      fetch_friendly_king
      if friendly_king.in_check && in_check?(friendly_king)
        puts 'You are in check and must escape. You can try one more time:' if escape_counter.zero?
        gameboard.board_array[start_space[0]][start_space[1]] = start_copy
        gameboard.board_array[end_space[0]][end_space[1]] = end_copy
        puts 'CHECK MATE' if escape_counter == 1
        escape_counter += 1
        next unless escape_counter == 2

        turn == 'white' ? @winner = 'Black' : @winner = 'White'
        self.checkmate = 'y'
        end_game
        break

      elsif in_check?(friendly_king) # can remove the board stuff from diag checks? still may be better overal
        puts 'You cannot put yourself in check. Please try again.'
        gameboard.board_array[start_space[0]][start_space[1]] = start_copy
        gameboard.board_array[end_space[0]][end_space[1]] = end_copy
        next

      end
      gameboard.board_array[start_space[0]][start_space[1]] = start_copy
      gameboard.board_array[end_space[0]][end_space[1]] = end_copy
      # 11/30 addition so cannot put/leave self in check, refactor END
      break if commit_move?(identify_piece(), end_space)

      puts 'Illegal move. Please try again.'
    end
    move_piece(identify_piece(), end_space)
    self.total_turn_counter += 1
    flag_moved_rook_or_king
    # 11/30 addition: check if put opponent in check START, refactor
    fetch_enemy_king
    enemy_king.in_check = in_check?(enemy_king)
    puts "\nCheck!\n" if enemy_king.in_check
    # 11/30 addition: check if put opponent in check END, refactor
    switch_turn_to_opponent
  end

  def flag_moved_rook_or_king(board = gameboard.board_array)
    board.flatten.each do |space|
      space.has_moved = true if moved_rook_or_king?(space)
    end
  end

  def moved_rook_or_king?(board_space)
    [Rook, King].include?(board_space.class) &&
      board_space.starting_location != board_space.current_location
  end

  def fetch_friendly_king(board = gameboard.board_array)
    @friendly_king = board.flatten.select do |space|
      space.class == King && space.color == turn
    end[0]
  end

  def fetch_enemy_king(board = gameboard.board_array)
    @enemy_king = board.flatten.select do |space|
      space.class == King && space.color != turn
    end[0]
  end

  def switch_turn_to_opponent
    # self.turn = turn == 'white' ? 'black' : 'white'
    turn == 'white' ? self.turn = 'black' : self.turn = 'white'
  end

  def identify_piece(starting_space = start_space)
    gameboard.board_array[starting_space[0]][starting_space[1]]
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
    first_move_for_pawn(piece, desired_space) if [WhitePawn, BlackPawn].include?(piece.class) &&
                                                 piece.current_location == piece.starting_location
    fetch_friendly_king # can likely remove this later by reordering/doublechecking #take_turn
    move_rook_for_castling if piece.class == King &&
                              (friendly_king.current_location[1] - desired_space[1]).abs == 2
    capture_opponent(piece, desired_space)
    update_board(piece, desired_space)
    piece.current_location = desired_space
  end

  def capture_opponent(piece, desired_space)
    if piece.class == WhitePawn && piece.capture_moves.include?(travel_path)
      white_pawn_captures(piece, desired_space)
    elsif piece.class == BlackPawn && piece.capture_moves.include?(travel_path)
      black_pawn_captures(piece, desired_space)
    elsif desired_space_occupied?(desired_space) && attacking_opponent?(piece, desired_space)
      destroy_enemy(desired_space)
    end
  end

  def first_move_for_pawn(piece, desired_space)
    piece.makes_first_move(desired_space, total_turn_counter)
  end

  def white_pawn_captures(piece, desired_space)
    if desired_space_occupied?(desired_space) && attacking_opponent?(piece, desired_space)
      destroy_enemy(desired_space)
    elsif white_can_en_passant?(piece, desired_space)
      destroy_enemy([desired_space[0] + 1, desired_space[1]])
    end
  end

  def black_pawn_captures(piece, desired_space)
    if desired_space_occupied?(desired_space) && attacking_opponent?(piece, desired_space)
      destroy_enemy(desired_space)
    elsif black_can_en_passant?(piece, desired_space)
      destroy_enemy([desired_space[0] - 1, desired_space[1]])
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
    case piece # cannot use .class here!
    when Knight
      return possible_move?(piece, travel_path)
    when WhitePawn, BlackPawn
      return valid_pawn_move?(piece, travel_path, desired_space)
    # when BlackPawn
    #   return valid_black_pawn_move?(piece, travel_path, desired_space)
    when King
      valid_king_move?(piece, travel_path, desired_space)
    else
      possible_move?(piece, travel_path) && !impeding_piece?(piece, travel_path, desired_space)
    end
  end

  def valid_king_move?(king, travel_path, desired_space)
    if king.possible_moves.include?(travel_path)
      return true if possible_move?(king, travel_path) &&
                     !impeding_piece?(king, travel_path, desired_space)
    elsif king.castling_moves.include?(travel_path)
      return true if king.has_moved == false &&
        king.in_check == false &&
        rook_for_castling?(desired_space) &&
        no_castling_impediments?(desired_space) &&
        !castling_thru_check?(desired_space)
      # and no impeding pieces
      # AND never pass through check
    end
    false
  end

  def rook_for_castling?(desired_space, board = gameboard.board_array)
    case desired_space
    when [0, 2]
      return true if board[0][0].class == Rook && board[0][0].has_moved == false
    when [0, 6]
      return true if board[0][7].class == Rook && board[0][7].has_moved == false
    when [7, 2]
      return true if board[7][0].class == Rook && board[7][0].has_moved == false
    when [7, 6]
      return true if board[7][7].class == Rook && board[7][7].has_moved == false
    end
  end

  def move_rook_for_castling(desired_space, board = gameboard.board_array)
    piece = case desired_space
            when [0, 2]
              board[0][0]
            when [0, 6]
              board[0][7]
            when [7, 2]
              board[7][0]
            when [7, 6]
              board[7][7]
            end
    update_board(piece, desired_space)
    piece.current_location = desired_space
  end

  def no_castling_impediments?(desired_space, board = gameboard.board_array)
    case desired_space
    when [0, 2]
      return true if board[0][1, 3].all? { |space| space == '__' } #.class == String }
    when [0, 6]
      return true if board[0][5, 2].all? { |space| space == '__' }
    when [7, 2]
      return true if board[7][1, 3].all? { |space| space == '__' }
    when [7, 6]
      return true if board[7][5, 2].all? { |space| space == '__' }
    end
  end

  def castling_thru_check?(desired_space, board = gameboard.board_array)
    # in_check? for desired_space already covered since cannot put self in check
    case desired_space
    when [0, 2]
      castle_king_step = King.new('black', [0, 3])
      return true if in_check?(castle_king_step)
    when [0, 6]
      castle_king_step = King.new('black', [0, 5])
      return true if in_check?(castle_king_step)
    when [7, 2]
      castle_king_step = King.new('white', [7, 3])
      return true if in_check?(castle_king_step)
    when [7, 6]
      castle_king_step = King.new('white', [7, 5])
      return true if in_check?(castle_king_step)
    end
  end

  def valid_pawn_move?(piece, travel_path, desired_space)
    if piece.possible_moves.include?(travel_path)
      return true if !desired_space_occupied?(desired_space) && !impeding_piece?(piece, travel_path, desired_space)
    elsif piece.capture_moves.include?(travel_path)
      return true if desired_space_occupied?(desired_space) && attacking_opponent?(piece, desired_space)
      return true if piece.class == WhitePawn && white_can_en_passant?(piece, desired_space)
      return true if piece.class == BlackPawn && black_can_en_passant?(piece, desired_space)
    end
    false
  end

  def white_can_en_passant?(piece, desired_space, board_array = gameboard.board_array)
    # desired space is empty...redundant if can only happen on next turn
    # travel_path in capture_moves...redundant from valid_white_pawn_move?
    piece_attacked = board_array[desired_space[0] + 1][desired_space[1]]
    piece_attacked.class == BlackPawn && (total_turn_counter - piece_attacked.initial_turn == 1)
  end

  def black_can_en_passant?(piece, desired_space, board_array = gameboard.board_array)
    piece_attacked = board_array[desired_space[0] - 1][desired_space[1]]
    piece_attacked.class == WhitePawn && (total_turn_counter - piece_attacked.initial_turn == 1)
  end

  def pawn_initial_move?(piece)
    piece.current_location == piece.starting_location
  end
  # def valid_knight_move?(piece, travel_path)
  #   possible_move?(piece, travel_path)
  # end

  def impeding_piece?(piece, travel_path, desired_space)
    friendly_fire?(piece, desired_space) || 
    horizontal_impediment?(piece, travel_path) ||
    vertical_impediment?(piece, travel_path) ||
    diagonal_impediment?(piece, travel_path)
  end

  def friendly_fire?(piece, desired_space)
    piece_exists?(desired_space) &&
    color_match?(piece, desired_space)
  end

  def horizontal_impediment?(piece, travel_path)
    return false if (travel_path[0]).zero? || (travel_path[1] != 0) # can remove first condition

    horizontal_coord = piece.current_location[1] # 11/26 flip
    fixed_coord = piece.current_location[0] # 11/26 flip
    if travel_path[0].positive?
      horizontal_positive_impediment?(travel_path, fixed_coord, horizontal_coord)
    else
      horizontal_negative_impediment?(travel_path, fixed_coord, horizontal_coord)
    end
  end

  def horizontal_positive_impediment?(travel_path, fixed_coord, horizontal_coord)
    (travel_path[0] - 1).times do
      horizontal_coord += 1
      return true if piece_exists?([fixed_coord, horizontal_coord])
    end
    false
  end

  def horizontal_negative_impediment?(travel_path, fixed_coord, horizontal_coord)
    (travel_path[0].abs() - 1).times do
      horizontal_coord -= 1
      return true if piece_exists?([fixed_coord, horizontal_coord])
    end
    false
  end

  def vertical_impediment?(piece, travel_path)
    return false if (travel_path[1]).zero? || (travel_path[0] != 0) # can remove first condition

    vertical_coord = piece.current_location[0]
    fixed_coord = piece.current_location[1]
    if travel_path[1].positive?
      vertical_positive_impediment?(travel_path, vertical_coord, fixed_coord)
    else
      vertical_negative_impediment?(travel_path, vertical_coord, fixed_coord)
    end
  end

  def vertical_positive_impediment?(travel_path, vertical_coord, fixed_coord)
    (travel_path[1] - 1).times do
      vertical_coord -= 1
      return true if piece_exists?([vertical_coord, fixed_coord])
    end
    false
  end

  def vertical_negative_impediment?(travel_path, vertical_coord, fixed_coord)
    (travel_path[1].abs() - 1).times do
      vertical_coord += 1
      return true if piece_exists?([vertical_coord, fixed_coord])
    end
    false
  end

  def diagonal_impediment?(piece, travel_path)
    return false unless travel_path[0].abs == travel_path[1].abs
    return false if (travel_path[0]).zero? || (travel_path[1]).zero?

    horizontal_coord = piece.current_location[1]
    vertical_coord = piece.current_location[0]

    incremental_diagonal_check?(horizontal_coord, vertical_coord, travel_path)
  end

  def incremental_diagonal_check?(horizontal_coord, vertical_coord, travel_path)
    if travel_path[0].positive? && travel_path[1].positive?
      return true if quadrant_one_impediment?(travel_path, horizontal_coord, vertical_coord)

    elsif travel_path[0].negative? && travel_path[1].positive?
      return true if quadrant_two_impediment?(travel_path, horizontal_coord, vertical_coord)

    elsif travel_path[0].negative? && travel_path[1].negative?
      return true if quadrant_three_impediment?(travel_path, horizontal_coord, vertical_coord)

    else
      return true if quadrant_four_impediment?(travel_path, horizontal_coord, vertical_coord)

    end
    false
  end

  def quadrant_one_impediment?(travel_path, horizontal_coord, vertical_coord)
    (travel_path[0] - 1).times do
      horizontal_coord += 1
      vertical_coord -= 1
      return true if piece_exists?([vertical_coord, horizontal_coord])
    end
    false
  end

  def quadrant_two_impediment?(travel_path, horizontal_coord, vertical_coord)
    (travel_path[0].abs - 1).times do
      horizontal_coord -= 1
      vertical_coord -= 1
      return true if piece_exists?([vertical_coord, horizontal_coord])
    end
    false
  end

  def quadrant_three_impediment?(travel_path, horizontal_coord, vertical_coord)
    (travel_path[0].abs - 1).times do
      horizontal_coord -= 1
      vertical_coord += 1
      return true if piece_exists?([vertical_coord, horizontal_coord])
    end
    false
  end

  def quadrant_four_impediment?(travel_path, horizontal_coord, vertical_coord)
    (travel_path[0] - 1).times do
      horizontal_coord += 1
      vertical_coord += 1
      return true if piece_exists?([vertical_coord, horizontal_coord])
    end
    false
  end

  def piece_exists?(coordinates, board = gameboard.board_array)
    board[coordinates[0]][coordinates[1]].class != String
  end
 
  def color_match?(piece, coordinates, board = gameboard.board_array)
    board[coordinates[0]][coordinates[1]].color == piece.color
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
    board[desired_space[0]][desired_space[1]] = '__'
  end

  # IN CHECK > MODULE?
  def in_check?(king, board = gameboard.board_array)
    horizontal_coord = king.current_location[1]
    vertical_coord = king.current_location[0]
    color = king.color
    return diagonals_check?(color, horizontal_coord, vertical_coord, board) ||
           knight_check?(color, horizontal_coord, vertical_coord, board) ||
           pawn_check?(color, horizontal_coord, vertical_coord, board) ||
           vertical_check?(color, horizontal_coord, vertical_coord, board) ||
           horizontal_check?(color, horizontal_coord, vertical_coord, board)
  end

  def pawn_check?(color, horizontal_coord, vertical_coord, board)
    if color == 'white'
      black_pawn_check?(horizontal_coord, vertical_coord, board)
    else
      white_pawn_check?(horizontal_coord, vertical_coord, board)
    end
  end

  def black_pawn_check?(horizontal_coord, vertical_coord, board)
    board[vertical_coord - 1][horizontal_coord - 1].class == BlackPawn ||
    board[vertical_coord - 1][horizontal_coord + 1].class == BlackPawn
  end

  def white_pawn_check?(horizontal_coord, vertical_coord, board)
    board[vertical_coord + 1][horizontal_coord - 1].class == WhitePawn ||
    board[vertical_coord + 1][horizontal_coord + 1].class == WhitePawn
  end

  #knights
  def knight_check?(color, horizontal_coord, vertical_coord, board)# = gameboard.board_array)
    possible_knights = [1, 2], [2, 1], [-1, 2], [-2, 1], [-1, -2], [-2, -1], 
                       [1, -2], [2, -1]
    possible_knights.each do |knight_check|
      space_check = []
      space_check[0] = vertical_coord + knight_check[0]
      space_check[1] = horizontal_coord + knight_check[1]
      next unless possible_space?([space_check[0], space_check[1]])
      return true if board[space_check[0]][space_check[1]].class == Knight &&
                     board[space_check[0]][space_check[1]].color != color
    end
    false
  end

  #diagonals

  def possible_space?(coord, board = gameboard)
    board.mapping_hash.has_value?(coord)
  end

  # def possible_coord?(coord)
  #   coord.positive? && coord < 8
  # end 

  def diagonals_check?(color, horizontal_coord, vertical_coord, board)
    quadrant_one_check?(color, horizontal_coord, vertical_coord, board) ||
    quadrant_two_check?(color, horizontal_coord, vertical_coord, board) ||
    quadrant_three_check?(color, horizontal_coord, vertical_coord, board) ||
    quadrant_four_check?(color, horizontal_coord, vertical_coord, board)
  end

  #refactor to use possible_space (with board dependency) ?
  def quadrant_one_check?(color, horizontal_coord, vertical_coord, board)
    while true
    # while possible_coord?(horizontal_coord) && possible_coord?(vertical_coord) do
      horizontal_coord += 1
      vertical_coord -= 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board[vertical_coord][horizontal_coord].class
    # color_of_piece = gameboard.board_array[vertical_coord][horizontal_coord].color
    return [Bishop, Queen].include?(type_of_piece) &&
           color != board[vertical_coord][horizontal_coord].color
           # color_of_piece != color
  end

  def quadrant_two_check?(color, horizontal_coord, vertical_coord, board)
    while true
      horizontal_coord -= 1
      vertical_coord -= 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board[vertical_coord][horizontal_coord].class
    return [Bishop, Queen].include?(type_of_piece) &&
           color != board[vertical_coord][horizontal_coord].color
  end

  def quadrant_three_check?(color, horizontal_coord, vertical_coord, board)
    while true
      horizontal_coord -= 1
      vertical_coord += 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board[vertical_coord][horizontal_coord].class
    return [Bishop, Queen].include?(type_of_piece) &&
           color != board[vertical_coord][horizontal_coord].color
  end

  def quadrant_four_check?(color, horizontal_coord, vertical_coord, board)
    while true
      horizontal_coord += 1
      vertical_coord += 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board[vertical_coord][horizontal_coord].class
    return [Bishop, Queen].include?(type_of_piece) &&
           color != board[vertical_coord][horizontal_coord].color
  end

  def vertical_check?(color, horizontal_coord, vertical_coord, board)
    upwards_vertical_check?(color, horizontal_coord, vertical_coord, board) ||
    downwards_vertical_check?(color, horizontal_coord, vertical_coord, board)
  end

  def upwards_vertical_check?(color, horizontal_coord, vertical_coord, board)
    while true
      vertical_coord -= 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board[vertical_coord][horizontal_coord].class
    return [Rook, Queen].include?(type_of_piece) &&
           color != board[vertical_coord][horizontal_coord].color
  end

  def downwards_vertical_check?(color, horizontal_coord, vertical_coord, board)
    while true
      vertical_coord += 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board[vertical_coord][horizontal_coord].class
    return [Rook, Queen].include?(type_of_piece) &&
           color != board[vertical_coord][horizontal_coord].color
  end

  def horizontal_check?(color, horizontal_coord, vertical_coord, board)
    upwards_horizontal_check?(color, horizontal_coord, vertical_coord, board) ||
    downwards_horizontal_check?(color, horizontal_coord, vertical_coord, board)
  end

  def upwards_horizontal_check?(color, horizontal_coord, vertical_coord, board)
    while true
      horizontal_coord += 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board[vertical_coord][horizontal_coord].class
    return [Rook, Queen].include?(type_of_piece) &&
           color != board[vertical_coord][horizontal_coord].color
  end

  def downwards_horizontal_check?(color, horizontal_coord, vertical_coord, board)
    while true
      horizontal_coord -= 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board[vertical_coord][horizontal_coord].class
    return [Rook, Queen].include?(type_of_piece) &&
           color != board[vertical_coord][horizontal_coord].color
  end
end

# board = Board.new
# game = Game.new(board)
# game.initialize_pieces
# game.place_starting_pieces
# game.gameboard.display_board
# while game.game_over == false
#   game.take_turn
#   game.gameboard.display_board
# end
# binding.pry

# king = King.new
