class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def to_s
    symbol
  end

  def symbol
    raise NotImplementedError, 'Each piece must define a symbol'
  end

  def path_clear?(from_row, from_col, to_row, to_col, board)
    row_step = (to_row <=> from_row)
    col_step = (to_col <=> from_col)
    current_row, current_col = from_row + row_step, from_col + col_step
    while current_row != to_row || current_col != to_col
      return false if board.piece_at(current_row, current_col)

      current_row += row_step
      current_col += col_step
    end
    true
  end
end

class Pawn < Piece
  def symbol
    color == :white ? '♙' : '♟'
  end

  def move_valid?(from_row, from_col, to_row, to_col, board)
    direction = color == :white ? -1 : 1
    start_row = color == :white ? 6 : 1

    # Normal move
    if to_col == from_col && to_row == from_row + direction && board.piece_at(to_row, to_col).nil?
      return true
    end

    # Initial double move
    if to_col == from_col && from_row == start_row && to_row == from_row + 2 * direction &&
       board.piece_at(from_row + direction, to_col).nil? && board.piece_at(to_row, to_col).nil?
      return true
    end

    # Capture move
    if (to_col == from_col + 1 || to_col == from_col - 1) && to_row == from_row + direction
      destination_piece = board.piece_at(to_row, to_col)
      return destination_piece && destination_piece.color != color
    end

    false
  end

end

class Rook < Piece
  def symbol
    color == :white ? '♖' : '♜'
  end

  def move_valid?(from_row, from_col, to_row, to_col, board)
    return false unless from_row == to_row || from_col == to_col

    # Check if the destination square is occupied by a piece of the same color
    destination_piece = board.piece_at(to_row, to_col)
    return false if destination_piece && destination_piece.color == color
    true
    path_clear?(from_row, from_col, to_row, to_col, board)
  end

end

class Knight < Piece
  def symbol
    color == :white ? '♘' : '♞'
  end

  def move_valid?(from_row, from_col, to_row, to_col, board)
    row_diff = (to_row - from_row).abs
    col_diff = (to_col - from_col).abs
    return false unless (row_diff == 2 && col_diff == 1) || (row_diff == 1 && col_diff == 2)

    # Check if the destination square is occupied by a piece of the same color
    destination_piece = board.piece_at(to_row, to_col)
    return false if destination_piece && destination_piece.color == color

    true
  end
end

class Bishop < Piece
  def symbol
    color == :white ? '♗' : '♝'
  end

  def move_valid?(from_row, from_col, to_row, to_col, board)
    row_diff = (to_row - from_row).abs
    col_diff = (to_col - from_col).abs
    return false unless row_diff == col_diff

    # Check if the destination square is occupied by a piece of the same color
    destination_piece = board.piece_at(to_row, to_col)
    return false if destination_piece && destination_piece.color == color

    true

    path_clear?(from_row, from_col, to_row, to_col, board)
  end

  
end

class Queen < Piece
  def symbol
    color == :white ? '♕' : '♛'
  end

  def move_valid?(from_row, from_col, to_row, to_col, board)
    row_diff = (to_row - from_row).abs
    col_diff = (to_col - from_col).abs

    # check for valid queen moves (combination of rook and bishop)
    return true if row_diff == col_diff || from_row == to_row || from_col == to_col

    false
    path_clear?(from_row, from_col, to_row, to_col, board)
  end
  
end

class King < Piece
  def symbol
    color == :white ? '♔' : '♚'
  end

  def move_valid?(from_row, from_col, to_row, to_col, board)
    row_diff = (to_row - from_row).abs
    col_diff = (to_col - from_col).abs
    return false if row_diff > 1 || col_diff > 1

    # Check if the destination square is occupied by a piece of the same color
    destination_piece = board.piece_at(to_row, to_col)
    return false if destination_piece && destination_piece.color == color

    true
  end
end
