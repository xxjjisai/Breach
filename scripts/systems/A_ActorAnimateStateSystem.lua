ActorAnimateStateSystem = class("ActorAnimateStateSystem",System)

function ActorAnimateStateSystem:start()
    Event:AddEvent(sysmgr:GetSystem("A_WASDMoveSystem"),self);
end

function ActorAnimateStateSystem:EvtEnemyWASDMove(actor,sState,nState)
    -- nState ( 1 键盘按下 2 键盘弹起 )
    local animatesys = sysmgr:GetSystem("A_AnimationSystem");
    local compo_Animate = actor:GetCompo("Animate")
    local nStartFrame,nEndFrame = 1,1;
    if nState == 1 then  
        if sState == "up" then 
            nStartFrame,nEndFrame = 13,16;
        elseif sState == "left" then
            nStartFrame,nEndFrame = 5,8;
        elseif sState == "down" then
            nStartFrame,nEndFrame = 1,4;
        elseif sState == "right" then
            nStartFrame,nEndFrame = 9,12;
        end 
    elseif nState == 2 then 
        if sState == "up" then 
            nStartFrame,nEndFrame = 13,13;
        elseif sState == "left" then
            nStartFrame,nEndFrame = 5,5;
        elseif sState == "down" then
            nStartFrame,nEndFrame = 1,1;
        elseif sState == "right" then
            nStartFrame,nEndFrame = 9,9;
        end 
    end
    if compo_Animate:GetData("bStartPlay") then
        animatesys:Play(actor,nStartFrame,nEndFrame);
    end
end

function ActorAnimateStateSystem:EvtPlayerWASDMove(actor,sState,nState)
    -- nState ( 1 键盘按下 2 键盘弹起 )
    local animatesys = sysmgr:GetSystem("A_AnimationSystem");
    local compo_Animate = actor:GetCompo("Animate")
    local nStartFrame,nEndFrame = 1,1;
    if nState == 1 then  
        if sState == "up" then 
            nStartFrame,nEndFrame = 13,16;
        elseif sState == "left" then
            nStartFrame,nEndFrame = 5,8;
        elseif sState == "down" then
            nStartFrame,nEndFrame = 1,4;
        elseif sState == "right" then
            nStartFrame,nEndFrame = 9,12;
        end 
    elseif nState == 2 then 
        if sState == "up" then 
            nStartFrame,nEndFrame = 13,13;
        elseif sState == "left" then
            nStartFrame,nEndFrame = 5,5;
        elseif sState == "down" then
            nStartFrame,nEndFrame = 1,1;
        elseif sState == "right" then
            nStartFrame,nEndFrame = 9,9;
        end 
    end
    if compo_Animate:GetData("bStartPlay") then
        animatesys:Play(actor,nStartFrame,nEndFrame);
    end
end