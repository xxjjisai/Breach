["提交"] = 
[[
    点击文件右边"+"号,点击左上角"..."选择 Commit Stage ,填写log, 再次点击左上角"..."选择 Push to
]]

["创建一个Actor"] = 
[[
    1. *** 配置创建：
    _G.Player = 
    {
        {
            sClassName = "Actor";
            sTag = "Player";
            tbCompo = { -- 所有组件列表
                ["Position"] = {x=100,y=100}; -- 位置
                ["Direction"] = {x=0,y=0}; -- 方向
                ["Size"] = {x=64,y=64}; -- 尺寸
                ["Color"] = {color={1,1,0,1}}; -- 颜色
                ["Rectangle"] = {filltype="fill"}; -- 矩形
                ["Speed"] = {speed=200}; -- 速度
                ["SortOrder"] = {nLayerIndex=option.tbLayer.human}; -- 渲染层级
                ["WASDMove"] = {}; -- 八方向移动
                ["BumpWorld"] = {bInWorld=false}; -- 物理碰撞
                ["Animate"] = {nStartFrame=1,nEndFrame=4,bStartPlay=true,sImg="mt_4",nQuadW=32,nQuadH=32,nTotalFrame=16,nLoop=1,nTotalPlayCount=0,nTimeAfterPlay=0.1};
                ["Sprite"] = { sImg = "g1" };
            }
        }
    }

    2. *** 动态创建：
    local sClassName = "Actor";
    tbCompo = {
        ["Position"] = {x=100,y=100}; -- 位置
        ["Direction"] = {x=0,y=0}; -- 方向
        ["Size"] = {x=64,y=64}; -- 尺寸
        ["Color"] = {color={1,1,0,1}}; -- 颜色
        ["Rectangle"] = {filltype="fill"}; -- 矩形
        ["Speed"] = {speed=200}; -- 速度
        ["SortOrder"] = {nLayerIndex=option.tbLayer.human}; -- 渲染层级
        ["WASDMove"] = {}; -- 八方向移动
        ["BumpWorld"] = {bInWorld=false}; -- 物理碰撞
        ["Animate"] = {nStartFrame=1,nEndFrame=4,bStartPlay=true,sImg="mt_4",nQuadW=32,nQuadH=32,nTotalFrame=16,nLoop=1,nTotalPlayCount=0,nTimeAfterPlay=0.1};
        ["Sprite"] = { sImg = "g1" };
    }
    local actor = actmgr:CreateActor(sClassName,tbCompo);
    actmgr:AddActorInCurStage(actor);
]]

["每个系统需要的组件"] = 
[[
    ["RenderRectangleSystem"] = { "Rectangle", "Position", "Size", "Color" };
    ["RogueRenderSortSystem"] = { "SortOrder", "Position", "Size" };
    ["WASDMoveSystem"] = { "WASDMove", "Position", "Direction", "Speed" };
    ["BumpWorldSystem"] = { "BumpWorld", "Position", "Size" };
    ["EditorSystem"] = { "所有组件" };
]]

[" EditorSystem 编辑器操作"] = 
[[
    *** 命令行模式，游戏运行状态鼠标点选actor后按下键盘 5 键

    *** 获取编辑器系统实例
    ed1=sysmgr:GetSystem("EditorSystem");

    *** 组件 增删改查
    ed1=sysmgr:GetSystem("EditorSystem");szCompo="Animate";ed1:AddCompo(szCompo,{nStartFrame=7,nEndFrame=8,bStartPlay=true,sImg="mt_5",nQuadW = 32,nQuadH=32,nTotalFrame=2,nLoop=1,nTotalPlayCount=0,nTimeAfterPlay=0.1});ed1:AddFlush(szCompo);
    ed1=sysmgr:GetSystem("EditorSystem");ed1:UpdateCompo("Rectangle",{filltype = "fill"});
    ed1=sysmgr:GetSystem("EditorSystem");szCompo="BumpWorld";ed1:RemoveCompo(szCompo);ed1:RemoveFlush(szCompo);

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

["事件"] =
[[
    *** 监听事件，在实现函数的类中监听，在start函数中监听
    function System:start()
        Event:AddEvent(sysmgr:GetSystem("WASDMoveSystem"),self);
    end

    function System:EvtPlayerWASDMove(actor,sState)

    end

    *** 发送事件
    Event:DoEvent(self, "EvtPlayerWASDMove", actor,"up")
]]