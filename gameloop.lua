-- The game logic and loop
local spaceship = require("spaceship")
local joystick = require("joystick")
local button = require("button")
local physics = require("physics")
local scene = require("scene")
local enemies = require("enemies")
local bullets = require("bullets")
local score = require("score")

local gameloop = {};
local gameloop_mt = {};
local gameState;
local player;
local stick;
local fireBtn;
local testEn;
local enemy;

--[[  GameStates
	0 = not initialized
	1 = main menu
	2 = gameplay
	3 = pause menu
]] 


-- Runs once to initialize the game
-- Runs everytime the game state changes
function gameloop:init()
	math.randomseed(os.time());
	system.activate("multitouch")
	native.setProperty("androidSystemVisibility", "immersiveSticky");
  physics.setDrawMode("hybrid");

	--sets gamestate
	gameState = 2;

	--creates instances of classes
	enemy = enemies.new();
	player = spaceship.new(0, 0, 0.75)
	
	--initializes instances
	scene:init(1)
	player:init();

	-- Spawns in HUD and Controls
	actualScore = display.newText("0", 1200, 300, "Arial", 72);
	stick = joystick.new(1.125 * display.contentWidth / 8, 6 * display.contentHeight / 8);
	fireBtn = button.new(1.7 * (display.contentWidth / 2), 1.5 * (display.contentHeight / 2), display.contentWidth/17, display.contentWidth/17, 255, 45, 65);

	fireBtn:init();
	stick:init();
end

local enemyTimer = 0;
-- Runs continously, but with different code for each different game state
function gameloop:run()	
  
  local enemyCount = 0;
	actualScore.text = score:get();

  player:run(); --runs player controls
  if (fireBtn:isPressed() == true) then
    player:setIsShooting(true);
  else
    player:setIsShooting(false);
  end

  --player:debug();

  --runs logic behind enemies
  for i = 1, table.getn(enemy:get()) do
    for j = 1, table.getn(enemy:get(i)) do
      if (enemy:get(i,j) == nil) then break
      elseif (enemy:get(i,j).isDead == true) then
        enemy:get(i,j):kill();
        table.remove(enemy:get(i), j);
      else
        enemy:get(i, j):run();
        enemy:get(i, j):runCoroutine();
        enemyCount = enemyCount + 1;
      end
    end
  end

  if (enemyTimer < 30) then
    enemyTimer = enemyTimer + 1;
  else
    enemyTimer = 0;
    if(enemyCount < 25) then
      enemy:spawn(math.random(1, table.getn(enemy:get())), math.random(player:getX()-5000, player:getX()+5000), math.random(player:getY()-5000, player:getY()+5000));
    end
  end
  print(enemyCount)
end

return gameloop;