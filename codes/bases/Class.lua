Class = class("Class")

Class.tbListenerList = {};

function Class:init()
    -- print(table.show(self.class,"self.class"))
end

function Class:trace(nType,...)
    if bDebug then 
        local sType = "[Log] ";
        if nType == 1 then 
            sType = "[Log] " 
        elseif nType == 2 then 
            sType = "[Warn] " 
        elseif nType == 3 then 
            sType = "[Error] " 
        else 
            sType = "[Log] "
        end  
        
        local args = {...};
        if type(args[1]) == "table" then 
            print("[~~~~~~~~~~~~~~~~"..self.class.name.."~~~~~~~~~~~~~~~~] start >> ",sType);
            print_lua_table(args[1]);
            print("[~~~~~~~~~~~~~~~~"..self.class.name.."~~~~~~~~~~~~~~~~] end << ",sType);
            return 
        end  
        if not self.class then self.class = {name = ""} end;
        local str = "["..self.class.name.." "..os.date("%c").."] "..sType;
        for i,v in ipairs(args) do 
            str = str..tostring(v).." ";
        end
    
        print(str.."");
    
        if option.bLog then 
            local file = io.open('gc.log', 'a')
            if file ~= nil then 
                file:write(str.."\n");
                file:close();
            end
        end
    end
end