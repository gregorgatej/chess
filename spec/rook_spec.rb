require_relative "../lib/chess"

describe Chess::Rook do
  let(:board) { Chess::Board.new }
  subject(:rook) { described_class.new(:white) }

  describe "#valid_move?" do
    it "allows horizontal movement" do
      board.state[4][0] = rook
      expect(rook.valid_move?([4, 0], [4, 3], board)).to be true
    end

    it "allows vertical movement" do
      board.state[3][0] = rook
      expect(rook.valid_move?([3, 0], [5, 0], board)).to be true
    end

    it "prevents diagonal movement" do
      board.state[4][0] = rook
      expect(rook.valid_move?([4, 0], [2, 2], board)).to be false
    end

    it "prevents movement through pieces" do
      expect(rook.valid_move?([7, 0], [7, 1], board)).to be false
    end
  end
end
