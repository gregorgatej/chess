require_relative "../lib/chess"

describe Chess::Pawn do
  let(:board) { Chess::Board.new }
  subject(:pawn) { described_class.new(:white) }

  describe "#valid_move?" do
    it "allows forward move of 1 square" do
      expect(pawn.valid_move?([6, 0], [5, 0], board)).to be true
    end

    it "allows forward move of 2 squares from starting position" do
      expect(pawn.valid_move?([6, 0], [4, 0], board)).to be true
    end

    it "prevents forward move of 2 squares from non-starting position" do
      board.move_piece([6, 0], [5, 0])
      expect(pawn.valid_move?([5, 0], [3, 0], board)).to be false
    end

    it "prevents diagonal move without capturing" do
      expect(pawn.valid_move?([6, 0], [5, 1], board)).to be false
    end

    it "allows diagonal move when capturing" do
      opponent_pawn = Chess::Pawn.new(:black)
      board.state[4][1] = opponent_pawn

      board.move_piece([6, 0], [5, 0])
      expect(pawn.valid_move?([5, 0], [4, 1], board)).to be true
    end
    
    it "prevents moving backward" do
      board.move_piece([6, 0], [5, 0])
      expect(pawn.valid_move?([5, 0], [6, 0], board)).to be false
    end

    it "prevents capturing own piece" do
      own_piece = Chess::Pawn.new(:white)
      board.state[5][1] = own_piece

      expect(pawn.valid_move?([6, 0], [5, 1], board)).to be false
    end
  end
end
