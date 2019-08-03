SpriteSystem = class("SpriteSystem",System)

function SpriteSystem:draw(actors)
    local actors = actors or {};
    if not next(actors) then
        return;
    end
    for _,actor in ipairs(actors) do 
        local compo_Sprite = actor:GetCompo("Sprite");
        if compo_Sprite then
            local compo_Position = actor:GetCompo("Position");
            local compo_Size = actor:GetCompo("Size");
            local compo_Color = actor:GetCompo("Color");
            local x = compo_Position:GetData("x");
            local y = compo_Position:GetData("y");
            local w = compo_Size:GetData("x");
            local h = compo_Size:GetData("y");
            local color = compo_Color:GetData("color");
            local sImg = compo_Sprite:GetData("sImg");
            local image = assmgr:GetTexture(sImg);
            love.graphics.setColor(unpack(color)); 
            local nImageW = image:getWidth();
            local nImageH = image:getHeight();
            local nImageX = x - (nImageW * 0.5 - w * 0.5)
            local nImageY = y - (nImageH - h);
            love.graphics.draw( image,nImageX, nImageY);
            if bDebug then  
                -- 贴图轮廓
                love.graphics.setColor(100,100,250,100);
                love.graphics.rectangle("line", nImageX, nImageY, nImageW, nImageH);
                -- 底部点 
                love.graphics.setColor(250,0,0,250); 
                love.graphics.circle( "fill",nImageX + nImageW / 2, nImageY + nImageH, 7 ) 
            end
        end
    end
end