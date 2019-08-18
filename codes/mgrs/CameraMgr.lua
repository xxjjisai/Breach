_G.CameraMgr = class("CameraMgr",Class)

CameraMgr.sFollowPlayer = "Player";
CameraMgr.iFollowPlayer = nil;

function CameraMgr:SetCameraStyle(Camera_Follow_Lerp,Camera_Follow_Style)
    Camera:setFollowLerp(Camera_Follow_Lerp);
    Camera:setFollowStyle(Camera_Follow_Style);
end

function CameraMgr:SetFollowPlayer(actor)
    self.iFollowPlayer = actor;
end

function CameraMgr:update(dt)
    -- 移动镜头 鼠标方式
    -- if option.bCamera_MouseMove then 
    --     if option.bMouse_Move then 
    --         local mx,my = CameraMgr:GetMousePosition();
    --         Camera:follow(mx, my); 
    --     end
    -- end
    -- 移动镜头 键盘方式
    if option.bCamera_KeyMove then 
        local keyi = love.keyboard.isDown("lshift");
        if keyi then 
            local mx,my = CameraMgr:GetMousePosition();
            Camera:follow(mx, my); 
        end
    end
    if option.bCamera_MouseScale then 
        -- 缩小镜头 
        local keyi = love.keyboard.isDown("]");
        if keyi then 
            if Camera.scale <= 0.1 then return end;
            Camera.scale = Camera.scale - 0.01;
        end 
        -- 放大镜头
        local keyu = love.keyboard.isDown("[");
        if keyu then 
            if Camera.scale >= 10 then return end;
            Camera.scale = Camera.scale + 0.01;
        end  
    end
    -- 还原镜头
    local keyu = love.keyboard.isDown("o");
    if keyu then  
        Camera.scale = 1;
    end 
    Camera:update(dt);
    self:Follow();
end 

function CameraMgr:Follow()  
    if not option.bCamera_FollowPlayer then return end;
    if not self.iFollowPlayer then return end;
    local actor = self.iFollowPlayer;
    local compo_Position = actor:GetCompo("Position")
    local compo_Size = actor:GetCompo("Size")
    if compo_Position and compo_Size then
        local x = compo_Position:GetData("x");
        local y = compo_Position:GetData("y");
        local w = compo_Size:GetData("x");
        local h = compo_Size:GetData("y");
        local tx,ty = x + w * 0.5, y + h * 0.5;
        Camera:follow(tx,ty);
    end
end 

function CameraMgr:Attach()
    Camera:attach()
end 

function CameraMgr:Detach()
    Camera:detach() 
    Camera:draw()
end 

function CameraMgr:RenderAttach(pfn)
    self:Attach();
    if pfn then 
        pfn();
    end 
    self:Detach()  
end 

function CameraMgr:Shake(nDouFU,nDuration, nHz)
    Camera:shake(nDouFU or 8,nDuration or 1, nHz or 60)
end 

function CameraMgr:Fade(nDuration,r,g,b,a,pfn)
    Camera:fade(nDuration, {r,g,b,a},pfn)
end 

function CameraMgr:Flash(nDuration,r,g,b,a)
    Camera:flash(nDuration, {r,g,b,a})
end  

function CameraMgr:GetMousePosition()
    return Camera:getMousePosition();
end 
 
function CameraMgr:WheelMoved(x, y)
    if option.bCamera_MouseScale then  
        if y > 0 then 
            if Camera.scale >= 10 then return end;
            Camera.scale = Camera.scale + 0.04; 
        elseif y < 0 then
            if Camera.scale <= 0.1 then return end;
            Camera.scale = Camera.scale - 0.04; 
        end
    end
end 

function CameraMgr:MouseDown(x,y,button)   
    if button == 1 then 
        
    end    

    if button == 2 then 
        if option.bCamera_MouseMove then 
            option.bMouse_Move = not option.bMouse_Move;
        end
    end 
end