require_relative "../lib/chess"

describe Chess::Bishop do
  let(:board) { Chess::Board.new }
  subject(:bishop) { Chess::Bishop.new(:white) }

  describe "valid_move?" do
    it "allows diagonal movement" do
      board.state[2][0] = bishop
      expect(bishop.valid_move?([2, 0], [4, 2], board)).to be true
    end

    it "prevents non-diagonal movement" do
      board.state[4][0] = bishop
      expect(bishop.valid_move?([4, 0], [4, 3], board)).to be false
    end

    it "prevents movement through pieces" do
      expect(bishop.valid_move?([7, 2], [5, 0], board)).to be false
    end
  end
end
