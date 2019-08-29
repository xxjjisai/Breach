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
                ["Activate"] = { nRange = 100, bActivate = false }; -- 激活对话或者剧情的范围
                
                --- Map ---
                ["MapMaker"] = { tbDataMapInfo  = {}, tbRealMapInfo = {}, tbMapElement = {}, nCellSize = 32, nCellCount = 400 };
                ["Astar"] = { tbNode = { x = 0,y = 0,g = 0,h = 0,f = 0,nID = 0, nCol = 0,nRow = 0,nCellSize = 0,tbNeighors = {},nWalkAble = 0,previous = nil } };
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
        ["Sprite"] = { sImg = "g1" }; -- 精灵
        ["Activate"] = { nRange = 100, bActivate = false }; -- 激活对话或者剧情的范围

        --- Map ---
        ["MapMaker"] = { tbDataMapInfo  = {}, tbRealMapInfo = {}, tbMapElement = {}, nCellSize = 32, nCellCount = 400 };
        ["Astar"] = { tbNode = { x = 0,y = 0,g = 0,h = 0,f = 0,nID = 0, nCol = 0,nRow = 0,nCellSize = 0,tbNeighors = {},nWalkAble = 0,previous = nil } };
    }
    local actor = actmgr:CreateActor(sClassName,tbCompo);
    actmgr:AddActorInCurStage(actor);
]]

["每个系统需要的组件"] = 
[[
    --- A ---
    ["A_RenderRectangleSystem"] = { "Rectangle", "Position", "Size", "Color" };
    ["A_RogueRenderSortSystem"] = { "SortOrder", "Position", "Size" };
    ["A_WASDMoveSystem"] = { "WASDMove", "Position", "Direction", "Speed" };
    ["A_AnimationSystem"] = { "Animate", "Position", "Size", "Color" };
    ["A_SpriteSystem"] = { "Sprite", "Position", "Size", "Color" };
    ["A_PlayerAnimateStateSystem"] = { "Animate" };
    ["A_BumpWorldSystem"] = { "BumpWorld", "Position", "Size" };
    ["MapMakerSystem"] = { "MapMaker", "Astar" };
    ["A_GridClickSystem"] = { "MapMaker", "Position" };
    ["A_PlayerTweenMoveSystem"] = { "Position", "Size" };
    ["A_ActivateSystem"] = { "Activate","Position" };
    --------------------- 编辑器 -----------------------
    ["A_G_MapMakerSystem"] = { "MapMaker", "Astar" }; -- 矩形生成地图，两种生成器需要二选一
    ["A_R_MapMakerSystem"] = { "MapMaker", "Astar" }; -- 醉汉行步生成地图，两种生成器需要二选一
    ["A_EditorSystem"] = { "所有组件" };
    --- B ---
    ["B_DialogSystem"] = { "Activate","Position" };
    ["B_WelcomSystem"] = { "Title","Position" };

]]

[" A_EditorSystem 编辑器操作"] = 
[[
    *** 命令行模式，游戏运行状态鼠标点选actor后按下键盘 5 键

    *** 获取编辑器系统实例
    ed1=sysmgr:GetSystem("A_EditorSystem");

    *** 组件 增删改查
    ed1=sysmgr:GetSystem("A_EditorSystem");szCompo="BumpWorld";ed1:AddCompo(szCompo,{bInWorld=false});ed1:AddFlush(szCompo);
    ed1=sysmgr:GetSystem("A_EditorSystem");ed1:UpdateCompo("Rectangle",{filltype = "fill"});
    ed1=sysmgr:GetSystem("A_EditorSystem");szCompo="Position";ed1:RemoveCompo(szCompo);ed1:RemoveFlush(szCompo);

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

["事件"] =
[[
    *** 监听事件，在实现函数的类中监听，在start函数中监听
    function System:start()
        Event:AddEvent(sysmgr:GetSystem("A_WASDMoveSystem"),self);
    end

    function System:EvtPlayerWASDMove(actor,sState)

    end

    *** 发送事件
    Event:DoEvent(self, "EvtPlayerWASDMove", actor,"up")
]]