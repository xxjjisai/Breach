_G.Scene2 = 
{
    tbSystems = 
    {
        ["A_RenderRectangleSystem"] = { "Rectangle", "Position", "Size", "Color" };
        ["A_RogueRenderSortSystem"] = { "SortOrder", "Position", "Size" };
        ["A_WASDMoveSystem"] = { "WASDMove", "Position", "Direction", "Speed" };
        ["A_AnimationSystem"] = { "Animate", "Position", "Size", "Color" };
        ["A_SpriteSystem"] = { "Sprite", "Position", "Size", "Color" };
        ["A_PlayerAnimateStateSystem"] = { "Animate" };
        ["A_ActivateSystem"] = { "Activate","Position" };
        
        ["B_DialogSystem"] = { "Activate","Position" };

        -- ["A_BumpWorldSystem"] = { "BumpWorld", "Position", "Size" };
        
        -- ["A_GridClickSystem"] = { "MapMaker", "Position" };
        -- ["A_PlayerTweenMoveSystem"] = { "Position", "Size" };
        -- ["A_AstarSystem"] = { "MapMaker", "Astar" }; -- 在开启地图编辑的时候屏蔽此系统

        --------------------- 地图生成器 -----------------------
        -- ["A_G_MapMakerSystem"] = { "MapMaker", "Astar" }; -- 矩形生成地图，两种生成器需要二选一
        -- ["A_R_MapMakerSystem"] = { "MapMaker", "Astar" }; -- 醉汉行步生成地图，两种生成器需要二选一

        --------------------- 编辑器 -----------------------
        -- ["A_EditorSystem"] = { "所有组件" };
    }, 

    tbActors = 
    {
        --- stage --- 
        -- "Stage1";

        --- actor ---
        "Player";
        "Map";
        "Enemy";
    },
};