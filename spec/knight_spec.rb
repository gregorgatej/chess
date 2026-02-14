require_relative "../lib/chess"

describe Chess::Knight do
  let(:board) { Chess::Board.new }
  subject(:knight) { described_class.new(:white) }

  describe "#valid_move?" do
    it "allows L-shaped move (2 up, 1 right)" do
      board.state[4][4] = knight
      expect(knight.valid_move?([4, 4], [2, 5], board)).to be true
    end

    it "allows L-shaped move (2 right, 1 up)" do
      board.state[4][4] = knight
      expect(knight.valid_move?([4, 4], [3, 6], board)).to be true
    end

    it "prevents non-L-shaped moves" do
      board.state[4][4] = knight
      expect(knight.valid_move?([4, 4], [5, 5], board)).to be false
    end

    it "allows jumping over pieces" do
      expect(knight.valid_move?([7, 1], [5, 2], board)).to be true
    end
  end
end
