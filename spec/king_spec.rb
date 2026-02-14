require_relative "../lib/chess"

describe Chess::King do
  let(:board) { Chess::Board.new }
  subject(:king) { Chess::King.new(:white) }

  describe "#valid_move?" do
    it "allows move 1 square in any direction" do
      board.state[4][4] = king
      expect(king.valid_move?([4, 4], [5, 5], board)).to be true
      expect(king.valid_move?([4, 4], [4, 5], board)).to be true
      expect(king.valid_move?([4, 4], [5, 3], board)).to be true
    end

    it "prevents move more than 1 square" do
      king = Chess::King.new(:white)
      board.state[3][3] = king
      expect(king.valid_move?([3, 3], [5, 5], board)).to be false
    end

    it "prevents capturing own piece" do
      expect(king.valid_move?([7, 4], [6, 4], board)).to be false
    end
  end
end
