SplashMgr = class("SplashMgr",Class);
SplashMgr.speed = 100; 
function SplashMgr:Start(speed,pfn)

	self.speed = speed or 100;
	splash.populate(
		{
			-- {		
			-- 	image = love.graphics.newImage("assets/imgs/images/trees.png"),
			-- 	-- footer = "Look, some trees!",
			-- 	footer = "",
			-- 	speed = self.speed,
			-- 	duration = 2,
			-- },
			-- {		
			-- 	image = love.graphics.newImage("assets/imgs/images/rabbit.png"),
			-- 	-- footer = "There is a rabbit nearby...",
			-- 	footer = "",
			-- 	speed = self.speed,
			-- 	duration = 2,
			-- },
			-- {		
			-- 	image = love.graphics.newImage("assets/imgs/images/mushroom.png"),
			-- 	footer = "Who likes eating mushrooms!",
			-- 	-- footer = "",
			-- 	speed = self.speed,
			-- 	duration = 2,
			-- },
			{		
				image = love.graphics.newImage("assets/imgs/images/love-app-icon.png"),
				-- footer = "Powered by LÖVE framework",
				footer = "由LÖVE框架提供支持",
				-- footer = "",
				speed = self.speed,
				duration = 2,
			},
		}
	)
		
	splash.callback = pfn;
end 

function SplashMgr:update(dt)
	splash.update(dt)
	-- if splash.active() then 
	-- 	return 
	-- end
end  

function SplashMgr:draw()
	splash.draw()
	-- if splash.active() then 
	-- 	return 
	-- end
end 