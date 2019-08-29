ActorMgr = class("ActorMgr",Class)

function ActorMgr:CreateActor(cls,actorcfg)
    local actor = _G[cls]:new();
    for compocls,compocfg in pairs(actorcfg) do
        local compo = Compo:new(compocls,compocfg);
        actor:AddCompo(compocls,compo);
    end
    return actor;
end

function ActorMgr:GetCurActorList()
    local scene = scemgr:GetScene();
    if not scene then 
        return
    end
    local stage = scene:GetStage();
    if not stage then 
        return
    end
    return stage.actors;
end


function ActorMgr:GPA()
    local scene = scemgr:GetScene();
    if not scene then 
        return
    end
    local stage = scene:GetStage();
    if not stage then 
        return
    end
    for _,actor in ipairs(stage.actors) do 
        if actor.sTag == "Player" then 
            return actor
        end
    end
end

function ActorMgr:GMap()
    local scene = scemgr:GetScene();
    if not scene then 
        return
    end
    local stage = scene:GetStage();
    if not stage then 
        return
    end
    for _,actor in ipairs(stage.actors) do 
        if actor.sTag == "Map" then 
            return actor
        end
    end
end

function ActorMgr:GetActorByName(sName)
    local scene = scemgr:GetScene();
    if not scene then 
        return
    end
    local stage = scene:GetStage();
    if not stage then 
        return
    end
    for _,actor in ipairs(stage.actors) do 
        if actor.sName == sName then 
            return actor
        end
    end
end

function ActorMgr:GetActorListByTags(sTag)
    local tbTags = {};
    local scene = scemgr:GetScene();
    if not scene then 
        return
    end
    local stage = scene:GetStage();
    if not stage then 
        return
    end
    for _,actor in ipairs(stage.actors) do 
        if actor.sTag == sTag then 
            table.insert(tbTags,actor);
        end
    end
    return tbTags;
end

function ActorMgr:RemoveActor(id)
    if type(id) ~= "number" then 
        return 
    end 
    local scene = scemgr:GetScene();
    if not scene then 
        return
    end
    local stage = scene:GetStage();
    if not stage then 
        return
    end
    local index = 0;
    for i,act in ipairs(stage.actors) do 
        if act.id == id then 
            index = i;
            local compo_BumpWorld = act:GetCompo("BumpWorld");
            if compo_BumpWorld then 
                if compo_BumpWorld:GetData("bInWorld") then 
                    -- 从世界中移除
                    local bwsys = sysmgr:GetSystem("A_BumpWorldSystem");
                    if bwsys then  
                        bwsys:RemoveInWorld(act);
                    end
                end
                break;
            end 
        end
    end
    if index ~= 0 then 
        table.remove(stage.actors,index);
    end
end

function ActorMgr:GetActorNameList()
    local scene = scemgr:GetScene();
    if not scene then 
        return
    end
    local stage = scene:GetStage();
    if not stage then 
        return
    end
    local str = "";
    for _,actor in ipairs(stage.actors) do 
        str = str.. " " ..actor.sName;
    end
    self:trace(1,str)
end

function ActorMgr:AddActorInCurStage(actor)
    local scene = scemgr:GetScene();
    if not scene then 
        return
    end
    local stage = scene:GetStage();
    if not stage then 
        return
    end
    stage:AddActor(actor);
end