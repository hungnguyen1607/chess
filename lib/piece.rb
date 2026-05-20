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
end

class Pawn < Piece
  def symbol
    color == :white ? '♙' : '♟'
  end
end

class Rook < Piece
  def symbol
    color == :white ? '♖' : '♜'
  end
end

class Knight < Piece
  def symbol
    color == :white ? '♘' : '♞'
  end
end

class Bishop < Piece
  def symbol
    color == :white ? '♗' : '♝'
  end
end

class Queen < Piece
  def symbol
    color == :white ? '♕' : '♛'
  end
end

class King < Piece
  def symbol
    color == :white ? '♔' : '♚'
  end
end
