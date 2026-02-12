module Chess
  class Board
    ROWS = 8
    COLS = 8

    attr_accessor :state

    def initialize
      @state = Array.new(ROWS) { Array.new(COLS, nil) }
      setup_pieces
    end

    private

    def setup_pieces
      # Black pieces on top
      setup_back_row(0, :black)
      setup_pawns(1, :black)

      # White pieces at bottom
      setup_pawns(6, :white)
      setup_back_row(7, :white)
    end

    def setup_back_row(row, color)
      back_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      back_row.each_with_index do |piece_class, col|
        @state[row][col] = piece_class.new(color)
      end
    end

    def setup_pawns(row, color)
      COLS.times do |col|
        @state[row][col] = Pawn.new(color)
      end
    end
  end
end
