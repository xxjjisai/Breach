Compo = class("Compo",Class)

function Compo:init(name,data)
    self.name = name;
    self.data = data;
end

function Compo:GetData(sParams)
    return self.data[sParams];
end

function Compo:SetData(sParams,value)
    self.data[sParams] = value;
end