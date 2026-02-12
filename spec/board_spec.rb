require_relative "../lib/chess"

describe Chess::Board do
  subject(:board) { described_class.new }

  describe "#initialize" do
    it "creates an 8x8 board" do
      expect(board.state.length).to eq(8)
      expect(board.state[0].length).to eq(8)
    end
  end
end
