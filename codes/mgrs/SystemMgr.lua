SystemMgr = class("SystemMgr",Class)

function SystemMgr:CreateSystem(cls,systemfg)
    local sys = _G[cls]:new();
    return sys;
end

function SystemMgr:GetSystem(cls)
    local scene = scemgr:GetScene();
    if not scene then
        return
    end
    local stage = scene:GetStage();
    if not stage then
        return
    end
    for _,system in ipairs(stage.systems) do 
        if system.class.name == cls then 
            return system
        end
    end
end