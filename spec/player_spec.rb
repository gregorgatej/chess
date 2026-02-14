require_relative "../lib/chess"

describe Chess::Player do
  subject(:player) { described_class.new(:white) }

  describe "#initialize" do
    it "creates a player with a color" do
      expect(player.color).to eq(:white)
    end
  end

  describe "#to_s" do
    it "returns capitalized color with 'Player'" do
      expect(player.to_s).to eq("White Player")
    end
  end
end
