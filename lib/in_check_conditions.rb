module InCheckConditions
  def pawn_check?(color, horizontal_coord, vertical_coord)
    if color == 'white'
      black_pawn_check?(horizontal_coord, vertical_coord)
    else
      white_pawn_check?(horizontal_coord, vertical_coord)
    end
  end

  def black_pawn_check?(horizontal_coord, vertical_coord)
    board_array[vertical_coord - 1][horizontal_coord - 1].class == BlackPawn ||
    board_array[vertical_coord - 1][horizontal_coord + 1].class == BlackPawn
  end

  def white_pawn_check?(horizontal_coord, vertical_coord)
    board_array[vertical_coord + 1][horizontal_coord - 1].class == WhitePawn ||
    board_array[vertical_coord + 1][horizontal_coord + 1].class == WhitePawn
  end

  def possible_space?(coord)
    mapping_hash.has_value?(coord)
  end

  #knights
  def knight_check?(color, horizontal_coord, vertical_coord)
    possible_knights = [1, 2], [2, 1], [-1, 2], [-2, 1], [-1, -2], [-2, -1], 
                       [1, -2], [2, -1]
    possible_knights.each do |knight_check|
      space_check = []
      space_check[0] = vertical_coord + knight_check[0]
      space_check[1] = horizontal_coord + knight_check[1]
      next unless possible_space?([space_check[0], space_check[1]])
      return true if board_array[space_check[0]][space_check[1]].class == Knight &&
                     board_array[space_check[0]][space_check[1]].color != color
    end
    false
  end

  def diagonals_check?(color, horizontal_coord, vertical_coord)
    quadrant_one_check?(color, horizontal_coord, vertical_coord) ||
    quadrant_two_check?(color, horizontal_coord, vertical_coord) ||
    quadrant_three_check?(color, horizontal_coord, vertical_coord) ||
    quadrant_four_check?(color, horizontal_coord, vertical_coord)
  end

  def quadrant_one_check?(color, horizontal_coord, vertical_coord)
    while true
      horizontal_coord += 1
      vertical_coord -= 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board_array[vertical_coord][horizontal_coord].class
    return [Bishop, Queen].include?(type_of_piece) &&
           color != board_array[vertical_coord][horizontal_coord].color
  end

  def quadrant_two_check?(color, horizontal_coord, vertical_coord)
    while true
      horizontal_coord -= 1
      vertical_coord -= 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board_array[vertical_coord][horizontal_coord].class
    return [Bishop, Queen].include?(type_of_piece) &&
           color != board_array[vertical_coord][horizontal_coord].color
  end

  def quadrant_three_check?(color, horizontal_coord, vertical_coord)
    while true
      horizontal_coord -= 1
      vertical_coord += 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board_array[vertical_coord][horizontal_coord].class
    return [Bishop, Queen].include?(type_of_piece) &&
           color != board_array[vertical_coord][horizontal_coord].color
  end

  def quadrant_four_check?(color, horizontal_coord, vertical_coord)
    while true
      horizontal_coord += 1
      vertical_coord += 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board_array[vertical_coord][horizontal_coord].class
    return [Bishop, Queen].include?(type_of_piece) &&
           color != board_array[vertical_coord][horizontal_coord].color
  end

  def vertical_check?(color, horizontal_coord, vertical_coord)
    upwards_vertical_check?(color, horizontal_coord, vertical_coord) ||
    downwards_vertical_check?(color, horizontal_coord, vertical_coord)
  end

  def upwards_vertical_check?(color, horizontal_coord, vertical_coord)
    while true
      vertical_coord -= 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board_array[vertical_coord][horizontal_coord].class
    return [Rook, Queen].include?(type_of_piece) &&
           color != board_array[vertical_coord][horizontal_coord].color
  end

  def downwards_vertical_check?(color, horizontal_coord, vertical_coord)
    while true
      vertical_coord += 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board_array[vertical_coord][horizontal_coord].class
    return [Rook, Queen].include?(type_of_piece) &&
           color != board_array[vertical_coord][horizontal_coord].color
  end

  def horizontal_check?(color, horizontal_coord, vertical_coord)
    upwards_horizontal_check?(color, horizontal_coord, vertical_coord) ||
    downwards_horizontal_check?(color, horizontal_coord, vertical_coord)
  end

  def upwards_horizontal_check?(color, horizontal_coord, vertical_coord)
    while true
      horizontal_coord += 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board_array[vertical_coord][horizontal_coord].class
    return [Rook, Queen].include?(type_of_piece) &&
           color != board_array[vertical_coord][horizontal_coord].color
  end

  def downwards_horizontal_check?(color, horizontal_coord, vertical_coord)
    while true
      horizontal_coord -= 1
      break if !possible_space?([vertical_coord, horizontal_coord]) ||
               piece_exists?([vertical_coord, horizontal_coord])
    end
    return false unless possible_space?([vertical_coord, horizontal_coord])

    type_of_piece = board_array[vertical_coord][horizontal_coord].class
    return [Rook, Queen].include?(type_of_piece) &&
           color != board_array[vertical_coord][horizontal_coord].color
  end
end