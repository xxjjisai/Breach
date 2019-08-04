WASDMoveSystem = class("WASDMoveSystem",System)

WASDMoveSystem.tbPress = {};

function WASDMoveSystem:update(dt,actors)
    local actors = actors or {};
    if not next(actors) then
        return 
    end 
    for _,actor in ipairs(actors) do 
        local compo_WASDMove = actor:GetCompo("WASDMove");
        if compo_WASDMove then
            local compo_Position = actor:GetCompo("Position");
            local compo_Speed = actor:GetCompo("Speed");
            local compo_Direction = actor:GetCompo("Direction");
            if love.keyboard.isDown("w","up") then
                compo_Direction:SetData("y",-1);
            end
            if love.keyboard.isDown("a","left") then
                compo_Direction:SetData("x",-1);
            end
            if love.keyboard.isDown("s","down") then
                compo_Direction:SetData("y",1);
            end
            if love.keyboard.isDown("d","right") then
                compo_Direction:SetData("x",1);
            end
            compo_Position:SetData("x",compo_Position:GetData("x") + (compo_Speed:GetData("speed") * dt) * compo_Direction:GetData("x"));
            compo_Position:SetData("y",compo_Position:GetData("y") + (compo_Speed:GetData("speed") * dt) * compo_Direction:GetData("y"));
            compo_Direction:SetData("x",0);
            compo_Direction:SetData("y",0);
        end 
    end
end
function WASDMoveSystem:keypressed(actors,key)
    self.tbPress = self.tbPress or {};
    self.tbPress[key] = true;
    local actors = actors or {};
    if not next(actors) then
        return 
    end 
    for _,actor in ipairs(actors) do 
        local compo_WASDMove = actor:GetCompo("WASDMove");
        if compo_WASDMove then
            if key == "w" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"up",1);
            elseif key == "a" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"left",1);
            elseif key == "s" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"down",1);
            elseif key == "d" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"right",1);
            end
        end 
    end
end

function WASDMoveSystem:keyreleased(actors,key)
    if self:NumKey() > 1 then 
        self.tbPress[key] = nil;
       return;
    end 
    self.tbPress[key] = nil;
    local actors = actors or {};
    if not next(actors) then
        return 
    end 
    for _,actor in ipairs(actors) do 
        local compo_WASDMove = actor:GetCompo("WASDMove");
        if compo_WASDMove then
            if key == "w" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"up",2);
            elseif key == "a" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"left",2);
            elseif key == "s" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"down",2);
            elseif key == "d" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"right",2);
            end
        end
    end
end

function WASDMoveSystem:NumKey()
    local index = 0;
    self.tbPress = self.tbPress or {};
    for i,v in pairs(self.tbPress) do 
        index = index + 1;
    end 
    return index;
end