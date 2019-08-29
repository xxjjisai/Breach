_G.Enemy = 
{
    {
        sClassName = "Actor";
        sTag = "Enemy";
        tbCompo = {
            ["Position"] = { x = 200, y = 100 };
            ["Direction"] = { x = 0, y = 0 };
            ["Size"] = { x = 30, y = 32 };
            ["Color"] = { color = {1,1,1,1} };
            -- ["Rectangle"] = { filltype = "line" };
            ["Speed"] = { speed = 50 };
            ["SortOrder"] = { nLayerIndex = option.tbLayer.human };
            -- ["WASDMove"] = { };
            -- ["Sprite"] = { sImg = "g1" };
            ["BumpWorld"] = { bInWorld = false };
            ["Animate"] = { nStartFrame = 1, nEndFrame = 1, bStartPlay = true, sImg = "mt_4", nQuadW = 32, nQuadH = 32, nTotalFrame= 1, nLoop = 1, nTotalPlayCount = 0, nTimeAfterPlay = 0.2 };
            ["Activate"] = { nRange = 30, bActivate = false };
        }
    };
    {
        sClassName = "Actor";
        sTag = "Enemy";
        tbCompo = {
            ["Position"] = { x = 200, y = 300 };
            ["Direction"] = { x = 0, y = 0 };
            ["Size"] = { x = 30, y = 32 };
            ["Color"] = { color = {1,1,1,1} };
            -- ["Rectangle"] = { filltype = "line" };
            ["Speed"] = { speed = 50 };
            ["SortOrder"] = { nLayerIndex = option.tbLayer.human };
            -- ["WASDMove"] = { };
            -- ["Sprite"] = { sImg = "g1" };
            ["BumpWorld"] = { bInWorld = false };
            ["Animate"] = { nStartFrame = 1, nEndFrame = 1, bStartPlay = true, sImg = "mt_4", nQuadW = 32, nQuadH = 32, nTotalFrame= 1, nLoop = 1, nTotalPlayCount = 0, nTimeAfterPlay = 0.2 };
            ["Activate"] = { nRange = 30, bActivate = false };
        }
    };
}