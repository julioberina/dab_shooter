require_relative "entity"

class Bullet < Entity
  attr_accessor :orientation
  attr_reader :c_frame

  def initialize orientation, x, y
    @orientation = orientation
    @x = x
    @y = y
    @dx = 0
    @dy = 0
    @c_frame = 0
  end

  def update
    @x += @dx
    @y += @dy
    @c_frame = (@c_frame + 1) % 30
  end

  def shoot(charge = 0)
    if @orientation == :right
      @dx = 10
      if charge >= 179
        @pic = []
        1.upto(10).each { |i| @pic << Gosu::Image.new("assets/images/DabFrame#{i}.png") }
      else
        @pic = Gosu::Image.new("assets/images/dabbullet.png")
      end
    elsif @orientation == :left
      @dx = -20
    end
    @pic
  end

  def shot?
    (@dx == 0) ? false : true
  end
end
