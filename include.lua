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
        entitys = 
        {
            "Player";
            "Map";
        };

        stages = 
        {
            "Stage1",
            "Stage2",
            "Stage3",
        };

        systems = 
        {
            "RenderRectangleSystem";
            "RogueRenderSortSystem";
            "WASDMoveSystem";
            "BumpWorldSystem";
            "AnimationSystem";
            "EditorSystem";
            "PlayerAnimateStateSystem";
            "G_MapMakerSystem";
            "SpriteSystem";
            "R_MapMakerSystem";
            "FindPathSystem";
            "GridClickSystem";
            "PlayerTweenMoveSystem";
            "AstarSystem";
        }
    }
}