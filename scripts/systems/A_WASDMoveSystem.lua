A_WASDMoveSystem = class("A_WASDMoveSystem",System)

A_WASDMoveSystem.tbPress = {};

function A_WASDMoveSystem:update(dt,actors)
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
function A_WASDMoveSystem:keypressed(actors,key)
    self.tbPress = self.tbPress or {};
    self.tbPress[key] = true;
    local actors = actors or {};
    if not next(actors) then
        return 
    end 
    for _,actor in ipairs(actors) do 
        local compo_WASDMove = actor:GetCompo("WASDMove");
        local compo_Direction = actor:GetCompo("Direction");
        if compo_WASDMove then
            if key == "w" or key == "up" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"up",1);
            elseif key == "a" or key == "left" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"left",1);
            elseif key == "s" or key == "down" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"down",1);
            elseif key == "d" or key == "right" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"right",1);
            end
        end 
    end
end

function A_WASDMoveSystem:keyreleased(actors,key)
    if self:NumKey() > 1 then 
        self.tbPress[key] = nil;
        local k = key;
        for i,v in pairs(self.tbPress) do 
            if v == true then 
                k = i;
                break;
            end 
        end
        self:keypressed(actors,k);
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
            if key == "w" or key == "up" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"up",2);
            elseif key == "a" or key == "left" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"left",2);
            elseif key == "s" or key == "down" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"down",2);
            elseif key == "d" or key == "right" then 
                Event:DoEvent(self, "EvtPlayerWASDMove", actor,"right",2);
            end
        end
    end

end

function A_WASDMoveSystem:NumKey()
    local index = 0;
    self.tbPress = self.tbPress or {};
    for i,v in pairs(self.tbPress) do 
        index = index + 1;
    end 
    return index;
end