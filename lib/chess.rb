# frozen_string_literal: false

require 'pry'
require_relative 'pieces/king.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/white_pawn.rb'
require_relative 'pieces/black_pawn.rb'
require_relative 'board.rb'
require_relative 'in_check_conditions.rb'
require_relative 'move_impediment_conditions.rb'

# Game
class Game
  include MoveImpedimentConditions

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
              :finish, :start_space, :winner,
              :enemy_king, :friendly_king, :rook_start_copy, :rook_end_copy,
              :castle_spaces_crossed_mapping, :castle_king_crossed_mapping, 
              :castle_space_to_rook_mapping, :castle_restore_rook_mapping,
              :rook_end_coord, :promotion, :serialized_gameboard
  attr_accessor :gameboard, :turn, :total_turn_counter, :travel_path, #travel_path to reader?
                :start_input, :finish_input, :game_over, :checkmate,
                :new_promoted_piece, :escape_counter,
                :end_space # only moved from attr_reader for tests, refactor tests
                # :white_king, :black_king
                # move :start_input and :finish input to attr_reader after redo testing setup

  def initialize(board)
    @gameboard = board
    @turn = 'white'
    @total_turn_counter = 0
    @game_over = false
  end

  def place_starting_pieces(board = gameboard)  # module?
    board.place_starting_kings
    board.place_starting_queens
    board.place_starting_bishops
    board.place_starting_knights
    board.place_starting_rooks
    board.place_starting_white_pawns
    board.place_starting_black_pawns
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

  def valid_user_input?(user_input)
    gameboard.mapping_hash.key?(user_input.to_sym)
  end

  def valid_piece_to_move?(player_color = turn)
    start_display_to_array_map
    space = gameboard.board_array[start_space[0]][start_space[1]]
    space != '__' && space.color == player_color
  end

  def start_display_to_array_map(start = start_input)
    @start_space = gameboard.mapping_hash.fetch(start.to_sym)
  end

  def which_piece_selected(starting_space = self.start_space)
    space = gameboard.board_array[starting_space[0]][starting_space[1]]
    @piece_type = space.class
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

  def valid_target_space?(player_color = turn)
    end_display_to_array_map
    space = gameboard.board_array[end_space[0]][end_space[1]]
    return true if space == '__'

    space.color != player_color
  end

  def end_display_to_array_map(finish = finish_input)
    @end_space = gameboard.mapping_hash.fetch(finish.to_sym)
  end

  def take_turn
    self.escape_counter = 0 # for #ensure_move_not_sacrificing_king
    ensure_move_not_sacrificing_king
    move_piece(identify_piece, end_space)
    self.total_turn_counter += 1
    flag_moved_rook_or_king
    confirm_enemy_king_status
    switch_turn_to_opponent
  end

  def ensure_move_not_sacrificing_king
    loop do
      choose_legal_move_loop
      @serialized_gameboard = Marshal.dump(gameboard)
      ask_how_to_promote_pawn if promoting_pawn?(identify_piece) # needs to stay before #move_piece if using identify piece
      move_piece(identify_piece, end_space)
      fetch_friendly_king
      if friendly_king.in_check && in_check?(friendly_king) # must escape check
        demand_user_escape_check
        restore_board_after_checking_move_legality
        self.escape_counter += 1

        escape_counter < 2 ? next : unable_to_escape_check

        break

      elsif in_check?(friendly_king) # cannot put oneself in check
        puts 'You cannot put yourself in check. Please try again.'
        restore_board_after_checking_move_legality
        next

      end
      restore_board_after_checking_move_legality
      break
    end
  end

  def choose_legal_move_loop
    loop do
      choose_move
      unless commit_move?(identify_piece, end_space)
        puts 'Illegal move. Please try again.'
        next

      end
      break
    end
  end

  def demand_user_escape_check
    if escape_counter.zero?
      puts 'You are in check and must escape. You can try one more time:'
    else
      puts 'CHECK MATE'
    end
  end

  def restore_board_after_checking_move_legality
    self.gameboard = Marshal.load(serialized_gameboard)
  end

  def unable_to_escape_check
    turn == 'white' ? @winner = 'Black' : @winner = 'White'
    self.checkmate = 'y'
    end_game 
  end

  def confirm_enemy_king_status
    fetch_enemy_king
    enemy_king.in_check = in_check?(enemy_king)
    puts "\nCheck!\n" if enemy_king.in_check
  end

  def define_castling_mappings(board = gameboard.board_array)
    @castle_space_to_rook_mapping = { [0, 2] => board[0][0],
                                      [0, 6] => board[0][7],
                                      [7, 2] => board[7][0],
                                      [7, 6] => board[7][7] }
    @castle_king_crossed_mapping = { [0, 2] => [0, 3],
                                     [0, 6] => [0, 5],
                                     [7, 2] => [7, 3],
                                     [7, 6] => [7, 5] }
    @castle_spaces_crossed_mapping = { [0, 2] => board[0][1, 3],
                                       [0, 6] => board[0][5, 2],
                                       [7, 2] => board[7][1, 3],
                                       [7, 6] => board[7][5, 2] }
    @castle_restore_rook_mapping = { [0, 2] => [0, 0],
                                     [0, 6] => [0, 7],
                                     [7, 2] => [7, 0],
                                     [7, 6] => [7, 7] }
  end

  # def copy_castling_spaces(board = gameboard.board_array)
  #   @rook_start_copy = castle_space_to_rook_mapping.fetch(end_space).dup
  #   @rook_end_coord = castle_king_crossed_mapping.fetch(end_space)
  #   @rook_end_copy = board[rook_end_coord[0]][rook_end_coord[1]].dup
  # end

  # def restore_castling_copies(board = gameboard.board_array)
  #   # rook_start = castle_space_to_rook_mapping.fetch(end_space)
  #   rook_start_coord = castle_restore_rook_mapping.fetch(end_space)
  #   board[rook_start_coord[0]][rook_end_coord[1]] = rook_start_copy
  #   # rook_start = rook_start_copy
  #   # # castle_space_to_rook_mapping.fetch(end_space) = rook_start_copy
  #   board[rook_end_coord[0]][rook_end_coord[1]] = rook_end_copy
  #   # if end_space == [0, 6]
  #   #   board[0][7] = rook_start_copy
  #   #   board[0][5] = rook_end_copy
  #   # elsif end_space == [0, 2]
  #   #   board[0][0] = rook_start_copy
  #   #   board[0][3] = rook_end_copy
  #   # elsif end_space == [7, 6]
  #   #   board[7][7] = rook_start_copy
  #   #   board[7][5] = rook_end_copy
  #   # else 
  #   #   board[7][0] = rook_start_copy
  #   #   board[7][3] = rook_end_copy
  #   # end
  # end

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
    turn == 'white' ? self.turn = 'black' : self.turn = 'white'
  end

  def identify_piece(starting_space = start_space)
    gameboard.board_array[starting_space[0]][starting_space[1]]
  end

  def move_piece(piece, desired_space) # move to ChessPiece SuperClass once 'working'
    first_move_for_pawn(piece, desired_space) if [WhitePawn, BlackPawn].include?(piece.class) &&
                                                 piece.current_location == piece.starting_location
    fetch_friendly_king # can likely remove this later by reordering/doublechecking #take_turn
    move_rook_for_castling(desired_space) if piece.class == King &&
                                          (friendly_king.current_location[1] - desired_space[1]).abs == 2
    capture_opponent(piece, desired_space)
    gameboard.update_board(piece, desired_space)
    pawn_promotion if promoting_pawn?(piece)
    piece.current_location = desired_space
  end

  def capture_opponent(piece, desired_space)
    if piece.class == WhitePawn && piece.capture_moves.include?(travel_path)
      white_pawn_captures(piece, desired_space)
    elsif piece.class == BlackPawn && piece.capture_moves.include?(travel_path)
      black_pawn_captures(piece, desired_space)
    elsif gameboard.piece_exists?(desired_space) && gameboard.attacking_opponent?(piece, desired_space)
      gameboard.destroy_enemy(desired_space)
    end
  end

  def first_move_for_pawn(piece, desired_space)
    piece.makes_first_move(desired_space, total_turn_counter)
  end

  def white_pawn_captures(piece, desired_space)
    if gameboard.piece_exists?(desired_space) && gameboard.attacking_opponent?(piece, desired_space)
      gameboard.destroy_enemy(desired_space)
    elsif white_can_en_passant?(piece, desired_space)
      gameboard.destroy_enemy([desired_space[0] + 1, desired_space[1]])
    end
  end

  def black_pawn_captures(piece, desired_space)
    if gameboard.piece_exists?(desired_space) && gameboard.attacking_opponent?(piece, desired_space)
      gameboard.destroy_enemy(desired_space)
    elsif black_can_en_passant?(piece, desired_space)
      gameboard.destroy_enemy([desired_space[0] - 1, desired_space[1]])
    end
  end

  def promoting_pawn?(piece)
    [WhitePawn, BlackPawn].include?(piece.class) && [0, 7].include?(end_space[0])
  end

  def pawn_promotion(board = gameboard)
    create_piece_for_promotion
    board.add_new_promoted_piece_to_board(end_space, new_promoted_piece)
  end

  def ask_how_to_promote_pawn
    loop do
      puts "Your pawn has reached the final rank. Enter which piece you would like\
            to replace it with - queen, bishop, rook, or knight:"
      @promotion = gets.chomp.downcase
      break if %w[queen bishop rook knight].include?(promotion)

      puts "Invalid input. Please enter 'queen', 'bishop', 'rook', or 'knight':"
    end
  end

  def create_piece_for_promotion
    @new_promoted_piece = case promotion
                          when 'queen'
                            Queen.new(turn, end_space)
                          when 'bishop'
                            Bishop.new(turn, end_space)
                          when 'rook'
                            Rook.new(turn, end_space)
                          when 'knight'
                            Knight.new(turn, end_space)
                          end
    new_promoted_piece.has_moved = true if new_promoted_piece.class == Rook
    # either the line above, or a comparison of King vs Rook color when castling is needed
  end

  # def add_new_promoted_piece_to_board(board = gameboard.board_array)
  #   board[end_space[0]][end_space[1]] = new_promoted_piece
  # end

  # def passant_vulnerable?(starting_space, ending_space)
  #   (starting_space[1] - ending_space[1]).abs == 2
  # end

  def commit_move?(piece, desired_space)
    get_travel_path(piece, desired_space)
    valid_move?(piece, desired_space)
  end

  def get_travel_path(piece, desired_space)
    @travel_path = [] # think regular x,y coordinates
    travel_path[0] = desired_space[1] - piece.current_location[1] # horizontal plane
    travel_path[1] = piece.current_location[0] - desired_space[0] # vertical plane
    # e.g rook travel path, 7,7 --> 5, 7 = [-2, 0]
      # pawn [6,7] > [5,7]
      # tp[0] = 7 - 7
      # tp[1] = 6 - 5
      # tp = [0, 1]
  end

  def possible_move?(piece) # direction possible for type of piece
    piece.possible_moves.include?(travel_path)
  end

  def valid_move?(piece, desired_space)
    case piece # cannot use .class here!
    when Knight
      return possible_move?(piece)
    when WhitePawn, BlackPawn
      return valid_pawn_move?(piece, travel_path, desired_space)
    when King
      valid_king_move?(piece, travel_path, desired_space)
    else
      possible_move?(piece) && !impeding_piece?(piece, desired_space)
    end
  end

  def valid_king_move?(king, travel_path, desired_space)
    if king.possible_moves.include?(travel_path)
      return true if !impeding_piece?(king, desired_space)
    elsif king.castling_moves.include?(travel_path)
      return true if king.has_moved == false &&
        king.in_check == false &&
        rook_for_castling?(desired_space) &&
        no_castling_impediments?(desired_space) &&
        !castling_thru_check?(desired_space)
    end
    false
  end

  def rook_for_castling?(desired_space, board = gameboard.board_array)
    castle_space_to_rook_mapping = { [0, 2] => board[0][0],
                                     [0, 6] => board[0][7],
                                     [7, 2] => board[7][0],
                                     [7, 6] => board[7][7] }
    rook_space = castle_space_to_rook_mapping.fetch(desired_space)
    rook_space.class == Rook && rook_space.has_moved == false
  end

  def no_castling_impediments?(desired_space, board = gameboard.board_array)
    castle_spaces_crossed_mapping = { [0, 2] => board[0][1, 3],
                                      [0, 6] => board[0][5, 2],
                                      [7, 2] => board[7][1, 3],
                                      [7, 6] => board[7][5, 2] }
    spaces_to_check = castle_spaces_crossed_mapping.fetch(desired_space)
    spaces_to_check.all? { |space| space == '__' }
  end

  def castling_thru_check?(desired_space, board = gameboard.board_array)
    # in_check? for desired_space already covered since cannot put self in check
    castle_king_crossed_mapping = { [0, 2] => [0, 3],
                                    [0, 6] => [0, 5],
                                    [7, 2] => [7, 3],
                                    [7, 6] => [7, 5] }
    castle_king_path = King.new(turn, castle_king_crossed_mapping.fetch(desired_space))
    in_check?(castle_king_path)
  end

  def move_rook_for_castling(desired_space, board = gameboard.board_array)
    castle_space_to_rook_mapping = { [0, 2] => board[0][0],
                                     [0, 6] => board[0][7],
                                     [7, 2] => board[7][0],
                                     [7, 6] => board[7][7] }
    # rook will not be moved appropriately without mapping table above
    # even though defined as instance var
    rook = castle_space_to_rook_mapping.fetch(desired_space)
    rook_desired_space = castle_king_crossed_mapping.fetch(desired_space)
    gameboard.update_board(rook, rook_desired_space)
    rook.current_location = rook_desired_space
  end

  def valid_pawn_move?(piece, travel_path, desired_space)
    if piece.possible_moves.include?(travel_path)
      return true if !gameboard.piece_exists?(desired_space) && !impeding_piece?(piece, desired_space)
    elsif piece.capture_moves.include?(travel_path)
      return true if gameboard.piece_exists?(desired_space) && gameboard.attacking_opponent?(piece, desired_space)
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

  def in_check?(king, board = gameboard.board_array)
    horizontal_coord = king.current_location[1]
    vertical_coord = king.current_location[0]
    color = king.color
    return gameboard.diagonals_check?(color, horizontal_coord, vertical_coord) ||
           gameboard.knight_check?(color, horizontal_coord, vertical_coord) ||
           gameboard.pawn_check?(color, horizontal_coord, vertical_coord) ||
           gameboard.vertical_check?(color, horizontal_coord, vertical_coord) ||
           gameboard.horizontal_check?(color, horizontal_coord, vertical_coord)
  end
end

# board = Board.new
# game = Game.new(board)
# # game.initialize_pieces
# game.place_starting_pieces
# game.gameboard.display_board
# game.define_castling_mappings
# while game.game_over == false
#   game.take_turn
#   game.gameboard.display_board
# end
# # binding.pry

# king = King.new
