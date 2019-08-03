BumpWorldSystem = class("BumpWorldSystem",System)
BumpWorldSystem.world = bump.newWorld(option.nWorldCellSize);
function BumpWorldSystem:start(actors)
    self.world = bump.newWorld(option.nWorldCellSize);
    local actors = actors or {};
    if not next(actors) then 
        return 
    end
    for _,actor in ipairs(actors) do 
        local compo_BumpWorld = actor:GetCompo("BumpWorld");
        if compo_BumpWorld then
            compo_BumpWorld:SetData("bInWorld",false)
            self:AddInWorld(actor);
        end
    end
end

function BumpWorldSystem:update(dt,actors)
    local actors = actors or {};
    if not next(actors) then 
        return 
    end
    for _,actor in ipairs(actors) do 
        local compo_BumpWorld = actor:GetCompo("BumpWorld");
        if compo_BumpWorld then
            self:ChangeInWorld(actor);
            self:MoveInWord(actor);
        end
    end
end

function BumpWorldSystem:draw(actors)
    if bDebug then 
        bump_debug.draw(self.world)
    end
end

function BumpWorldSystem:AddInWorld(actor)
    local compo_BumpWorld = actor:GetCompo("BumpWorld");
    if compo_BumpWorld:GetData("bInWorld") then
        self:trace(3,"actor already in world!")
        return 
    end;
    local compo_Position = actor:GetCompo("Position");
    local compo_Size = actor:GetCompo("Size");
    local x = compo_Position:GetData("x");
    local y = compo_Position:GetData("y");
    local w = compo_Size:GetData("x");
    local h = compo_Size:GetData("y");
    self.world:add(actor,x,y,w,h);
    compo_BumpWorld:SetData("bInWorld",true)
end

function BumpWorldSystem:ChangeInWorld(actor)
    local compo_Position = actor:GetCompo("Position");
    local compo_Size = actor:GetCompo("Size");
    local x = compo_Position:GetData("x");
    local y = compo_Position:GetData("y");
    local w = compo_Size:GetData("x");
    local h = compo_Size:GetData("y");
    self.world:update(actor,x,y,w,h);
end

function BumpWorldSystem:MoveInWord(actor)
    local compo_Position = actor:GetCompo("Position");
    local x = compo_Position:GetData("x");
    local y = compo_Position:GetData("y");
    local actualX, actualY, cols, len = self.world:move(actor,x,y);
    compo_Position:SetData("x",actualX);
    compo_Position:SetData("y",actualY);
end

function BumpWorldSystem:RemoveInWorld(actor)
    if self.world:hasItem(actor) then 
        self.world:remove(actor);
    end
end