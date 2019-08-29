A_ActivateSystem = class("A_ActivateSystem",System)

function A_ActivateSystem:update(dt,actors)
    local actors = actors or {};
    if not next(actors) then
        return;
    end
    local player = actmgr:GPA();
    local p_compo_Position = player:GetCompo("Position");
    local p_compo_Size = player:GetCompo("Size");
    local px = p_compo_Position:GetData("x");
    local py = p_compo_Position:GetData("y");
    local pw = p_compo_Size:GetData("x");
    local ph = p_compo_Size:GetData("y");
    for _,actor in ipairs(actors) do 
        local compo_Activate = actor:GetCompo("Activate");
        if compo_Activate then
            local compo_Position = actor:GetCompo("Position");
            local compo_Size = actor:GetCompo("Size");
            local nRange = compo_Activate:GetData("nRange");
            local x = compo_Position:GetData("x");
            local y = compo_Position:GetData("y");
            local w = compo_Size:GetData("x");
            local h = compo_Size:GetData("y");
            if Dist(px+pw/2,py+ph/2,x+w/2,y+h/2) <= nRange then 
                compo_Activate:SetData("bActivate",true);
            else 
                compo_Activate:SetData("bActivate",false);
            end
        end
    end
end

function A_ActivateSystem:draw(actors)
    if bDebug then  
        local actors = actors or {};
        if not next(actors) then
            return;
        end
        for _,actor in ipairs(actors) do 
            local compo_Activate = actor:GetCompo("Activate");
            if compo_Activate then
                local compo_Position = actor:GetCompo("Position");
                local compo_Size = actor:GetCompo("Size");
                local compo_Color = actor:GetCompo("Color");
                local x = compo_Position:GetData("x");
                local y = compo_Position:GetData("y");
                local w = compo_Size:GetData("x");
                local h = compo_Size:GetData("y");
                local nRange = compo_Activate:GetData("nRange");
                local bActivate = compo_Activate:GetData("bActivate");
                if bActivate then
                    love.graphics.setColor(1,1,1,0.5);
                    love.graphics.circle("line", x+w/2,y+h/2, nRange,100);
                    love.graphics.setColor(0,1,0,0.2);
                    love.graphics.circle("fill", x+w/2,y+h/2, nRange,100);
                else 
                    love.graphics.setColor(1,1,1,0.3);
                    love.graphics.circle("line", x+w/2,y+h/2, nRange,100);
                    love.graphics.setColor(0,1,0,0.1);
                    love.graphics.circle("fill", x+w/2,y+h/2, nRange,100);
                end
            end
        end
    end
end