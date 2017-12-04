states = {
  game = require "states.game",
  menu = require "states.menu",
  splash = require "states.splash",
  win = require "states.win",
  lose = require "states.lose",
}

libs = {
  gamestate = require"gamestate",
  splash = require"splash",
}

function love.load()
  libs.gamestate.registerEvents()
  libs.gamestate.switch(states.splash)
end

function love.keypressed(key)
  if key == "`" and love.keyboard.isDown("lshift") then
    debug_mode = not debug_mode
  end
end
