RogueRenderSortSystem = class("RogueRenderSortSystem",System)

function RogueRenderSortSystem:start(actors)
    local actors = actors or {};
    if not next(actors) then 
        return 
    end
    -- table.sort(actors, function(a,b)
    --     if a ~= nil and b ~= nil then 
    --         local a_compo_Position = a:GetCompo("Position");
    --         local a_compo_Size = a:GetCompo("Size");
    --         local b_compo_Position = b:GetCompo("Position");
    --         local b_compo_Size = b:GetCompo("Size");
    --         local ay = a_compo_Position:GetData("y") + a_compo_Size:GetData("y");
    --         local by = b_compo_Position:GetData("y") + b_compo_Size:GetData("y");
    --         return ay < by;
    --     end
    -- end) 
end

function RogueRenderSortSystem:update(dt,actors)
    local actors = actors or {};
    if not next(actors) then 
        return 
    end
    table.sort(actors, function(a,b)
        if a ~= nil and b ~= nil then 
            local a_compo_SortOrder = a:GetCompo("SortOrder");
            local b_compo_SortOrder = b:GetCompo("SortOrder");
            local a_compo_Position = a:GetCompo("Position");
            local a_compo_Size = a:GetCompo("Size"); 
            local b_compo_Position = b:GetCompo("Position");
            local b_compo_Size = b:GetCompo("Size"); 
            local ay = a_compo_Position:GetData("y") + a_compo_Size:GetData("y");
            local by = b_compo_Position:GetData("y") + b_compo_Size:GetData("y");
            if a_compo_SortOrder:GetData("nLayerIndex") == option.tbLayer.human and
            b_compo_SortOrder:GetData("nLayerIndex") == option.tbLayer.human then
                return ay < by;
            else 
                return a_compo_SortOrder:GetData("nLayerIndex") > b_compo_SortOrder:GetData("nLayerIndex")
            end
        end
    end) 
end