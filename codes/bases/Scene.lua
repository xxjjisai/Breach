Scene = class("Scene",Class)

Scene.stage = nil;
Scene.data = nil;

function Scene:init()
    self.stage = nil;
    self.data = nil;
end

-- 进入场景
function Scene:EnterScene(data)
    self.data = data or nil;
    self:CreateStage();
end 

-- 离开场景
function Scene:LeaveScene()
    self:DestoryStage();
end

-- 创建舞台
function Scene:CreateStage()
    local data = self.data;
    local stage = Stage:new();
    local actor_cfg = ActorCfg[scemgr.active] or Scene1.tbActors;
    if not actor_cfg then 
        self:trace(1,"there has no actor_cfg!");
        return
    end
    for _,sactcfg in ipairs(actor_cfg) do 
        local actorcfg = _G[sactcfg];
        for _,actcfg in ipairs(actorcfg) do 
            local cls = actcfg.sClassName;
            local sName = actcfg.sName;
            local sTag = actcfg.sTag or "";
            local actor = actmgr:CreateActor(cls,actcfg.tbCompo);
            actor.sName = sName;
            actor.sTag = sTag or nil;
            if actor.sTag == option.sCamera_FollowPlayer then 
                cammgr:SetFollowPlayer(actor)
            end 
            stage:AddActor(actor);
        end
    end 
    local system_cfg = SystemCfg[scemgr.active] or Scene1.tbSystems;
    if not system_cfg then 
        self:trace(1,"there has no system_cfg!");
        return
    end
    for cls,systemfg in pairs(system_cfg) do 
        local sys = sysmgr:CreateSystem(cls,systemfg);
        stage:AddSystem(sys);
    end 
    self.stage = stage;
end

-- 获取舞台实例
function Scene:GetStage()
    return self.stage or nil;
end

-- 销毁舞台
function Scene:DestoryStage()
    if not self.stage then  
        return;
    end 
    self.stage:Destory();
    self.stage = nil;
end

function Scene:update(dt)
    if not self.stage then 
        return
    end 
    self.stage:update(dt)
end 

function Scene:draw_in()
    if not self.stage then 
        return
    end 
    self.stage:draw()
end 

function Scene:draw_out()
    if not self.stage then 
        return
    end 
    self.stage:draw2()
end 

function Scene:keypressed(key)
    if not self.stage then 
        return
    end 
    self.stage:keypressed(key)
end 

function Scene:keyreleased(key)
    if not self.stage then 
        return
    end 
    self.stage:keyreleased(key)
end 

function Scene:mousepressed(x,y,button)
    if not self.stage then 
        return
    end 
    self.stage:mousepressed(x,y,button)
end 