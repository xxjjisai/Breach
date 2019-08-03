_G.Scene1 = 
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

        --------------------- 编辑器 -----------------------
        -- ["MakerSystem"] = { };
        -- ["EditorSystem"] = { "所有组件" };
    }, 

    tbActors = 
    {
        "Player";
        "Enemy_1_4";
        "Map_1";
    },
};