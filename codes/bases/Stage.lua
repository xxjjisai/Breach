Stage = class("Stage",Class)

Stage.actors = {};
Stage.systems = {};

function Stage:init()
    self.actors = {};
    self.systems = {};
end

-- 向舞台添加演员
function Stage:AddActor(actor)
    if not actor then 
        error("stage add actor faild!");
        return 
    end 
    self.actors[#self.actors + 1] = actor;
end

-- 向舞台添加演员控制
function Stage:AddSystem(system)
    if not system then 
        error("stage add system faild!");
        return 
    end
    self.systems[#self.systems + 1] = system;
end

function Stage:Destory()
    for _,actor in ipairs(self.actors) do 
        if actor then 
            local compo_BumpWorld = actor:GetCompo("BumpWorld");
            if compo_BumpWorld then 
                if compo_BumpWorld:GetData("bInWorld") then 
                    -- 从世界中移除
                    local bwsys = sysmgr:GetSystem("BumpWorldSystem");
                    if bwsys then  
                        bwsys:RemoveInWorld(actor);
                    end
                end
            end
            actor:Destory()
        end 
    end
    self.actors = {};
    self.systems = {};
end

function Stage:start()
    for _,sys in ipairs(self.systems) do 
        if sys.init then 
            sys:start(self.actors);
        end
    end
end

function Stage:update(dt)
    for _,sys in ipairs(self.systems) do 
        if sys.update then 
            sys:update(dt,self.actors);
        end
    end
end

function Stage:draw()
    for _,sys in ipairs(self.systems) do 
        if sys.draw then 
            sys:draw(self.actors);
        end
    end
end

function Stage:draw2()
    for _,sys in ipairs(self.systems) do 
        if sys.draw2 then 
            sys:draw2(self.actors);
        end
    end
end

function Stage:keypressed(key)
    for _,sys in ipairs(self.systems) do 
        if sys.keypressed then 
            sys:keypressed(self.actors,key)
        end
    end
end

function Stage:keyreleased(key)
    for _,sys in ipairs(self.systems) do 
        if sys.keyreleased then 
            sys:keyreleased(self.actors,key)
        end
    end
end

function Stage:mousepressed(x,y,button)
    for _,sys in ipairs(self.systems) do 
        if sys.mousepressed then 
            sys:mousepressed(self.actors,x,y,button)
        end
    end
end