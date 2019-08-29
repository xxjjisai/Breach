A_R_MapMakerSystem = class("A_R_MapMakerSystem",System)

function A_R_MapMakerSystem:start()
    self:GeneratorHandler(function ()
        -- 设置player出生点
        local iMap = actmgr:GMap();
        local iMapCompo = iMap:GetCompo("MapMaker").data;
        local tbBorn = iMapCompo.tbRealMapInfo[1];
        tbBorn.nWalkAble = 1;
        local player = actmgr:GPA();
        local compo_Position = player:GetCompo("Position");
        compo_Position:SetData("x", tbBorn.x)
        compo_Position:SetData("y", tbBorn.y)
        -- 生成可视化地图
        self:CreateMap(iMapCompo.tbRealMapInfo);

    end)
end

function A_R_MapMakerSystem:CreateMap(tbRealMapInfo)
    for i,tbNode in ipairs(tbRealMapInfo) do 
        if tbNode.nWalkAble == 1 then 
            local tbMapGridCfg = 
            {
                sClassName = "Actor";
                sTag = "Grid";
                tbCompo = 
                {
                    ["Position"]    = { x = tbNode.x, y = tbNode.y };
                    ["Direction"]   = { x=0,y=0 };
                    ["Size"]        = { x = 32, y = 32 };
                    ["Color"]       = { color = {1,1,1,1} };
                    ["Speed"]       = { speed = 200 };
                    -- ["Rectangle"]   = { filltype = "line" };
                    ["SortOrder"]   = { nLayerIndex = option.tbLayer.ground };
                    -- ["BumpWorld"]   = { bInWorld = false };
                    ["Animate"]     = { nStartFrame = 3, nEndFrame = 3, bStartPlay = true, sImg = "mt_5", nQuadW = 32, nQuadH = 32, nTotalFrame= 2, nLoop = 1, nTotalPlayCount = 0, nTimeAfterPlay = 0.1 }
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
        end 
    end 
end

function A_R_MapMakerSystem:GeneratorHandler(pfn)
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
    while self.nCount < iMapCompo.nCellCount do
        local tbNode = clone( iMapCompo.tbDataMapInfo[#iMapCompo.tbDataMapInfo] );
        local nDir = math.random(1,4);
        if nDir == 1 then 
            tbNode.x = tbNode.x + iMapCompo.nCellSize;
        elseif nDir == 2 then  
            tbNode.x = tbNode.x - iMapCompo.nCellSize;
        elseif nDir == 3 then  
            tbNode.y = tbNode.y + iMapCompo.nCellSize;
        elseif nDir == 4 then  
            tbNode.y = tbNode.y - iMapCompo.nCellSize;
        end
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
    -- for i,tbNode in ipairs(iMapCompo.tbRealMapInfo) do 
    --     self:AddNeighbors(tbNode,iMapCompo.tbRealMapInfo);
    -- end

    if pfn then 
        pfn()  
    end
end

function A_R_MapMakerSystem:GetSameItem(tbDataMapInfo,tbNode)
    for i = 1,#tbDataMapInfo do 
        local item = tbDataMapInfo[i];
        if item.x == tbNode.x and item.y == tbNode.y then 
            return true;
        end 
    end
    return false;
end

function A_R_MapMakerSystem:QuerytbNodeByColAndRow(iMapCompo,nCol,nRow)
    for i = 1, #iMapCompo.tbRealMapInfo do
        local tbNode = iMapCompo.tbRealMapInfo[i];
        if tbNode.nCol == nCol and tbNode.nRow == nRow then 
            return tbNode
        end 
    end
end

function A_R_MapMakerSystem:GetRandomNode(iMapCompo,nType)
    for i = 1, #iMapCompo.tbRealMapInfo do
        local tbNode = iMapCompo.tbRealMapInfo[i];
        if tbNode.nWalkAble == nType then 
            return tbNode
        end
    end
end


function A_R_MapMakerSystem:GetNeighbors(iNode)
    return iNode.tbNeighors;
end

function A_R_MapMakerSystem:AddNeighbors(iNode,tbRealMapInfo)
    local x = iNode.x ;
    local y = iNode.y ;
    local nCellSize = iNode.nCellSize;
    local GetNeighor = function (x,y)
        for i,v in ipairs(tbRealMapInfo) do 
            local tbNode = v;
            if tbNode.x == x and tbNode.y == y then 
                return tbNode;
            end
        end 
        return nil;
    end 

    local tbNeighorPos = {
        {x, y - nCellSize}, -- u
        {x, y + nCellSize}, -- d
        {x - nCellSize, y}, -- l
        {x + nCellSize, y}, -- r
        {x - nCellSize, y - nCellSize}, -- ul
        {x - nCellSize, y + nCellSize}, -- dl
        {x + nCellSize, y - nCellSize}, -- ur
        {x + nCellSize, y + nCellSize}, -- dr
    }

    for i,v in ipairs(tbNeighorPos) do 
        local x = v[1];
        local y = v[2];
        local iNeighorNode = GetNeighor(x,y);
        if iNeighorNode ~= nil then 
            table.insert(iNode.tbNeighors,iNeighorNode);
        end 
    end
end

function A_R_MapMakerSystem:draw()
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