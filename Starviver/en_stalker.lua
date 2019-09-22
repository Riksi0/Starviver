--------------------------------------------------------------------------------
--
-- Controls the basic, common logic of enemies
--
-- en_stalker.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene")
local player = require("spaceship")

stalker = {};
stalker.__index = stalker;
------------------------------ Public Functions --------------------------------

function stalker.new( _x, _y, index, _layer)
  local instance = {
  }

  instance.x = _x or math.random(-1000, 1000);
  instance.y = _y or math.random(-1000, 1000);
  instance.layer = _layer or 1;
  instance.index = index;

  instance.width = 160
  instance.height = 200
  instance.sprite = display.newRect(instance.x, instance.y, instance.width, instance.height);
  instance.speed = 0;

  --Used for shaking the object when height
  instance.shakeMax = 15;
  instance.shakeAmount = 0;
  instance.isShaking = false;

  instance.properties = {
    enemyType = 1, --stalker
    canShoot = true,
    maxSpeed = 42,
    acceleration = 1,
    health = 30,
    name = "Perseguidores",
    description = "Rápidos e leves, os Perseguidores são caçadores perigosos que estão sempre dispostos a adicionar uma nova estrela no universo"
  }

  return setmetatable(instance, stalker);
end

function stalker:getSpeed()
  return self.speed;
end

function stalker:getX()
  return self.x;
end

function stalker:getY()
  return self.y;
end

function stalker:getDisplayObject()
  return self.sprite;
end

function stalker:getDiscription(  )
  return self.properties.description;
end

function stalker:enableShake(  )
  self.isShaking = true;
end

function stalker:shake(  )
  if (self.isShaking == true) then
    if(self.shakeMax <= 1) then
      self.shakeMax = 15;
      self.isShaking = false;
    else
      self.shakeAmount = math.random(self.shakeMax);
      self.x = self.x + math.random(-self.shakeAmount, self.shakeAmount);
      self.y = self.y + math.random(-self.shakeAmount, self.shaleAmount);
      self.shakeMax = self.shakeMax - 0.85;
    end
  end       
end

function stalker:init()
  self.sprite.fill = {type = "image", filename = "imgs/stalker.png"}
  scene:addObjectToScene(self.sprite, self.layer);
end

function stalker:run()
  if (math.abs(player:getX() - self.x) < 50 or math.abs(player:getY() - self.y) < 50) then
    self.isShaking = true;
  end

  self.shake();
  self.sprite.x = self.x;
  self.sprite.y = self.y;
end

return stalker;