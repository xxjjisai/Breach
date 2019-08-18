_G.Scene2 = 
{
    tbSystems = 
    {
        ["RenderRectangleSystem"] = { "Rectangle", "Position", "Size", "Color" };
        ["RogueRenderSortSystem"] = { "SortOrder", "Position", "Size" };
        ["WASDMoveSystem"] = { "WASDMove", "Position", "Direction", "Speed" };
        ["AnimationSystem"] = { "Animate", "Position", "Size", "Color" };
        ["SpriteSystem"] = { "Sprite", "Position", "Size", "Color" };
        ["PlayerAnimateStateSystem"] = { "Animate" };
        ["BumpWorldSystem"] = { "BumpWorld", "Position", "Size" };
        ["GridClickSystem"] = { "MapMaker", "Position" };
        ["PlayerTweenMoveSystem"] = { "Position", "Size" };
        ["AstarSystem"] = { "MapMaker", "Astar" }; -- 在开启地图编辑的时候屏蔽此系统

        --------------------- 地图生成器 -----------------------
        -- ["G_MapMakerSystem"] = { "MapMaker", "Astar" }; -- 矩形生成地图，两种生成器需要二选一
        -- ["R_MapMakerSystem"] = { "MapMaker", "Astar" }; -- 醉汉行步生成地图，两种生成器需要二选一

        --------------------- 编辑器 -----------------------
        -- ["EditorSystem"] = { "所有组件" };
    }, 

    tbActors = 
    {
        --- stage --- 
        "Stage2";

        --- actor ---
        -- "Player";
        -- "Map";
    },
};