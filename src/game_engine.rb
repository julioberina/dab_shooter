# The GameEngine's function is simply to handle game logic and return stuff
# to the UserInterface class
require_relative "bullet"
require_relative "nyan_cat"
require_relative "enemy_plane"
require_relative "trump"

module Scene
  TITLE = 1
  PREGAME = 2
  MAIN = 3
  GAME_OVER = 4
end

class GameEngine
  attr_reader :background_image, :background_music, :scene, :frame,
  :cat, :enemies, :bframe, :trump, :killed_enemies
  attr_accessor :writer

  def initialize
    @background_image = Gosu::Image.new("assets/images/background.jpg", tileable: false)
    @background_music = Gosu::Song.new("assets/audio/hongkong97.wav")
    @writer = Gosu::Font.new(72, name: "assets/fonts/Capture_it.ttf")
    @scene = Scene::TITLE
    @frame = 0
    @bframe = 0
    @cat = NyanCat.new
    @enemies = []
    @trump = nil

    @killed_enemies = 0
  end

  def update
    # Update game entities
    if @scene == Scene::MAIN
      @frame = (@frame + 1) % 60
      @bframe = (@bframe + 1) % 58
      if @frame >= 300 then @frame = 0 end
      if @bframe >= 300 then @bframe = 0 end
      @cat.update if @scene == Scene::MAIN

      if @killed_enemies < 100
        # spawn enemies
        spawn_enemy if @enemies.empty? or @enemies.last.x <= 550
        make_enemies_float unless @enemies.empty?
        move_enemies

        # Check bullet collision second time
        bullet_game_logic unless @enemies.empty? or @cat.bullets.empty?
      else
        until @enemies.empty?
          make_enemies_float
          move_enemies
          bullet_game_logic unless @enemies.empty? or @cat.bullets.empty?
        end

        # Bring out Trump
        @trump = Trump.new((550-165), 200) if @trump.nil?
        donald_bullet_logic
        donald_float

        # Check for Trump kill
        if @trump.health.zero?
          @scene = Scene::GAME_OVER
        end
      end
    end
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
      @cat.dc = 2
    end
  end

  # Spawn enemies
  def spawn_enemy
    enemy = EnemyPlane.new(700, (rand(450) + 41))
    enemy.dx = -2
    @enemies << enemy
  end

  # Move enemies
  def move_enemies
    unless @enemies.empty?
      @enemies.each { |enemy| enemy.x += enemy.dx unless enemy.nil? }
      if @enemies.first.x <= -120 then @enemies.shift end
    end
  end

  # Floating enemies (sin-based)
  def make_enemies_float
    @enemies.each do |enemy|
      enemy.y = enemy.spawn_y + (10 * Math::sin((@frame * 6) * Math::PI / 180.0)) unless enemy.nil?
    end
  end

  # Check if player bullet hits an enemy
  def bullet_game_logic
    # [28, 54] is the bullet y-range for collision purposes, x is simply to 64
    # 152, 95 is the charged bullet's width and height respectively

    # Check for dab bullet or charged bullet hitting an enemy
    @cat.bullets.length.times do |n|
      unless @cat.bullets[n].pic.is_a? Array
        @enemies.length.times do |i|
          if @cat.bullets[n] != nil and (@cat.bullets[n].x + 64) >= @enemies[i].x
            if (@cat.bullets[n].y + 54) >= @enemies[i].y and (@cat.bullets[n].y + 28) <= (@enemies[i].y + 72)
              @enemies[i] = nil
              @cat.bullets[n] = nil
              @killed_enemies += 1
            end
          end
        end
      else
        @enemies.length.times do |i|
          if @cat.bullets[n] != nil and (@cat.bullets[n].x + 20) >= @enemies[i].x
            if (@cat.bullets[n].y + 95) >= @enemies[i].y and @cat.bullets[n].y <= (@enemies[i].y + 72)
              @enemies[i] = nil
              @killed_enemies += 1
            end
          end
        end
      end
    end

    @enemies.reject! &:nil? # Remove all nil values in Array
    @cat.bullets.reject! &:nil? unless @cat.bullets.empty? # Remove all nil values in Array
  end

  # Functions for once Trump comes out
  def donald_bullet_logic
    @cat.bullets.length.times do |n|
      if @cat.bullets[n] != nil and @cat.bullets[n].pic.is_a? Array
        if (@cat.bullets[n].x - 150) >= @trump.x
          if (@cat.bullets[n].y + 95) >= @trump.y and @cat.bullets[n].y <= (@trump.y + 200)
            @trump.health -= 1 unless @cat.bullets[n].marked?
            @cat.bullets[n].mark
          end
        end
      end
    end

    @cat.bullets.reject! &:nil? unless @cat.bullets.empty?
  end

  def donald_float
    @trump.y = @trump.spawn_y + (150 * Math::sin((@frame * 6) * Math::PI / 180.0))
  end
end
