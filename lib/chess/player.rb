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
end
