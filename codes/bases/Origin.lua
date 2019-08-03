_G.Origin = {};

Origin.id = 0;

function Origin:GetID()
    self.id = self.id + 1;
    return self.id;
end