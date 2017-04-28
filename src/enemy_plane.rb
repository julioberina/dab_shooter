require_relative "entity"

class EnemyPlane < Entity
  def initialize
    @pic = Gosu::Image.new("assets/images/enemyplane.png")
  end
end
