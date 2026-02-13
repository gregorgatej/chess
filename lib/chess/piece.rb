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

    def valid_move?(from, to, board)
      return false if board.same_color?(from, to)

      direction = color == :white ? -1 : 1
      from_row, from_col = from
      to_row, to_col = to

      # Forward move
      if to_col ==from_col && board.empty?(to)
        if to_row == from_row + direction
          return true
        elsif (color == :white && from_row == 6) || (color == :black && from_row == 1)
          return to_row == from_row + 2 * direction && board.empty?([from_row + direction, from_col])
        end
      end

      # Capture diagonally
      (to_col - from_col).abs == 1 && to_row == from_row + direction && !board.empty?(to)
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

    def valid_move?(from, to, board)
      return false if board.same_color?(from, to)

      from_row, from_col = from
      to_row, to_col = to
      row_diff = (to_row - from_row).abs
      col_diff = (to_col - from_col).abs

      (row_diff == 2 && col_diff == 1) || (row_diff == 1 && col_diff == 2)
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
