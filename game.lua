Game = class("Game",Class)

-- 初始化
function Game:init()
    -- 随机数种子
    math.randomseed(os.time());
    _G.bPause  =  option.bPause  or false;-- 暂停
    _G.bDebug  =  option.bDebug  or false;-- 调试
    _G.bReport =  option.bReport or false;-- 概要分析
    _G.bStats  =  option.bStats  or false;-- FPS
    -- 初始化管理器
    _G.assmgr = AssetsMgr:new();
    _G.splmgr = SplashMgr:new();
    _G.scemgr = SceneMgr :new();
    _G.actmgr = ActorMgr :new();
    _G.sysmgr = SystemMgr:new();
    _G.cammgr = CameraMgr:new();
    -- 摄像机
    cammgr:SetCameraStyle(0.09,"LOCKON");
    -- 配置
    self:ConfigChange();
    -- 概要分析（一般情况下不要用，会影响帧率）
    -- love.profiler.hookall("Lua");
    -- love.profiler.start();
    -- 初始加载 
    option.sState = option.tbState[1];
    assmgr:Start(option.assetsoffset,function ()
        if option.bSplash then 
            option.sState = option.tbState[3];
            splmgr:Start(0.5,function ()
                option.sState = option.tbState[2]; 
                scemgr:CreateScene();
            end) 
        else 
            option.sState = option.tbState[2];
            scemgr:CreateScene();
        end
    end) 
end

-- 更新
love.frame = 0
function Game:update(dt)
    love.window.setTitle( string.format("Elixir fps:%s scene:%s", tostring(love.timer.getFPS( )),scemgr.active ))
    if bReport then 
        -- love.frame = love.frame + 1
        -- if love.frame%100 == 0 then
        --   love.report = love.profiler.report('time', 20);
        --   love.profiler.reset();
        -- end
    end
    if option.sState == option.tbState[1] then 
        if not option.bLoaded then 
            assmgr:update(dt);
        end
    end
    if option.sState == option.tbState[3] then 
        splmgr:update(dt);
    end
    if bPause then 
        return;
    end
    if option.sState == option.tbState[2] then 
        cammgr:update(dt); 
        local scene = scemgr:GetScene();
        if not scene then 
            return
        end
        scene:update(dt);
    end
end

-- 渲染
function Game:draw()
    love.graphics.push();
    love.graphics.scale(windows.scaling, windows.scaling);
    if bDebug then 
        
    end
    if option.sState == option.tbState[1] then 
        if not option.bLoaded then 
            assmgr:draw();
        end
    end

    if option.sState == option.tbState[3] then 
        splmgr:draw();
    end

    if option.sState == option.tbState[2] then 
        local scene = scemgr:GetScene();
        cammgr:Attach(); 
        if scene then 
            scene:draw_in();
        end
        cammgr:Detach();
        if scene then 
            scene:draw_out();
        end
    end

    if bReport then 
        -- love.graphics.setColor(0.41,1,0.41,0.49);
        -- love.graphics.setFont(assmgr:GetFont(11));
        -- love.graphics.print(love.report or "Please wait...",10,120);
        -- love.graphics.setColor(1,1,1,1);
    end
    if bStats then 
        love.graphics.setColor(0.41,1,0.41,0.49);
        love.graphics.setFont(assmgr:GetFont(11));
        local stats = love.graphics.getStats();
        love.graphics.print("GPU memory: "..(math.floor(stats.texturememory/1.024)/1000)..
        " Kb\nLua Memory: "..(math.floor(collectgarbage("count")/1.024)/1000).." Kb\nFonts: "..
        stats.fonts.."\nCanvas Switches: "..stats.canvasswitches.."\nCanvases: "..stats.canvases..
        "\nFPS: "..love.timer.getFPS(), 10, 10);
        love.graphics.setColor(1,1,1,1);
    end

    love.graphics.pop();
end

-- 鼠标单击
function Game:mousepressed(x,y,button)
    if button == 2 then 
        if option.sState == option.tbState[2] then 
            scemgr:Next();
        end
    end
    if option.sState == option.tbState[2] then 
        local scene = scemgr:GetScene();
        if scene then 
            scene:mousepressed(x,y,button);
        end
    end
end


function Game:keyreleased(key)
    if option.sState == option.tbState[2] then 
        local scene = scemgr:GetScene();
        if not scene then 
            return
        end 
        scene:keyreleased(key);
    end
end

-- 键盘单击（重复输入）
function Game:keypressed(key)
    if key == "escape" then  
        --todo... 保存数据
        love.event.quit();
    end 
    if key == "r" then 
        love.window.setMode( 960, 640,{resizable=true } );
        self:ConfigChange();
    end 
    if key == "o" then 
        Camera.scale = 1;
    end 
    if key == "1" then 
        if bDebug == true then 
            bDebug = false;
        elseif bDebug == false then 
            bDebug = true; 
        end 
    end 

    if key == "2" then 
        if bStats == true then 
            bStats = false;
        elseif bStats == false then 
            bStats = true;
        end 
    end 

    if key == "3" then 
        if bReport == true then 
            bReport = false;
        elseif bReport == false then 
            bReport = true;
        end 
    end 

    if key == "4" then 
        love.mouse.setVisible(not love.mouse.isVisible())
    end 

    if key == "5" then 
        bPause = true;
        debug.debug();
    end

    if option.sState == option.tbState[2] then 
        local scene = scemgr:GetScene();
        if not scene then 
            return
        end 
        scene:keypressed(key);
    end
end

function Game:ConfigChange(pw,ph)

    local gw = pw or love.graphics.getWidth();
    local gh = ph or love.graphics.getHeight();

    local os = love._os;
    local basew = option.windows[os].w;
    local baseh = option.windows[os].h;

    local interface_scaling = 1;
    local world_scaling = 1;
    local interface = option.interface_scaling * interface_scaling;
    local scaling = option.world_scaling * (gw / basew) * world_scaling;
    self:trace(1,scaling);

    _G.windows = {};
    _G.windows.w = gw * (1 / scaling);
	_G.windows.h = gh * (1 / scaling);
    _G.windows.scaling = scaling;

    -- self:trace(1,table.show(windows,"windows"));

    self:trace(1,gw,gw * (1 / scaling))
    self:trace(1,gh,gh * (1 / scaling))

end

function Game:resize(w, h)
    self:ConfigChange(w, h);
end

function Game:focus(f)
    if f then
        -- self:trace(1,"Window is focused.") 
        bPause = false;
      else
        -- self:trace(1,"Window is not focused.") 
        bPause = true;
      end
end

function Game:mousefocus(f,a,b,c)
    if not f then
        -- self:trace(1,"LOST MOUSE FOCUS")
        -- bPause = true;
    else
        -- self:trace(1,"GAINED MOUSE FOCUS")
        -- bPause = false;
    end
end