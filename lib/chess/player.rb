module Chess
  class Player
    attr_reader :color

    def initialize(color)
      @color = color
    end

    def to_s
      "#{color.to_s.capitalize} Player"
    end
  end

  class ComputerPlayer < Player
    def make_move(board)
      legal_moves = find_all_legal_moves(board)

      raise "No legal moves available - game should have ended!" if legal_moves.empty?

      legal_moves.sample
    end

    private

    def find_all_legal_moves(board)
      legal_moves = []

      board.state.each_with_index do |row, from_row|
        row.each_with_index do |piece, from_col|
          next if piece.nil? || piece.color != color

          (0..7).each do |to_row|
            (0..7).each do |to_col|
              from = [from_row, from_col]
              to = [to_row, to_col]

              if board.valid_move?(from, to, self) &&
                  !board.move_leaves_king_in_check?(from, to, self)
                legal_moves << { from: from, to: to }
              end
            end
          end
        end
      end

      legal_moves
    end
  end
end
