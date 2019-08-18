PlayerTweenMoveSystem = class("PlayerTweenMoveSystem",System)


function PlayerTweenMoveSystem:start() 
    self.tbPath = nil;  
    local iPlayer = actmgr:GPA(); 
    self.tbDataPlayer = 
    {
        x = iPlayer:GetCompo("Position").data.x,
        y = iPlayer:GetCompo("Position").data.y
    };
end

function PlayerTweenMoveSystem:SearchPathComplete(tbPath,pfn)
    self.tbPath = tbPath;
    self.pfn = pfn;
    local iScene = self:GetCurScene();
    table.remove(self.tbPath,#self.tbPath);
    self:MoveHandler(self:GetNextNode());
end

function PlayerTweenMoveSystem:MoveHandler(iTargetNode)
    if iTargetNode == nil then 
        if self.pfn then 
            self.pfn();
            return;
        end 
        return;
    end 
    local iPlayer = actmgr:GPA();
    local pw = iPlayer:GetCompo("Size").data.x;
    local ph = iPlayer:GetCompo("Size").data.y;
    local nx,ny = iTargetNode.x,iTargetNode.y;
    local nCellSize = iTargetNode.nCellSize;
    local nNCol,nNRow = math.floor(nx/nCellSize),math.floor(ny/nCellSize);
    local ox,oy = nNCol * nCellSize,nNRow * nCellSize ;
    local tbPos = { x = ox, y = oy }

    local px = iPlayer:GetCompo("Position").data.x;
    local py = iPlayer:GetCompo("Position").data.y;

    local dir = 0;
    if px - ox < 0 then 
        -- right
        dir = 1;
        Event:DoEvent(self, "EvtPlayerWASDMove", iPlayer,"right",1);
    elseif px - ox > 0 then 
        -- left
        dir = 2;
        Event:DoEvent(self, "EvtPlayerWASDMove", iPlayer,"left",1);
    elseif py - oy < 0 then 
        -- down
        dir = 3;
        Event:DoEvent(self, "EvtPlayerWASDMove", iPlayer,"down",1);
    elseif py - oy > 0 then 
        -- up
        dir = 4;
        Event:DoEvent(self, "EvtPlayerWASDMove", iPlayer,"up",1);
    end

    Tween.start(0.7,iPlayer:GetCompo("Position").data,{ x = ox,y = oy },'linear',function ()
        if dir == 1 then 
            Event:DoEvent(self, "EvtPlayerWASDMove", iPlayer,"right",2);
        elseif dir == 2 then 
            Event:DoEvent(self, "EvtPlayerWASDMove", iPlayer,"left",2);
        elseif dir == 3 then 
            Event:DoEvent(self, "EvtPlayerWASDMove", iPlayer,"down",2);
        elseif dir == 4 then 
            Event:DoEvent(self, "EvtPlayerWASDMove", iPlayer,"up",2);
        end
        self:MoveHandler(self:GetNextNode());
    end)
end 

function PlayerTweenMoveSystem:GetNextNode()
    local nNextNode = self.tbPath[#self.tbPath];
    table.remove(self.tbPath,#self.tbPath);
    return nNextNode;
end