require_relative "entity"

class Trump < Entity
  attr_accessor :health
  attr_reader :spawn_x, :spawn_y

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
    @spawn_x = x
    @spawn_y = y
    @health = 25
    @pic = Gosu::Image.new("assets/images/trump.png")
  end
end
