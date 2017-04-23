# Start the game by executing the UserInterface, which contains a GameEngine
# object
require "gosu"
require_relative "user_interface"

ui = UserInterface.new
ui.show
