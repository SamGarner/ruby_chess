module MoveImpedimentConditions
  def impeding_piece?(piece, desired_space)
    friendly_fire?(piece, desired_space) || 
    horizontal_impediment?(piece, travel_path) ||
    vertical_impediment?(piece, travel_path) ||
    diagonal_impediment?(piece, travel_path)
  end

  def friendly_fire?(piece, desired_space)
    gameboard.piece_exists?(desired_space) &&
    gameboard.color_match?(piece, desired_space)
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
      return true if gameboard.piece_exists?([fixed_coord, horizontal_coord])
    end
    false
  end

  def horizontal_negative_impediment?(travel_path, fixed_coord, horizontal_coord)
    (travel_path[0].abs() - 1).times do
      horizontal_coord -= 1
      return true if gameboard.piece_exists?([fixed_coord, horizontal_coord])
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
      return true if gameboard.piece_exists?([vertical_coord, fixed_coord])
    end
    false
  end

  def vertical_negative_impediment?(travel_path, vertical_coord, fixed_coord)
    (travel_path[1].abs() - 1).times do
      vertical_coord += 1
      return true if gameboard.piece_exists?([vertical_coord, fixed_coord])
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
      return true if gameboard.piece_exists?([vertical_coord, horizontal_coord])
    end
    false
  end

  def quadrant_two_impediment?(travel_path, horizontal_coord, vertical_coord)
    (travel_path[0].abs - 1).times do
      horizontal_coord -= 1
      vertical_coord -= 1
      return true if gameboard.piece_exists?([vertical_coord, horizontal_coord])
    end
    false
  end

  def quadrant_three_impediment?(travel_path, horizontal_coord, vertical_coord)
    (travel_path[0].abs - 1).times do
      horizontal_coord -= 1
      vertical_coord += 1
      return true if gameboard.piece_exists?([vertical_coord, horizontal_coord])
    end
    false
  end

  def quadrant_four_impediment?(travel_path, horizontal_coord, vertical_coord)
    (travel_path[0] - 1).times do
      horizontal_coord += 1
      vertical_coord += 1
      return true if gameboard.piece_exists?([vertical_coord, horizontal_coord])
    end
    false
  end
end