A_G_MapMakerSystem = class("A_G_MapMakerSystem",System)

function A_G_MapMakerSystem:start() 
    local iMap = actmgr:GMap();
    local iMapCompo = iMap:GetCompo("MapMaker").data;
    local iAstarCompo = iMap:GetCompo("Astar").data;
    local tbMapInfo = {};
    self.nCount = 0;
    iMapCompo.tbDataMapInfo = {};
    iMapCompo.tbRealMapInfo = {};
    iMapCompo.tbMapElement = {};
    iAstarCompo.tbNode.tbNeighors = {};
    iAstarCompo.tbNode.nCellSize = iMapCompo.nCellSize;
    iMapCompo.tbDataMapInfo = {iAstarCompo.tbNode};
    iMapCompo.tbRealMapInfo = {iAstarCompo.tbNode};
    local nCol = 10;
    local nRow = 10;
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
                    -- ["Rectangle"]   = { filltype = "line" };
                    ["SortOrder"]   = { nLayerIndex = option.tbLayer.ground };
                    -- ["BumpWorld"]   = { bInWorld = false };
                    ["Animate"]     = { nStartFrame = 5, nEndFrame = 6, bStartPlay = true, sImg = "mt_5", nQuadW = 32, nQuadH = 32, nTotalFrame= 2, nLoop = 1, nTotalPlayCount = 0, nTimeAfterPlay = 0.1 }
                }
            };
            local actor = actmgr:CreateActor("Actor",tbMapGridCfg.tbCompo);
            actor.sName = "grid"..actor.id;
            actor.sTag = tbMapGridCfg.sTag;
            actmgr:AddActorInCurStage(actor);
            local bwsys = sysmgr:GetSystem("A_BumpWorldSystem");
            local compo_BumpWorld = actor:GetCompo("BumpWorld");
            if compo_BumpWorld then
                compo_BumpWorld:SetData("bInWorld",false);
                bwsys:AddInWorld(actor);
            end
            local animatesys = sysmgr:GetSystem("A_AnimationSystem");
            local compo_Animate = actor:GetCompo("Animate")
            if compo_Animate:GetData("bStartPlay") then
                animatesys:SetFrame(compo_Animate);
                if compo_Animate:GetData("bStartPlay") then 
                    animatesys:Play(actor,compo_Animate:GetData("nStartFrame"),compo_Animate:GetData("nEndFrame"));
                end
            end
            -- 寻路node
            local tbNode = clone( iMapCompo.tbDataMapInfo[#iMapCompo.tbDataMapInfo] );
            tbNode.x = j*32;
            tbNode.y = i*32;
            tbNode.nWalkAble = 1;
            tbNode.nCellSize = iMapCompo.nCellSize;
            local nTCol,nTRow = math.floor(tbNode.x/iMapCompo.nCellSize),math.floor(tbNode.y/iMapCompo.nCellSize);
            tbNode.nCol = nTCol;
            tbNode.nRow = nTRow;
            tbNode.nID = Origin:GetID();
            if not self:GetSameItem(iMapCompo.tbDataMapInfo,tbNode) then 
                table.insert(iMapCompo.tbRealMapInfo,tbNode);
            end
            table.insert(iMapCompo.tbDataMapInfo,tbNode);
            self.nCount = self.nCount + 1;
        end 
    end
    
    -- for i,tbNode in ipairs(iMapCompo.tbRealMapInfo) do 
    --     self:AddNeighbors(tbNode,iMapCompo.tbRealMapInfo);
    -- end

    -- 设置player出生点
    local tbBorn = iMapCompo.tbRealMapInfo[1];
    tbBorn.nWalkAble = 1;
    local player = actmgr:GPA();
    local compo_Position = player:GetCompo("Position");
    compo_Position:SetData("x", tbBorn.x)
    compo_Position:SetData("y", tbBorn.y)
     
end


function A_G_MapMakerSystem:GetSameItem(tbDataMapInfo,tbNode)
    for i = 1,#tbDataMapInfo do 
        local item = tbDataMapInfo[i];
        if item.x == tbNode.x and item.y == tbNode.y then 
            return true;
        end 
    end
    return false;
end

function A_G_MapMakerSystem:draw()
    local iMap = actmgr:GMap();
    local iMapCompo = iMap:GetCompo("MapMaker").data;
    local nCellSize = iMapCompo.nCellSize;
    local tbRealMapInfo = iMapCompo.tbRealMapInfo;
    love.graphics.setColor(1,1,1,0.1);
    love.graphics.setLineWidth(1);
    for i,tbNode in ipairs(tbRealMapInfo) do 
        if tbNode.nWalkAble == 1 then 
            love.graphics.rectangle("fill",tbNode.x,tbNode.y,nCellSize,nCellSize)
        end 
    end 
end