# The UserInterface class is responsible for displaying things to the screen

require_relative "game_engine.rb"

class UserInterface < Gosu::Window
  def initialize
    super 800, 600
    self.caption = "Dab Shooter"
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
    when Scene::PREGAME
      pregame_screen
    when Scene::MAIN
      main_screen
    when Scene::GAME_OVER
      game_over_screen
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
    @engine.background_image.draw 0, 0, 0, 4.44, 3.35

    @engine.writer.draw "Dab Shooter", 200, 30, 0, 1, 0.7, Gosu::Color::WHITE

    # blinking effect
    if @engine.frame < 30
      @engine.writer.draw "Press Enter to Play", 155, 420, 0, 0.75, 0.5, Gosu::Color::WHITE
    end
  end

  def pregame_screen
    @engine.writer.draw "In the year 3000, all but one human has died from the memepocalypse", 10, 10, 0, 0.3, 0.3, Gosu::Color::WHITE
    @engine.writer.draw "The only human being that has survived is Donald Trump,", 10, 40, 0, 0.3, 0.3, Gosu::Color::WHITE
    @engine.writer.draw "Known among the memes, particularly United Airlines ones,", 10, 70, 0, 0.3, 0.3, Gosu::Color::WHITE
    @engine.writer.draw "As the Benevolent Dictator of Memes, aka Badass Douchebag Motherfucker", 10, 100, 0, 0.3, 0.3, Gosu::Color::WHITE
    @engine.writer.draw "One meme, Nyan Cat, declined to join the Trump Troops", 10, 160, 0, 0.3, 0.3, Gosu::Color::WHITE
    @engine.writer.draw "And he is out to destroy UA flights and overthrow the BDM", 10, 190, 0, 0.3, 0.3, Gosu::Color::WHITE
    @engine.writer.draw "Gameplay Controls: ", 10, 250, 0, 0.3, 0.3, Gosu::Color::WHITE
    @engine.writer.draw "WASD - Movement (up, left, down, right)", 10, 280, 0, 0.3, 0.3, Gosu::Color::WHITE
    @engine.writer.draw "Spacebar (tap) - Shoot a dab", 10, 310, 0, 0.3, 0.3, Gosu::Color::WHITE
    @engine.writer.draw "Spacebar (hold for ~2 seconds) - Shoot a flaming dab", 10, 340, 0, 0.3, 0.3, Gosu::Color::WHITE
    @engine.writer.draw "Now that you're ready, press Enter to Play...", 10, 400, 0, 0.3, 0.3, Gosu::Color::WHITE
  end

  def main_screen
    @engine.background_image[@engine.bframe / 2].draw 0, 0, 0, 1.6, 1.2
    @engine.cat.pic[@engine.cat.frame / 4].draw(
    @engine.cat.x, @engine.cat.y, @engine.cat.z,
    @engine.cat.scale_x, @engine.cat.scale_y) # Draw the cat

    # Draw the enemy plane(s)
    unless @engine.enemies.empty?
      @engine.enemies.each { |enemy| enemy.pic.draw enemy.x, enemy.y, 0, 0.6, 0.6 }
    end

    # Draw Trump once he exists
    if @engine.trump
      @engine.writer.draw "Trump Health:  ", 10, 10, 0, 0.7, 0.5, Gosu::Color::WHITE
      @engine.writer.draw @engine.trump.health.to_s, 230, 10, 0, 0.7, 0.5, Gosu::Color::WHITE
      @engine.trump.pic.draw @engine.trump.x, @engine.trump.y, 0
    else
      # Track number of enemies killed
      @engine.writer.draw "Killed enemies:  ", 10, 10, 0, 0.7, 0.5, Gosu::Color::WHITE
      @engine.writer.draw @engine.killed_enemies.to_s, 210, 10, 0, 0.7, 0.5
    end

    # Draw the cat's bullets if there are any
    unless @engine.cat.bullets.empty?
      @engine.cat.bullets.each do |bullet|
        if bullet.pic.is_a? Array
          bullet.pic[bullet.c_frame / 10].draw(bullet.x - 300, bullet.y, 0)
          bullet.sound_effect.play(0.02, 5)
        else
          bullet.pic.draw bullet.x, bullet.y, 0
          bullet.mark if bullet == @engine.cat.bullets.first
          bullet.sound_effect.play(0.02, 5) if bullet.marked?
        end
      end
    end
  end

  def game_over_screen
    @engine.writer.draw "You did it! You defeated Trump!", 200, 25, 0, 0.4, 0.5, Gosu::Color::WHITE
    @engine.america.draw 140, 130, 0
    @engine.writer.draw "You made America great again!", 200, 500, 0, 0.4, 0.5, Gosu::Color::WHITE
  end
end
