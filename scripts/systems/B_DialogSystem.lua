B_DialogSystem = class("B_DialogSystem",System)

B_DialogSystem.bDialogStart = false;
B_DialogSystem.sDialogContent = "";

function B_DialogSystem:keypressed(actors,key)
    local actors = actors or {};
    if not next(actors) then
        return;
    end
    for _,actor in ipairs(actors) do 
        local compo_Activate = actor:GetCompo("Activate");
        if compo_Activate then
            local bActivate = compo_Activate:GetData("bActivate");
            if bActivate then 
                if key == "j" then 
                    self.bDialogStart = true;
                    self.sDialogContent = "你充满了决心";
                end
            end
        end
    end
end

function B_DialogSystem:keyreleased(actors,key)
    local actors = actors or {};
    if not next(actors) then
        return;
    end
    for _,actor in ipairs(actors) do 
        local compo_Activate = actor:GetCompo("Activate");
        if compo_Activate then
            local bActivate = compo_Activate:GetData("bActivate");
            if bActivate then 
                if key == "j" then 
                    self.bDialogStart = false;
                    self.sDialogContent = "";
                end
            end
        end
    end
end

function B_DialogSystem:draw(actors)
    if self.bDialogStart then 
        love.graphics.setFont(assmgr:GetFont(2));
        love.graphics.print(self.sDialogContent,10,10);
    end
end