_G.include = 
{
    -- 场景配置
    scenes = 
    {
        'Scene1',
        'Scene2',
    };

    -- 全局配置
    globalcfg = { 
        'ActorCfg',
        'SystemCfg',
    };

    -- 资源配置
    assestscfg = {
        'AssetsFontCfg',
        'AssetsTextureCfg',
        'AssetsVoiceCfg', 
    };

    -- 基类
    bases = {
        'Class',
        'Event',
        'Origin',
        'Entity',
        'System',
        'Compo',
        'Actor',
        'Scene',
        'Stage',
    };

    -- 管理器
    mgrs = {
        'SceneMgr',
        'AssetsMgr',
        'ActorMgr',
        'SystemMgr',
        'SplashMgr',
        'CameraMgr',
    };

    ecs =
    {
        actors = 
        {
            "Player";
            "Map";
            "Enemy";
            "Title";
        };

        stages = 
        {
            "Stage1",
        };

        systems = 
        {
            "A_RenderRectangleSystem";
            "A_RogueRenderSortSystem";
            "A_WASDMoveSystem";
            "A_BumpWorldSystem";
            "A_AnimationSystem";
            "A_EditorSystem";
            "A_PlayerAnimateStateSystem";
            "A_G_MapMakerSystem";
            "A_SpriteSystem";
            "A_R_MapMakerSystem";
            "A_FindPathSystem";
            "A_GridClickSystem";
            "A_PlayerTweenMoveSystem";
            "A_AstarSystem";
            "A_ActivateSystem";
            "B_DialogSystem";
            "B_WelcomSystem";
        }
    }
}