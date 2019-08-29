A_RenderRectangleSystem = class("A_RenderRectangleSystem",System)

function A_RenderRectangleSystem:draw(actors)
    local actors = actors or {};
    if not next(actors) then
        return;
    end
    for _,actor in ipairs(actors) do 
        local compo_Rectangle = actor:GetCompo("Rectangle");
        if compo_Rectangle then
            local compo_Position = actor:GetCompo("Position");
            local compo_Size = actor:GetCompo("Size");
            local compo_Color = actor:GetCompo("Color");
            local x = compo_Position:GetData("x");
            local y = compo_Position:GetData("y");
            local w = compo_Size:GetData("x");
            local h = compo_Size:GetData("y");
            local color = compo_Color:GetData("color");
            local filltype = compo_Rectangle:GetData("filltype");
            love.graphics.setColor(unpack(color));
            love.graphics.rectangle(filltype,x,y,w,h);
        end
    end
end