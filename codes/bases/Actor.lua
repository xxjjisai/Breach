Actor = class("Actor",Entity)

Actor.compos = {};

function Actor:init()
    Entity.init(self);
    self.compos = {};
end

function Actor:AddCompo(sCompo,compo)
    self.compos[sCompo] = compo;
end

function Actor:RemoveCompo(sCompo)
    self.compos[sCompo] = nil;
end

function Actor:GetCompo(sCompo)
    return self.compos[sCompo];
end

function Actor:GetCompoNameList()
    local str = "";
    for sName,_ in pairs(self.compos) do 
        str = str.. " " ..sName;
    end
    self:trace(1,str)
end

function Actor:Destory()
    for sCompo,_ in pairs(self.compos) do 
        self:RemoveCompo(sCompo);
    end 
    self.compos = {};
end