# The UserInterface class is responsible for displaying things to the screen

require_relative "game_engine.rb"

class UserInterface < Gosu::Window
  def initialize
    super 800, 600
    self.caption = "Yolocaust"
    @engine = GameEngine.new
    @engine.background_music.play true
  end

  # Let GameEngine run game logic
  def update
    @engine.update
  end

  def draw
    case @engine.scene
    when Scene::TITLE
      title_screen
    when Scene::MAIN
      main_screen
    end
  end

  def button_up id
    @engine.button_up id
  end

  def button_down id
    @engine.button_down id
  end

  private
  # Methods that draw specific entities to screen based on the scene

  def title_screen
    @engine.background_image.draw 0, 0, 0, 0.444, 0.435

    # blinking effect
    if @engine.frame < 30
      @engine.writer.draw "Press Enter to Play", 155, 390, 0, 0.75, 0.5, Gosu::Color::WHITE
    end
  end

  def main_screen
    @engine.background_image[@engine.bframe / 2].draw 0, 0, 0, 1.6, 1.2
    @engine.cat.pic[@engine.cat.frame / 4].draw(
    @engine.cat.x, @engine.cat.y, @engine.cat.z,
    @engine.cat.scale_x, @engine.cat.scale_y) # Draw the cat

    # Draw the cat's bullets if there are any
    unless @engine.cat.bullets.empty?
      @engine.cat.bullets.each do |bullet|
        if bullet.pic.is_a? Array
          bullet.pic[bullet.c_frame / 10].draw(bullet.x - 300, bullet.y, 0)
        else
          bullet.pic.draw bullet.x, bullet.y, 0
        end
      end
    end
  end
end
