_G.option = {

    bSplash = false; -- 是否播放闪屏动画
    bLog = false; -- 是否生成日志文件

    bCamera_MouseMove = true;
    bMouse_Move = true;
    bCamera_KeyMove = true;
    bCamera_MouseScale = true;
    bCamera_FollowPlayer = true;
    sCamera_FollowPlayer = "Player";

    bPause = false; -- 暂停
    bDebug = true; -- 调试
    bReport = false; -- 概要分析
    bStats = false; -- 状态FPS

    nWorldCellSize = 32; -- 物理世界Cell尺寸

    -------------------- *** 以下参数不可手动修改 *** ----------------------

    assetsoffset = 100; -- 资源加载起始偏移量
    bLoaded = false;
    sState = "";
    tbState = {
        [1] = "load",
        [2] = "game",
        [3] = "splash",
    };
    interface_scaling = 1;
    world_scaling = 1;
    windows = 
    {
        ["Windows"] = -- windows 系统下基础分辨率，修改后要同步 conf.lua
        {
            w = 960;
            h = 640;
        };
    };
    tbLayer = 
    {
        sky = 101;
        human = 201;
        humandown = 202;
        ground = 301;
    }
}