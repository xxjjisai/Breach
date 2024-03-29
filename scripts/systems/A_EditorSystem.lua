A_EditorSystem = class("A_EditorSystem",System)

A_EditorSystem.iCurObj = nil;
A_EditorSystem.sPath = "scripts/stages/";
local time = os.date("%Y%m%d%H%M%S",os.time());
-- A_EditorSystem.sFileName = "Actor_"..time;

A_EditorSystem.sFileName = "Stage";
A_EditorSystem.sState = "未保存";
A_EditorSystem.nState = 0;
A_EditorSystem.bAutoSave = false;
A_EditorSystem.bHelp = true;

-- mt_3.png 的序号
-- local aaa = function ()
--     for i = 1, 100 do 
--         print(((i-1) * 3 + i),"~",((i-1) * 3 + i) - 1 + 4)
--     end
-- end 

-- aaa()

--[" A_EditorSystem 编辑器操作"] = 
local des = [[
    *** 命令行模式，游戏运行状态鼠标点选actor后按下键盘 5 键

    *** 获取编辑器系统实例
    ed1=sysmgr:GetSystem("A_EditorSystem");

    *** 组件 增删改查
    ed1=sysmgr:GetSystem("A_EditorSystem");szCompo="Animate";ed1:AddCompo(szCompo,{nStartFrame=7,nEndFrame=8,bStartPlay=true,sImg="mt_5",nQuadW = 32,nQuadH=32,nTotalFrame=2,nLoop=1,nTotalPlayCount=0,nTimeAfterPlay=0.1});ed1:AddFlush(szCompo);
    ed1=sysmgr:GetSystem("A_EditorSystem");ed1:UpdateCompo("Rectangle",{filltype = "fill"});
    ed1=sysmgr:GetSystem("A_EditorSystem");szCompo="Animate";ed1:RemoveCompo(szCompo);ed1:RemoveFlush(szCompo);

    *** 播放动画
    animatesys=sysmgr:GetSystem("A_AnimationSystem");ed1=sysmgr:GetSystem("A_EditorSystem");animatesys:SetFrame(ed1:GetActor():GetCompo("Animate"));animatesys:Play(ed1:GetActor(),21,24);

    *** 移除一个actor
    ed1=sysmgr:GetSystem("A_EditorSystem");id = ed1:GetActor().id;actmgr:RemoveActor(id);

    *** 查询该actor的组件列表
    ed1=sysmgr:GetSystem("A_EditorSystem");ed1:QueryCompoList()

    *** 修改该actor的sName
    ed1=sysmgr:GetSystem("A_EditorSystem");ed1:ChangeActorName("actor")

    *** 修改该actor的sTag
    ed1=sysmgr:GetSystem("A_EditorSystem");ed1:ChangeActorTag("Player")

    *** 修改动画
    ed1=sysmgr:GetSystem("A_EditorSystem");ed1:FiexAnimte(7,8,2)

    *** 结束命令行模式输入 cont
]]

local help = [[
 F1:显隐帮助
 文件名：%s
 保存:z
 创建:c
 复制:x
 删除:backspace or delete 
 保存状态:%s %d次
]]

function A_EditorSystem:start()
    self.sFileName = "Stage"..tostring(scemgr.active);
end

function A_EditorSystem:draw2()
    if self.bHelp then 
        love.graphics.setColor(0.5,1,1,1);
        love.graphics.setFont(assmgr:GetFont(2));
        love.graphics.print(string.format(help,self.sFileName,self.sState,self.nState),10,10);
    end
end

function A_EditorSystem:mousepressed(actors,x,y,button)
    self.iCurObj = nil;
    local mx,my = cammgr:GetMousePosition();
    local mw,mh = 2,2;
    local actors = actors or {};
    if not next(actors) then 
        return 
    end
    for _,actor in ipairs(actors) do 
        local compo_Position = actor:GetCompo("Position");
        local compo_Size = actor:GetCompo("Size");
        if compo_Position and compo_Size then
            local ax = compo_Position:GetData("x");
            local ay = compo_Position:GetData("y");
            local aw = compo_Size:GetData("x");
            local ah = compo_Size:GetData("y");
            local obj1 = { x = ax, y = ay, w = aw, h = ah };
            local obj2 = { x = mx, y = my, w = mw, h = mh};
            if hitTestObject(obj1,obj2) then  
                self.iCurObj = actor;
                -- cammgr:SetFollowPlayer(actor);
                break;
            end
        end 
    end 
end

nSaveTime = 0;
function A_EditorSystem:update(dt,actors)
    if self.bAutoSave then 
        nSaveTime = nSaveTime + 1
        if nSaveTime%1000 == 0 then
            self:Save(actors);
        end
    end
    if not self.iCurObj then 
        return
    end
    if self.iCurObj.sTag == "Grid" then 
        return;
    end 
    local compo_Position = self.iCurObj:GetCompo("Position");
    if not compo_Position then 
        return;
    end
    local compo_Speed = self.iCurObj:GetCompo("Speed");
    local compo_Direction = self.iCurObj:GetCompo("Direction");
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
    local x = compo_Position:GetData("x") + (compo_Speed:GetData("speed") * dt) * compo_Direction:GetData("x")
    compo_Position:SetData("x",x);
    local y = compo_Position:GetData("y") + (compo_Speed:GetData("speed") * dt) * compo_Direction:GetData("y")
    compo_Position:SetData("y",y);
    compo_Direction:SetData("x",0);
    compo_Direction:SetData("y",0);
end

function A_EditorSystem:keypressed(actors,key) 
    if key == "c" then  -- 创建
        self:Create();
    end
    if key == "x" then -- 复制
        local actor = self:GetActor();
        if actor then 
            self:Create(actor);
        end 
    end
    if key == "z" then -- 保存
        self:Save(actors);
    end
    if key == "f1" then 
        self.bHelp = not self.bHelp;
    end
    if key == "delete" or key == "backspace" then 
        local actor = self:GetActor();
        if actor then 
            actmgr:RemoveActor(actor.id)
        end 
    end
    if key == "k" then 
        self:NextImage();
    end 

    if key == "v" then 
        self.bAutoSave = not self.bAutoSave
    end 

    if key == "l" then 
        self:LastImage();
    end

    if key == "m" then 
        self:ChangeMapWalkAbled();
    end
end

function A_EditorSystem:ChangeMapWalkAbled()
    local function GetSameItem(tbDataMapInfo,x,y)
        for i = 1,#tbDataMapInfo do 
            local item = tbDataMapInfo[i];
            if item.x == x and item.y == y then 
                return item;
            end 
        end
        return nil;
    end
    local actor = self:GetActor();
    if not actor then return end;
    local iMap = actmgr:GMap();
    local iMapCompo = iMap:GetCompo("MapMaker").data;
    local iAstarCompo = iMap:GetCompo("Astar").data;
    local compo_Position = actor:GetCompo("Position");
    local iNode = GetSameItem(iMapCompo.tbDataMapInfo,compo_Position:GetData("x"),compo_Position:GetData("y"));
    if iNode.nWalkAble == 1 then 
        iNode.nWalkAble = 0  
    elseif iNode.nWalkAble == 0 then  
        iNode.nWalkAble = 1
    end 
    self:trace(1,"iNode.nWalkAble=",iNode.nWalkAble);
end

function A_EditorSystem:NextImage()
    local actor = self:GetActor();
    if not actor then return end;
    local animatesys = sysmgr:GetSystem("A_AnimationSystem");
    local compo_Animate = actor:GetCompo("Animate");
    local nCurFrame = compo_Animate:GetData("nStartFrame");
    compo_Animate:SetData("nStartFrame",nCurFrame + 1);
    compo_Animate:SetData("nEndFrame",nCurFrame + 1);
    animatesys:SetFrame(compo_Animate);
    if compo_Animate:GetData("bStartPlay") then 
        animatesys:Play(actor,compo_Animate:GetData("nStartFrame"),compo_Animate:GetData("nEndFrame"));
    end
end

function A_EditorSystem:LastImage()
    local actor = self:GetActor();
    if not actor then return end;
    local animatesys = sysmgr:GetSystem("A_AnimationSystem");
    local compo_Animate = actor:GetCompo("Animate");
    local nCurFrame = compo_Animate:GetData("nStartFrame")
    compo_Animate:SetData("nStartFrame",nCurFrame - 1);
    compo_Animate:SetData("nEndFrame",nCurFrame - 1);
    animatesys:SetFrame(compo_Animate);
    if compo_Animate:GetData("bStartPlay") then 
        animatesys:Play(actor,compo_Animate:GetData("nStartFrame"),compo_Animate:GetData("nEndFrame"));
    end
end

function A_EditorSystem:FiexAnimte(nStartFrame,nEndFrame,nTotalFrame,sImg,nTimeAfterPlay)
    local actor = self:GetActor();
    if not actor then return end;
    local animatesys = sysmgr:GetSystem("A_AnimationSystem");
    local compo_Animate = actor:GetCompo("Animate");
    local nCurFrame = compo_Animate:GetData("nStartFrame")
    compo_Animate:SetData("nStartFrame",nStartFrame);
    compo_Animate:SetData("nEndFrame",nEndFrame);
    compo_Animate:SetData("nTotalFrame",nTotalFrame or 1);
    animatesys:SetFrame(compo_Animate);
    if compo_Animate:GetData("bStartPlay") then 
        animatesys:Play(actor,compo_Animate:GetData("nStartFrame"),compo_Animate:GetData("nEndFrame"));
    end
end

function A_EditorSystem:Create(act)
    if act then 
        local tbCompo = {};
        for sName,iCompo in pairs(act.compos) do 
            tbCompo[sName] = clone(iCompo.data);
        end
        local actor = actmgr:CreateActor("Actor",tbCompo);
        actor.sName = act.sName;
        actor.sTag = act.sTag;
        actmgr:AddActorInCurStage(actor);
        local bwsys = sysmgr:GetSystem("A_BumpWorldSystem");
        local compo_BumpWorld = actor:GetCompo("BumpWorld");
        if compo_BumpWorld and bwsys then
            compo_BumpWorld:SetData("bInWorld",false);
            bwsys:AddInWorld(actor);
        end
    else 
        local tbCompo = {
            ["Position"] = { x = 100, y = 100 };
            ["Direction"] = { x = 0, y = 0 };
            ["Size"] = { x = 64, y = 64 };
            ["Color"] = { color = {1,1,1,1} };
            ["Rectangle"] = { filltype = "line" };
            ["Speed"] = { speed = 200 };
        } 
        local actor = actmgr:CreateActor("Actor",tbCompo);
        actor.sName = "actor";
        actor.sTag = "Actor";
        actmgr:AddActorInCurStage(actor);
    end
end

function A_EditorSystem:Save(actors)
    self.sState = "保存中......";
    local tbActorList = {};
    for i,actor in ipairs(actors) do 
        local tbActor = {};
        tbActor.sClassName = 'Actor';
        tbActor.sName = actor.sName;
        tbActor.sTag = actor.sTag or actor.sName;
        tbActor.tbCompo = {};
        for sName,iCompo in pairs(actor.compos) do 
            tbActor.tbCompo[sName] = clone(iCompo.data);
            if sName == "Animate" then 
                tbActor.tbCompo[sName].tbQuad = {};
            end
            -- if sName == "MapMaker" then 
            --     tbActor.tbCompo[sName].tbDataMapInfo = clone(tbActor.tbCompo[sName].tbDataMapInfo);
            --     tbActor.tbCompo[sName].tbRealMapInfo = clone(tbActor.tbCompo[sName].tbRealMapInfo);
            -- end
        end
        table.insert(tbActorList,tbActor);        
    end
    local file = io.open(self.sPath..self.sFileName..'.lua', 'w')
    if file ~= nil then 
        file:write(table.show(tbActorList,"_G."..self.sFileName));
        file:close();
    end
    self.sState = "保存完毕！";
    self.nState = self.nState + 1;
end


----------------------  ------------------------


function A_EditorSystem:GetCompo(sCompo)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj")
        return
    end
    self.iCurObj:GetCompo(sCompo)
end

function A_EditorSystem:AddCompo(compocls,compocfg)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    if not compocls then 
        self:trace(3,"not found compocls!");
        return 
    end
    if self:GetCompo(compocls) then 
        self:trace(3,"has compocls!",compocls);
        return 
    end
    local compo = Compo:new(compocls,compocfg);
    self.iCurObj:AddCompo(compocls,compo);
end

function A_EditorSystem:UpdateCompo(compocls,compocfg)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    self:RemoveCompo(compocls);
    self:AddCompo(compocls,compocfg)
end

function A_EditorSystem:RemoveCompo(compocls)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    self.iCurObj:RemoveCompo(compocls)
end

function A_EditorSystem:GetActor()
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    return self.iCurObj
end

function A_EditorSystem:AddFlush(sCompo)
    -- 刷新物理碰撞
    if sCompo == "BumpWorld" then 
        local bws = sysmgr:GetSystem("A_BumpWorldSystem");
        local act = ed1:GetActor();
        bws:AddInWorld(act);
    end
end

function A_EditorSystem:RemoveFlush(sCompo)
    -- 刷新物理碰撞
    if sCompo == "BumpWorld" then 
        local bws = sysmgr:GetSystem("A_BumpWorldSystem");
        local act = ed1:GetActor();
        bws:RemoveInWorld(act);
    end
end

function A_EditorSystem:QueryCompoList()
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    self.iCurObj:GetCompoNameList()
end

function A_EditorSystem:ChangeActorName(sName)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    self.iCurObj.sName = sName;
end

function A_EditorSystem:ChangeActorTag(sTag)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    self.iCurObj.sTag = sTag;
end


function A_EditorSystem:draw()
    local iMap = actmgr:GMap();
    local iMapCompo = iMap:GetCompo("MapMaker").data;
    local nCellSize = iMapCompo.nCellSize;
    local tbRealMapInfo = iMapCompo.tbRealMapInfo;
    love.graphics.setColor(1,1,1,0.1);
    love.graphics.setLineWidth(1);
    for i,tbNode in ipairs(tbRealMapInfo) do 
        if tbNode.nWalkAble == 1 then 
            love.graphics.rectangle("fill",tbNode.x,tbNode.y,nCellSize,nCellSize)
        end 
    end 
end