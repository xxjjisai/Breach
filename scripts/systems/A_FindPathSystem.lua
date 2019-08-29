A_FindPathSystem = class("A_FindPathSystem",System)

function A_FindPathSystem:SearchPath(tbStartNode,tbEndNode,pfn)
    
    local tbPath = {};
    local tbOpenList = {};
    local tbCloseList = {};

    -- 地图信息
    local iMap = actmgr:GMap();
    local iMapCompo = iMap:GetCompo("MapMaker").data;
    local tbRealMapInfo = iMapCompo.tbRealMapInfo;
    local nCellSize = iMapCompo.nCellSize;

    -- 检查父级列表中是否已经存在
    local CheckIncludeInList = function (list,p) 
        for i,v in ipairs(list) do 
            if v.nID == p.nID then 
                return true;
            end 
        end 
        return false;
    end 

    -- 启发式（探索式）
    local heuristic = function(a,b)
        local dist = function (ax,ay,bx,by)  
            local pax = (ax - bx) * (ax - bx);
            local pay = (ay - by) * (ay - by); 
            local result = math.sqrt((pax + pay)); 
            return result;
        end 
        local d = dist(a.x,a.y,b.x,b.y);
        return d;
    end

    tbStartNode.previous = nil;
    table.insert(tbOpenList,tbStartNode); 

    while #tbOpenList ~= 0 do 
        local nFirstIndex = 1;
        if tbOpenList[nFirstIndex] == nil then 
            break;
        end 
        for i,v in ipairs(tbOpenList) do 
            if v ~= nil  then 
                if v.f < tbOpenList[nFirstIndex].f then 
                    nFirstIndex = i; 
                end
            end 
        end

        -- 获得当前节点
        local tbCurrentNode = tbOpenList[nFirstIndex]; 

        -- 如果 F 值最低的正好是目标节点，则寻路完成
        if tbCurrentNode == tbEndNode then  
            tbPath = {};
            table.insert( tbPath, tbCurrentNode );
            while tbCurrentNode.previous do  
                table.insert( tbPath, tbCurrentNode.previous )
                tbCurrentNode = tbCurrentNode.previous;
            end  
            break ;
        end

        table.remove(tbOpenList,nFirstIndex); 
        table.insert(tbCloseList,tbCurrentNode);

        local tbNeighors = tbCurrentNode.tbNeighors;  
        tbNeighors = tbNeighors or {};
        if next(tbNeighors) then 
            for i,v in ipairs(tbNeighors) do 
                local iCurNode = v;
                if not CheckIncludeInList(tbCloseList,iCurNode) then 
                    local nTmpG = tbCurrentNode.g + 1; 
                    local bNewPath = false;
                    if CheckIncludeInList(tbOpenList,iCurNode) or iCurNode.nWalkAble == 0 then 
                        if nTmpG < iCurNode.g then 
                            iCurNode.g = nTmpG;
                            bNewPath = true;
                        end 
                    else 
                        iCurNode.g = nTmpG;
                        bNewPath = true;
                        table.insert( tbOpenList,iCurNode );
                    end
                    if bNewPath then 
                        iCurNode.h = heuristic(iCurNode,tbEndNode);
                        iCurNode.f = iCurNode.g + iCurNode.h;
                        iCurNode.previous = tbCurrentNode;
                    end
                end
            end 
        end
    end

    if #tbPath ~= 0 then 
        if pfn then 
            pfn(0,tbPath);
            return;
        end 
    end

    if pfn then 
        pfn(-1,nil);
        return;
    end 
    
end