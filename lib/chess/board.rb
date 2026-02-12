module Chess
  class Board
    ROWS = 8
    COLS = 8

    attr_accessor :state

    def initialize
      @state = Array.new(ROWS) { Array.new(COLS, nil) }
      setup_pieces
    end

    def to_s
      display = "  0 1 2 3 4 5 6 7\n"
      state.each_with_index do |row, index|
        display += "#{index} "
        display += row.map { |cell| cell.nil? ? "· " : "#{cell} " }.join("")
        display += "\n"
      end
      display
    end

    def empty?(pos)
      state[pos[0]][pos[1]].nil?
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
