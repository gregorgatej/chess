module Chess
  class Piece
    attr_reader :color

    SYMBOLS = {
      white: {
        pawn: "♙",
        rook: "♖",
        knight: "♘",
        bishop: "♗",
        queen: "♕",
        king: "♔"
      },
      black: {
        pawn: "♟",
        rook: "♜",
        knight: "♞",
        bishop: "♝",
        queen: "♛",
        king: "♚"
      }
    }

    def initialize(color)
      @color = color
    end

    def to_s
      SYMBOLS[color][type]
    end

    def type
      raise NotImplementedError, "Subclasses must define type"
    end
  end

  class Pawn < Piece
    def type
      :pawn
    end
  end

  class Rook < Piece
    def type
      :rook
    end
  end

  class Knight < Piece
    def type
      :knight
    end
  end

  class Bishop < Piece
    def type
      :bishop
    end
  end

  class Queen < Piece
    def type
      :queen
    end
  end

  class King < Piece
    def type
      :king
    end
  end
end
