local game = {}

function game:init()
  self.img = {
    table = love.graphics.newImage("assets/table.png"),
    baconman = love.graphics.newImage("assets/baconman.png"),
    baconman_bite = love.graphics.newImage("assets/baconman_bite.png"),
    monsters = {
      love.graphics.newImage("assets/monster0.png"),
      love.graphics.newImage("assets/monster1.png"),
      love.graphics.newImage("assets/monster2.png"),
      love.graphics.newImage("assets/monster3.png"),
      love.graphics.newImage("assets/monster4.png"),
      love.graphics.newImage("assets/monster5.png"),
    },
    pows = {
      love.graphics.newImage("assets/pow0.png"),
      love.graphics.newImage("assets/pow1.png"),
      love.graphics.newImage("assets/pow2.png"),
      love.graphics.newImage("assets/pow3.png"),
    },
    bg = love.graphics.newImage("assets/gamebg.png"),
    sky = love.graphics.newImage("assets/sky.png"),
  }
  self.target = 32
end

local function distance(a,b)
  return math.sqrt( (a.x - b.x)^2 + (a.y - b.y)^2 )
end

function game:keypressed(key)
  if key == "escape" then
    self.pause = not self.pause
  end
end

function game:add_monster()
  table.insert(self.monsters,{
    x = love.graphics.getWidth()/2+(love.graphics.getWidth()/2)*(math.random(0,1)*2-1),
    y = love.graphics.getHeight()/3,
    rad = 64,
    xoff = 128,
    img = self.img.monsters[math.random(#self.img.monsters)],
  })
end

function game:enter()
  self.monster_spawn = 10
  self.monster_spawn_min = 1
  self.pause = false
  self.health = 4
  self.health_max = 4
  self.score = 0
  self.hp = libs.shp.new{
    on = love.graphics.newImage("assets/health1.png"),
    off = love.graphics.newImage("assets/health0.png"),
  }
  self.hunger = libs.shp.new{
    on = love.graphics.newImage("assets/hunger1.png"),
    off = love.graphics.newImage("assets/hunger0.png"),
  }
  self.pows = {}
  self.monsters = {}
  self.mouth = {
    x = 325,
    y = 150,
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
    burned_time = 2,
    img = {
      raw = love.graphics.newImage("assets/bacon_raw.png"),
      cooked = love.graphics.newImage("assets/bacon_cooked.png"),
      burned = love.graphics.newImage("assets/bacon_burned.png"),
    },
  }
  table.insert(self.stoves,left_stove)
  local right_stove = {
    x = 550-106/2,
    y = 297-61/2,
    rad = 61/2,
    cook_time = 4,
    burn_time = 6,
    burned_time = 2,
    img = {
      raw = love.graphics.newImage("assets/bacon_raw.png"),
      cooked = love.graphics.newImage("assets/bacon_cooked.png"),
      burned = love.graphics.newImage("assets/bacon_burned.png"),
    },
  }
  table.insert(self.stoves,right_stove)
  self.speed = 250
  self.hands = {}
  local left_hand = {
    x = love.graphics.getWidth()/4,
    y = love.graphics.getHeight()/2,
    ox = 260,
    oy = 180,
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
    ox = 380,
    oy = 200,
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
  love.graphics.draw(self.img.sky)
  love.graphics.draw(self.img.bg)
  local baconman_img = self.img.baconman
  if self.baconman_bite and (self.baconman_bite*6)%1 > 0.5 then
    baconman_img = self.img.baconman_bite
  end

  local bx,by = 0,0
  if self.baconman_pain then
    bx = math.random(-self.baconman_pain*10,self.baconman_pain*10)
    by = math.random(-self.baconman_pain*10,self.baconman_pain*10)
  end

  love.graphics.draw(baconman_img,
    love.graphics.getWidth()/2+bx,by,
    0,1,1,self.img.baconman:getWidth()/2,0)
  for _,monster in pairs(self.monsters) do
    if monster.x < love.graphics.getWidth()/2 then
      love.graphics.draw(monster.img,monster.x-monster.img:getWidth(),0,0,-1,1,monster.img:getWidth(),0)
      if debug_mode then
        love.graphics.circle("line",monster.x-monster.xoff,monster.y,monster.rad)
      end
    else
      love.graphics.draw(monster.img,monster.x,0,0,1,1)
      if debug_mode then
        love.graphics.circle("line",monster.x+monster.xoff,monster.y,monster.rad)
      end
    end
    if debug_mode then
      love.graphics.line(monster.x,0,monster.x,love.graphics.getHeight())
    end
  end
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
    love.graphics.setLineWidth(32)
    love.graphics.setColor(245,243,27)
    love.graphics.circle("fill",hand.ox,hand.oy,16)
    love.graphics.line(hand.ox,hand.oy,hand.x,hand.y)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255,255,255)
    local img = hand.img.empty
    if hand.contains then img = hand.img[hand.contains] end
    local angle = math.atan2( hand.y - hand.oy, hand.x - hand.ox )+math.pi
    love.graphics.draw(img,hand.x,hand.y,
      angle,1,1,img:getWidth()/2,img:getHeight()/2)
    if debug_mode then
      love.graphics.circle("line",hand.x,hand.y,16)
      love.graphics.print(math.floor(hand.x)..","..math.floor(hand.y),hand.x,hand.y)
    end
  end
  for _,pow in pairs(self.pows) do
    love.graphics.draw(pow.img,pow.x,pow.y,pow.r,1,1,pow.img:getWidth()/2,pow.img:getHeight()/2)
  end
  if debug_mode then
    love.graphics.circle("line",self.mouth.x,self.mouth.y,self.mouth.rad)
  end
  self.hp:draw(0,0)
  self.hunger:draw(love.graphics.getWidth()-self.hunger:getWidth(),0)

  if self.pause then
    love.graphics.setColor(0,0,0,127)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    love.graphics.setColor(255,255,255)
    love.graphics.printf("PAUSED - GETTING BACON",
      0,love.graphics.getHeight()/2,love.graphics.getWidth(),"center")
  end

  if debug_mode then
    love.graphics.print("health: "..self.health.."/"..self.health_max.."\n"..
      "score: "..self.score.."/"..self.target)
  end
end

function game:update(dt)

  if self.pause then
    return
  end

  if self.baconman_pain then
    self.baconman_pain = self.baconman_pain - dt
    if self.baconman_pain <= 0 then
      self.baconman_pain = nil
    end
  end

  if self.baconman_bite then
    self.baconman_bite = self.baconman_bite - dt
    if self.baconman_bite <= 0 then
      self.baconman_bite = nil
    end
  end


  if debug_mode then
    self.hp.val = (self.hp.val + dt)%1
    self.hunger.val = (self.hunger.val + dt)%1
  else
    self.hp.val = self.health/self.health_max
    self.hunger.val = self.score / self.target
  end

  if self.score >= self.target then
    libs.gamestate.switch(states.win)
  end

  if self.score > 0 then
    local t = math.max(self.monster_spawn_min,self.monster_spawn)
    self.monster_timer = (self.monster_timer or math.random(t,t+3)  ) - dt
    if self.monster_timer <= 0 then
      self:add_monster()
      self.monster_timer = nil
    end
  end

  for ipow,pow in pairs(self.pows) do
    pow.dt = (pow.dt or 0) + dt
    pow.r = pow.r + dt
    if pow.dt > 1 then
      table.remove(self.pows,ipow)
    end
  end
  for imonster,monster in pairs(self.monsters) do
    if monster.x < love.graphics.getWidth()/2 then
      monster.x = monster.x + 100*dt
    else
      monster.x = monster.x - 100*dt
    end

    if math.abs(monster.x - love.graphics.getWidth()/2) < 8 then
      table.remove(self.monsters,imonster)
      self.health = self.health - 1
      self.baconman_pain = 2
      sfxplay("rawr")
      if self.health < 0 then
        libs.gamestate.switch(states.lose)
      end
    end

  end
  for _,stove in pairs(self.stoves) do
    if stove.contains == "raw" then
      stove.cook = (stove.cook or 0) + dt
      if stove.cook > stove.cook_time then
        stove.contains = "cooked"
        stove.cook = 0
        sfxplay("ding")
      end
    end
    if stove.contains == "cooked" then
      stove.burn = (stove.burn or 0) + dt
      if stove.burn > stove.burn_time then
        stove.contains = "burned"
        stove.burn = 0
        sfxplay("fart")
      end
    end
    if stove.contains == "burned" then
      stove.burn = (stove.burn or 0) + dt
      if stove.burn > stove.burned_time then
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
    if distance_to_bacon < self.bacon.rad and hand.contains == nil then
      hand.contains = "raw"
      sfxplay("bacon")
    end

    local distance_to_stove = math.huge
    local nearest_stove = nil
    for _,stove in pairs(self.stoves) do
      local d = distance(stove,hand)
      if d < distance_to_stove and d < stove.rad then
        distance_to_stove,nearest_stove = d,stove
      end
    end

    if hand.contains == "raw" and nearest_stove and nearest_stove.contains == nil then
      hand.contains = nil
      sfxplay("sizzle")
      nearest_stove.contains = "raw"
    end

    if hand.contains == nil  and nearest_stove and nearest_stove.contains == "cooked" then
      nearest_stove.contains = nil
      hand.contains = "cooked"
      sfxplay("yes")
    end

    local distance_to_mouth = distance(hand,self.mouth)
    if hand.contains == "cooked" and distance_to_mouth < self.bacon.rad then
      hand.contains = nil
      self.score = self.score + 1
      self.baconman_bite = 2
      self.monster_spawn = self.monster_spawn - 0.5
      sfxplay("omnomnom")
    end

    for imonster,monster in pairs(self.monsters) do
      local tpow = {
        x = monster.x+monster.xoff,
        y = monster.y,
      }
      if monster.x < love.graphics.getWidth()/2 then
        tpow.x = monster.x - monster.xoff
      end
      local d = distance(tpow,hand)
      if d < monster.rad then
        tpow.img = self.img.pows[math.random(#self.img.pows)]
        tpow.r = math.random(-30,30)/100*math.pi
        table.insert(self.pows,tpow)
        table.remove(self.monsters,imonster)
        sfxplay("awaywithyou")
      end
    end

  end
end

return game
