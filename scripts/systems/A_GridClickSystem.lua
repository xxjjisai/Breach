A_GridClickSystem = class("A_GridClickSystem",System)

function A_GridClickSystem:start()
    self.bMoved = nil;
    self.tbEndPoint = nil;
end

function A_GridClickSystem:mousepressed(actors,x,y,button)
    if button ~= 1 then 
        return 
    end
    if self.bMoved then return end 
    self.bMoved = true;
    self.tbEndPoint = nil;
    local iPlayer = actmgr:GPA();
    local iMap = actmgr:GMap();
    if iMap == nil then self.bMoved = false return end 
    local iMapCompo = iMap:GetCompo("MapMaker").data;
    local nCellSize = iMapCompo.nCellSize;
    local tbRealMapInfo = iMapCompo.tbRealMapInfo;
    local px = iPlayer:GetCompo("Position").data.x;
    local py = iPlayer:GetCompo("Position").data.y;
    local nPCol,nPRow = math.floor(px/nCellSize),math.floor(py/nCellSize);
    local mx,my = CameraMgr:GetMousePosition();
    local nMCol,nMRow = math.floor(mx/nCellSize),math.floor(my/nCellSize);
    local bCanWalk = self:CheckCanWalk(nMCol,nMRow,tbRealMapInfo);
    if not bCanWalk then self.bMoved = false return end
    self.tbDataPlayer = {x = px, y = py};
    local tbStartPoint = self:GetNodeFromRealMap(nPCol,nPRow,tbRealMapInfo);
    -- tbStartPoint.nWalkAble = 1;
    local tbEndPoint = self:GetNodeFromRealMap(nMCol,nMRow,tbRealMapInfo);
    if tbStartPoint == nil or tbEndPoint == nil then 
        self:trace(2," Not Find Start or End Point ");
        self.bMoved = false
        return 
    end 
    self.tbEndPoint = tbEndPoint;
    A_FindPathSystem:SearchPath(tbStartPoint,tbEndPoint,function (nCode,tbPath)
        if nCode ~= 0 then 
            self:trace(1,"Find Path Fail!");
            self.bMoved = false;
            return;
        end 
        A_PlayerTweenMoveSystem:SearchPathComplete(tbPath,function ()
            -- tbEndPoint.nWalkAble = 0;
            self.bMoved = false;
        end);
    end)
end

function A_GridClickSystem:CheckCanWalk(nCol,nRow,tbRealMapInfo)
    for i,tbNode in ipairs(tbRealMapInfo) do 
        if nCol == tbNode.nCol and nRow == tbNode.nRow then 
            if tbNode.nWalkAble == 1 then 
                return true 
            end 
        end
    end
    return false;
end

function A_GridClickSystem:GetNodeFromRealMap(nCol,nRow,tbRealMapInfo)
    for i,tbNode in ipairs(tbRealMapInfo) do 
        if nCol == tbNode.nCol and nRow == tbNode.nRow then 
            return tbNode;
        end
    end
    return nil;
end