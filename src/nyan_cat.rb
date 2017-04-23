require_relative "entity"

class NyanCat < Entity
  attr_accessor :charge, :dc

  def initialize
    @frame = 0
    @pic = []
    1.upto(9).each { |i| @pic << Gosu::Image.new("assets/images/nyancat#{i}.png") }
    @x, @y, @z = [0, 0, 0]
    @dc = 0
    @charge = 0
    @dx, @dy = [0, 0]
    @scale_x = 3.5
    @scale_y = 3
    @bullets = []
  end

  def reset_charge
    @dc = 0
    @charge = 0
  end

  def update
    @frame = (@frame + 1) % 32 # change cat picture
    @x += @dx
    @y += @dy
    @charge += @dc
    @dy = 0 if @y <= 0 or @y >= 550
    @dx = 0 if @x <= 0 or @x >= 200

    # Update bullets
    unless @bullets.empty?
      @bullets.each { |bullet| bullet.update }
      if @bullets.first.pic.is_a? Array and @bullets.first.x > 1200
         @bullets.shift
       elsif @bullets.first.pic.is_a? Gosu::Image and @bullets.first.x > 800
         @bullets.shift
       end
    end
  end

  def charged?
    @charge >= 179
  end
end
