B_WelcomSystem = class("B_WelcomSystem",System)
 
function B_WelcomSystem:start(actors)
    cammgr:RestCameraToOrigin();
end

function B_WelcomSystem:draw(actors)
    local actors = actors or {};
    if not next(actors) then
        return;
    end
    for _,actor in ipairs(actors) do 
        local compo_Title = actor:GetCompo("Title");
        if compo_Title then
            local compo_Color = actor:GetCompo("Color");
            local color = compo_Color:GetData("color");
            local sTitle = compo_Title:GetData("sTitle");
            love.graphics.setColor(unpack(color)); 
            love.graphics.setFont(assmgr:GetFont(6));
            love.graphics.print(sTitle, (windows.w*0.5) - assmgr:GetFont(6):getWidth(sTitle)*0.5,
            (windows.h*0.5) - assmgr:GetFont(6):getHeight(sTitle)*0.5);
            love.graphics.setFont(assmgr:GetFont(1));
            local sVestion="0.0.1"
            love.graphics.print(sVestion, 10, windows.h - assmgr:GetFont(2):getWidth(sVestion) * 0.5);
            -- love.graphics.printf(sTitle, 0,windows.h,windows.w,"center")
        end
    end
end

function B_WelcomSystem:keypressed(actors,key)
    if key == "return" then 
        scemgr:Next();
    end
end