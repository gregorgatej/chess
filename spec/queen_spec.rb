require_relative "../lib/chess"

describe Chess::Queen do
  let(:board) { Chess::Board.new }
  subject(:queen) { described_class.new(:white) }

  describe "#valid_move?" do
    it "allows horizontal movement" do
      board.state[4][0] = queen
      expect(queen.valid_move?([4, 0], [4, 3], board)).to be true
    end

    it "allows vertical movement" do
      board.state[3][0] = queen
      expect(queen.valid_move?([3, 0], [5, 0], board)).to be true
    end

    it "allows diagonal movement" do
      board.state[3][0] = queen
      expect(queen.valid_move?([3, 0], [5, 2], board)).to be true
    end

    it "prevents L-shaped moves" do
      board.state[4][0] = queen
      expect(queen.valid_move?([4, 0], [3, 2], board)).to be false
    end
  end
end
