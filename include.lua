_G.include = 
{
    -- 场景配置
    scenes = 
    {
        'Scene1',
    };

    -- 全局配置
    globalcfg = {
        'AssetsFontCfg',
        'AssetsTextureCfg',
        'AssetsVoiceCfg',
        'ActorCfg',
        'SystemCfg',
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
            "Map_1";
            "Enemy_1_4";
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
            "MakerSystem";
            "SpriteSystem";
        }
    }
}