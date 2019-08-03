System = class("System",Class)

function System:init()
    self.id = Origin:GetID();
end

function System:start()

end

function System:GetCurScene()
    local scene = scemgr:GetScene();
    return scene;
end

function System:GetCurStage()
    local scene = self:GetCurScene();
    local stage = scene:GetStage();
    return stage
end