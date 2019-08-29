A_AstarSystem = class("A_AstarSystem",System)

function A_AstarSystem:start()
    local iMap = actmgr:GMap();
    local iMapCompo = iMap:GetCompo("MapMaker").data;
    local iAstarCompo = iMap:GetCompo("Astar").data;
    for i,tbNode in ipairs(iMapCompo.tbRealMapInfo) do 
        self:AddNeighbors(tbNode,iMapCompo.tbRealMapInfo);
    end

    -- local tbBorn = iMapCompo.tbRealMapInfo[1];
    -- tbBorn.nWalkAble = 1;
    -- local player = actmgr:GPA();
    -- local compo_Position = player:GetCompo("Position");
    -- compo_Position:SetData("x", tbBorn.x)
    -- compo_Position:SetData("y", tbBorn.y)
end

function A_AstarSystem:GetNeighbors(iNode)
    return iNode.tbNeighors;
end

function A_AstarSystem:AddNeighbors(iNode,tbRealMapInfo)
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
        -- {x - nCellSize, y - nCellSize}, -- ul
        -- {x - nCellSize, y + nCellSize}, -- dl
        -- {x + nCellSize, y - nCellSize}, -- ur
        -- {x + nCellSize, y + nCellSize}, -- dr
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
