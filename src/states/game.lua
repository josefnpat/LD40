local game = {}

function game:init()
  self.img = {
    table = love.graphics.newImage("assets/table.png"),
  }
end

local function distance(a,b)
  return math.sqrt( (a.x - b.x)^2 + (a.y - b.y)^2 )
end

function game:enter()
  self.mouth = {
    x = love.graphics.getWidth()/2,
    y = love.graphics.getHeight()/4,
    rad = 16,
  }
  self.bacon = {
    x = 193-119/2,
    y = 347-86/2,
    rad = 86/2,
  }
  self.stoves = {}
  local left_stove = {
    x = 437-106/2,
    y = 297-61/2,
    rad = 61/2,
    cook_time = 4,
    burn_time = 6,
    img = {
      raw = love.graphics.newImage("assets/bacon_raw.png"),
      cooked = love.graphics.newImage("assets/bacon_cooked.png"),
    },
  }
  table.insert(self.stoves,left_stove)
  local right_stove = {
    x = 550-106/2,
    y = 297-61/2,
    rad = 61/2,
    cook_time = 4,
    burn_time = 6,
    img = {
      raw = love.graphics.newImage("assets/bacon_raw.png"),
      cooked = love.graphics.newImage("assets/bacon_cooked.png"),
    },
  }
  table.insert(self.stoves,right_stove)
  self.speed = 250
  self.hands = {}
  local left_hand = {
    x = love.graphics.getWidth()/4,
    y = love.graphics.getHeight()/2,
    ox = love.graphics.getWidth()*3/8,
    oy = love.graphics.getHeight()/2,
    movement = {"w","d","s","a"},
    img = {
      empty = love.graphics.newImage("assets/right_empty.png"),
      raw = love.graphics.newImage("assets/right_raw.png"),
      cooked = love.graphics.newImage("assets/right_cooked.png"),
    },
  }
  table.insert(self.hands,left_hand)
  local right_hand = {
    x = love.graphics.getWidth()*3/4,
    y = love.graphics.getHeight()/2,
    ox = love.graphics.getWidth()*5/8,
    oy = love.graphics.getHeight()/2,
    movement = {"up","right","down","left"},
    img = {
      empty = love.graphics.newImage("assets/left_empty.png"),
      raw = love.graphics.newImage("assets/left_raw.png"),
      cooked = love.graphics.newImage("assets/left_cooked.png"),
    },
  }
  table.insert(self.hands,right_hand)
end

function game:draw()
  love.graphics.draw(self.img.table)
  if debug_mode then
    love.graphics.circle("line",self.bacon.x,self.bacon.y,self.bacon.rad)
  end
  for _,stove in pairs(self.stoves) do
    if stove.contains then
      local img = stove.img[stove.contains]
      love.graphics.draw(img,stove.x,stove.y,0,1,1,img:getWidth()/2,img:getHeight()/2)
    end
    if debug_mode then
      love.graphics.circle("line",stove.x,stove.y,stove.rad)
    end
  end
  for _,hand in pairs(self.hands) do
    local img = hand.img.empty
    if hand.contains then img = hand.img[hand.contains] end
    local angle = math.atan2( hand.y - hand.oy, hand.x - hand.ox )+math.pi
    love.graphics.draw(img,hand.x,hand.y,
      angle,1,1,img:getWidth()/2,img:getHeight()/2)
    love.graphics.line(hand.ox,hand.oy,hand.x,hand.y)
    if debug_mode then
      love.graphics.circle("line",hand.x,hand.y,16)
      love.graphics.print(math.floor(hand.x)..","..math.floor(hand.y),hand.x,hand.y)
    end
  end
  love.graphics.circle("line",self.mouth.x,self.mouth.y,self.mouth.rad)
end

function game:update(dt)
  for _,stove in pairs(self.stoves) do
    if stove.contains == "raw" then
      stove.cook = (stove.cook or 0) + dt
      if stove.cook > stove.cook_time then
        stove.contains = "cooked"
        stove.cook = 0
      end
    end
    if stove.contains == "cooked" then
      stove.burn = (stove.burn or 0) + dt
      if stove.burn > stove.burn_time then
        stove.contains = nil
        stove.burn = 0
      end
    end
  end
  for _,hand in pairs(self.hands) do
    local mx,my = 0,0
    if love.keyboard.isDown(hand.movement[1]) then my = my - 1 end
    if love.keyboard.isDown(hand.movement[2]) then mx = mx + 1 end
    if love.keyboard.isDown(hand.movement[3]) then my = my + 1 end
    if love.keyboard.isDown(hand.movement[4]) then mx = mx - 1 end
    hand.x = hand.x + mx*self.speed*dt
    hand.x = math.max(0,math.min(love.graphics.getWidth(),hand.x))
    hand.y = hand.y + my*self.speed*dt
    hand.y = math.max(0,math.min(love.graphics.getHeight(),hand.y))
    local distance_to_bacon = distance(hand,self.bacon)
    if distance_to_bacon < self.bacon.rad then
      hand.contains = "raw"
    end
    local distance_to_stove = math.huge
    local nearest_stove = nil
    for _,stove in pairs(self.stoves) do
      local d = distance(stove,hand)
      if d < distance_to_stove and d < stove.rad then
        distance_to_stove,nearest_stove = d,stove
      end
    end
    if hand.contains == "raw" and nearest_stove then
      hand.contains = nil
      nearest_stove.contains = "raw"
    end
    if nearest_stove and nearest_stove.contains == "cooked" then
      nearest_stove.contains = nil
      hand.contains = "cooked"
    end
    local distance_to_mouth = distance(hand,self.mouth)
    if hand.contains == "cooked" and distance_to_mouth < self.bacon.rad then
      hand.contains = nil
    end

  end
end

function game:keypressed(key)
  if key == "`" and love.keyboard.isDown("lshift") then
    debug_mode = not debug_mode
  end
end

return game
