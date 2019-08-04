EditorSystem = class("EditorSystem",System)

EditorSystem.iCurObj = nil;
EditorSystem.sPath = "scripts/entitys/";
local time = os.date("%Y%m%d%H%M%S",os.time());
-- EditorSystem.sFileName = "Actor_"..time;
EditorSystem.sFileName = "Map_1";
EditorSystem.sState = "未保存";
EditorSystem.nState = 0;
EditorSystem.bAutoSave = false;
EditorSystem.bHelp = true;

-- mt_3.png 的序号
local aaa = function ()
    for i = 1, 100 do 
        print(((i-1) * 3 + i),"~",((i-1) * 3 + i) - 1 + 4)
    end
end 

aaa()

--[" EditorSystem 编辑器操作"] = 
local des = [[
    *** 命令行模式，游戏运行状态鼠标点选actor后按下键盘 5 键

    *** 获取编辑器系统实例
    ed1=sysmgr:GetSystem("EditorSystem");

    *** 组件 增删改查
    ed1=sysmgr:GetSystem("EditorSystem");szCompo="Animate";ed1:AddCompo(szCompo,{nStartFrame=7,nEndFrame=8,bStartPlay=true,sImg="mt_5",nQuadW = 32,nQuadH=32,nTotalFrame=2,nLoop=1,nTotalPlayCount=0,nTimeAfterPlay=0.1});ed1:AddFlush(szCompo);
    ed1=sysmgr:GetSystem("EditorSystem");ed1:UpdateCompo("Rectangle",{filltype = "fill"});
    ed1=sysmgr:GetSystem("EditorSystem");szCompo="Animate";ed1:RemoveCompo(szCompo);ed1:RemoveFlush(szCompo);

    *** 播放动画
    animatesys=sysmgr:GetSystem("AnimationSystem");ed1=sysmgr:GetSystem("EditorSystem");animatesys:SetFrame(ed1:GetActor():GetCompo("Animate"));animatesys:Play(ed1:GetActor(),21,24);

    *** 移除一个actor
    ed1=sysmgr:GetSystem("EditorSystem");id = ed1:GetActor().id;actmgr:RemoveActor(id);

    *** 查询该actor的组件列表
    ed1=sysmgr:GetSystem("EditorSystem");ed1:QueryCompoList()

    *** 修改该actor的sName
    ed1=sysmgr:GetSystem("EditorSystem");ed1:ChangeActorName("actor")

    *** 修改该actor的sTag
    ed1=sysmgr:GetSystem("EditorSystem");ed1:ChangeActorTag("Player")

    *** 修改动画
    ed1=sysmgr:GetSystem("EditorSystem");ed1:FiexAnimte(7,8,2)

    *** 结束命令行模式输入 cont
]]

local help = [[
    F1:显隐帮助
    文件名：%s
    保存:z
    创建:c
    复制:x
    删除:backspace or delete
    
    状态:%s %d次
]]

function EditorSystem:draw2()
    if self.bHelp then 
        love.graphics.setColor(1,1,1,1);
        love.graphics.setFont(assmgr:GetFont(22));
        love.graphics.print(string.format(help,self.sFileName,self.sState,self.nState),10,10);
    end
end

function EditorSystem:mousepressed(actors,x,y,button)
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
function EditorSystem:update(dt,actors)
    if self.bAutoSave then 
        nSaveTime = nSaveTime + 1
        if nSaveTime%1000 == 0 then
            self:Save(actors);
        end
    end
    if not self.iCurObj then 
        return
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

function EditorSystem:keypressed(actors,key) 
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
end

function EditorSystem:NextImage()
    local actor = self:GetActor();
    if not actor then return end;
    local animatesys = sysmgr:GetSystem("AnimationSystem");
    local compo_Animate = actor:GetCompo("Animate");
    local nCurFrame = compo_Animate:GetData("nStartFrame");
    compo_Animate:SetData("nStartFrame",nCurFrame + 1);
    compo_Animate:SetData("nEndFrame",nCurFrame + 1);
    animatesys:SetFrame(compo_Animate);
    if compo_Animate:GetData("bStartPlay") then 
        animatesys:Play(actor,compo_Animate:GetData("nStartFrame"),compo_Animate:GetData("nEndFrame"));
    end
end

function EditorSystem:LastImage()
    local actor = self:GetActor();
    if not actor then return end;
    local animatesys = sysmgr:GetSystem("AnimationSystem");
    local compo_Animate = actor:GetCompo("Animate");
    local nCurFrame = compo_Animate:GetData("nStartFrame")
    compo_Animate:SetData("nStartFrame",nCurFrame - 1);
    compo_Animate:SetData("nEndFrame",nCurFrame - 1);
    animatesys:SetFrame(compo_Animate);
    if compo_Animate:GetData("bStartPlay") then 
        animatesys:Play(actor,compo_Animate:GetData("nStartFrame"),compo_Animate:GetData("nEndFrame"));
    end
end

function EditorSystem:FiexAnimte(nStartFrame,nEndFrame,nTotalFrame,sImg,nTimeAfterPlay)
    local actor = self:GetActor();
    if not actor then return end;
    local animatesys = sysmgr:GetSystem("AnimationSystem");
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

function EditorSystem:Create(act)
    if act then 
        local tbCompo = {};
        for sName,iCompo in pairs(act.compos) do 
            tbCompo[sName] = clone(iCompo.data);
        end
        local actor = actmgr:CreateActor("Actor",tbCompo);
        actor.sName = act.sName;
        actor.sTag = act.sTag;
        actmgr:AddActorInCurStage(actor);
        local bwsys = sysmgr:GetSystem("BumpWorldSystem");
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
            ["SortOrder"] = { };
        } 
        local actor = actmgr:CreateActor("Actor",tbCompo);
        actor.sName = "actor";
        actor.sTag = "Actor";
        actmgr:AddActorInCurStage(actor);
    end
end

function EditorSystem:Save(actors)
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


function EditorSystem:GetCompo(sCompo)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj")
        return
    end
    self.iCurObj:GetCompo(sCompo)
end

function EditorSystem:AddCompo(compocls,compocfg)
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

function EditorSystem:UpdateCompo(compocls,compocfg)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    self:RemoveCompo(compocls);
    self:AddCompo(compocls,compocfg)
end

function EditorSystem:RemoveCompo(compocls)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    self.iCurObj:RemoveCompo(compocls)
end

function EditorSystem:GetActor()
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    return self.iCurObj
end

function EditorSystem:AddFlush(sCompo)
    -- 刷新物理碰撞
    if sCompo == "BumpWorld" then 
        local bws = sysmgr:GetSystem("BumpWorldSystem");
        local act = ed1:GetActor();
        bws:AddInWorld(act);
    end
end

function EditorSystem:RemoveFlush(sCompo)
    -- 刷新物理碰撞
    if sCompo == "BumpWorld" then 
        local bws = sysmgr:GetSystem("BumpWorldSystem");
        local act = ed1:GetActor();
        bws:RemoveInWorld(act);
    end
end

function EditorSystem:QueryCompoList()
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    self.iCurObj:GetCompoNameList()
end

function EditorSystem:ChangeActorName(sName)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    self.iCurObj.sName = sName;
end

function EditorSystem:ChangeActorTag(sTag)
    if not self.iCurObj then 
        self:trace(3,"has no iCurObj");
        return
    end
    self.iCurObj.sTag = sTag;
end

