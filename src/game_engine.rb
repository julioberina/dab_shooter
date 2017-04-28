# The GameEngine's function is simply to handle game logic and return stuff
# to the UserInterface class
require_relative "bullet"
require_relative "nyan_cat"
require_relative "enemy_plane"

module Scene
  TITLE = 1
  MAIN = 3
end

class GameEngine
  attr_reader :background_image, :background_music, :scene, :frame,
  :cat, :enemy, :bframe
  attr_accessor :writer

  def initialize
    @background_image = Gosu::Image.new("assets/images/background.jpg", tileable: false)
    @background_music = Gosu::Song.new("assets/audio/hongkong97.wav")
    @writer = Gosu::Font.new(72, name: "assets/fonts/Capture_it.ttf")
    @scene = Scene::TITLE
    @frame = 0
    @bframe = 0
    @cat = NyanCat.new
    @enemy = EnemyPlane.new
  end

  def update
    # Update game entities
    @frame = (@frame + 1) % 60
    @bframe = (@bframe + 1) % 58
    if @frame >= 300 then @frame = 0 end
    if @bframe >= 300 then @bframe = 0 end
    @cat.update if @scene == Scene::MAIN

    # spwan enemies
    spawn_enemies
  end

  def button_up id
    if id == Gosu::KbReturn or id == Gosu::KbEnter
      if @scene == Scene::TITLE
        @scene = Scene::MAIN
        @background_image = []
        29.times do |i|
          @background_image << Gosu::Image.new("assets/images/frame_#{i}_delay-0.03s.png")
        end
        @writer = Gosu::Font.new(50, name: "assets/fonts/Roboto-Regular.ttf")
      end
    elsif id == Gosu::KbS or id == Gosu::KbW or id == Gosu::KbDown or id == Gosu::KbUp
      @cat.dy = 0 if @scene == Scene::MAIN
    elsif id == Gosu::KbA or id == Gosu::KbD or id == Gosu::KbLeft or id == Gosu::KbRight
      @cat.dx = 0 if @scene == Scene::MAIN
    elsif id == Gosu::KbSpace and @scene == Scene::MAIN
      bullet = Bullet.new(:right, @cat.x + 125, @cat.y - 16)
      if @cat.charged?
        bullet.sound_effect = Gosu::Sample.new("assets/audio/cometsound.wav")
      else
        bullet.sound_effect = Gosu::Sample.new("assets/audio/shoot.wav")
      end

      @cat.bullets << bullet.tap { |b| b.shoot(@cat.charge) }
      @cat.reset_charge
    end
  end

  def button_down id
    if id == Gosu::KbS or id == Gosu::KbDown
      (@cat.dy = 5 unless @cat.dy == 5) if @scene == Scene::MAIN
    elsif id == Gosu::KbW or id == Gosu::KbUp
      (@cat.dy = -5 unless @cat.dy == -5) if @scene == Scene::MAIN
    elsif id == Gosu::KbA or id == Gosu::KbLeft
      (@cat.dx = -5 unless @cat.dx == -5) if @scene == Scene::MAIN
    elsif id == Gosu::KbD or id == Gosu::KbRight
      (@cat.dx = 5 unless @cat.dx == 5) if @scene == Scene::MAIN
    elsif id == Gosu::KbSpace
      @cat.dc = 1
    end
  end

  def spawn_enemies

  end
end
