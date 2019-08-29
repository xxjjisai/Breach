
function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
	love.graphics.clear()
    love.graphics.present()
    
    love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	love.graphics.setLineStyle('smooth')

    require("option");
    require("include");
    
    _G.loader     = require('lib/love-loader');
    _G.splash     = require('lib/lovesplash');
    _G.Camera     = require('lib/Camera')();
    _G.Timer      = require('lib/Timer')();
    _G.Tween      = require('lib/tween/tween');
    _G.bump       = require('lib/bump');
    _G.bump_debug = require('lib/bump_debug');
    _G.class      = require('lib/middleclass');

    local libs = 
    {
        'utils',
        'saved',
        'functions',
    }
    for _,cfg in ipairs(libs) do
        require('lib/'..cfg);
    end 
    local scenescfg = include.scenes;
    for _,cfg in ipairs(scenescfg) do 
        require("configs/scenes/"..cfg);
    end
    local cfgs = include.globalcfg;
    for _,cfg in ipairs(cfgs) do 
        require("configs/globals/"..cfg);
    end
    local cfgs = include.assestscfg;
    for _,cfg in ipairs(cfgs) do 
        require("configs/assests/"..cfg);
    end
    local bases = include.bases;
    for _,cls in ipairs(bases) do 
        require("codes/bases/"..cls);
    end
    local mgrs = include.mgrs;
    for _,cls in ipairs(mgrs) do 
        require("codes/mgrs/"..cls);
    end
    local ecs = include.ecs;
    local entitys = include.ecs.entitys;
    for _,cls in ipairs(entitys) do 
        require("scripts/entitys/"..cls);
    end
    local stages = include.ecs.stages;
    for _,cls in ipairs(stages) do 
        require("scripts/stages/"..cls);
    end
    local systems = include.ecs.systems;
    for _,cls in ipairs(systems) do 
        require("scripts/systems/"..cls);
    end
    require("game")
    _G.game = Game:new();
end

function love.update(dt)
    Timer:update(dt)
    game:update(dt)
    Tween:update(dt)
end

function love.draw() 
    game:draw()
end

function love.mousepressed(x,y,button)
    game:mousepressed(x,y,button)
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.keyreleased( key )
    game:keyreleased(key)
end

function love.resize(w, h)
    -- print(("Window resized to width: %d and height: %d."):format(w, h))
    game:resize(w, h)
end

function love.focus(f)
    game:focus(f) 
end

function love.mousefocus(f)
    game:mousefocus(f) 
end

function love.run()

    local min = math.min
	if love.math then
		love.math.setRandomSeed(os.time())
		for i = 1, 3 do love.math.random() end
	end

	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
    local dt = 0
    local min = math.min
 
	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
        if love.timer then 
            love.timer.step() 
            dt = min(love.timer.getDelta(), 0.05)
        end
 
		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())
 
			if love.draw then love.draw() end
 
			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end
end