MakerSystem = class("MakerSystem",System)

function MakerSystem:start() 
    local nCol = 20;
    local nRow = 20;
    for i = 0,nCol-1 do 
        for j = 0,nRow-1 do 
            local tbMapGridCfg = 
            {
                sClassName = "Actor";
                sTag = "Grid";
                tbCompo = 
                {
                    ["Position"]    = { x = j*32, y = i*32 };
                    ["Direction"]   = { x=0,y=0 };
                    ["Size"]        = { x = 32, y = 32 };
                    ["Color"]       = { color = {1,1,1,1} };
                    ["Speed"]       = { speed = 200 };
                    ["Rectangle"]   = { filltype = "line" };
                    ["SortOrder"]   = { nLayerIndex = option.tbLayer.ground };
                    ["BumpWorld"]   = { bInWorld = false };
                    ["Animate"]     = { nStartFrame = 5, nEndFrame = 6, bStartPlay = true, sImg = "mt_5", nQuadW = 32, nQuadH = 32, nTotalFrame= 2, nLoop = 1, nTotalPlayCount = 0, nTimeAfterPlay = 0.1 }
                }
            };
            local actor = actmgr:CreateActor("Actor",tbMapGridCfg.tbCompo);
            actor.sName = "grid"..actor.id;
            actor.sTag = tbMapGridCfg.sTag;
            actmgr:AddActorInCurStage(actor);
            local bwsys = sysmgr:GetSystem("BumpWorldSystem");
            local compo_BumpWorld = actor:GetCompo("BumpWorld");
            if compo_BumpWorld then
                compo_BumpWorld:SetData("bInWorld",false);
                bwsys:AddInWorld(actor);
            end
            local animatesys = sysmgr:GetSystem("AnimationSystem");
            local compo_Animate = actor:GetCompo("Animate")
            if compo_Animate:GetData("bStartPlay") then
                animatesys:SetFrame(compo_Animate);
                if compo_Animate:GetData("bStartPlay") then 
                    animatesys:Play(actor,compo_Animate:GetData("nStartFrame"),compo_Animate:GetData("nEndFrame"));
                end
            end
        end 
    end 
end