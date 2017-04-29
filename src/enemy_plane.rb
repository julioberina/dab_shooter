require_relative "entity"

class EnemyPlane < Entity
  attr_reader :spawn_x, :spawn_y

  def initialize(x = 0, y = 0)
    @pic = Gosu::Image.new("assets/images/enemyplane.png")
    @x = x
    @y = y
    @spawn_x = x
    @spawn_y = y
  end
end
