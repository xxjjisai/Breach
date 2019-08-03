SceneMgr = class("SceneMgr",Class)

SceneMgr.scene = nil;
SceneMgr.active = 0;

function SceneMgr:init()
    self.scene = nil;
    self.active = 0;
end

function SceneMgr:CreateScene() 
    local scene = Scene:new();
    self.active = self.active + 1;
    option.sState = option.tbState[1];
    assmgr:Start(option.assetsoffset + self.active,function()
        option.sState = option.tbState[2]; 
        cammgr:Fade(0.1, 0, 0, 0, 1,function() 
            scene:EnterScene();
            self.scene = scene;
            self.scene:GetStage():start();
            cammgr:Fade(4.5, 0, 0, 0, 0);
        end) 
    end)  
end

function SceneMgr:SwitchScene(active)
    self.active = active;
    self:CreateScene();
end

function SceneMgr:GetScene()
    return self.scene;
end

function SceneMgr:ResetScene()
    self.active = 0;
    self:DestoryScene();
end

function SceneMgr:DestoryScene()
    -- DataMger:GetSceneData(self.active);
    self.scene:DestoryStage();
    self.scene = nil;
end

function SceneMgr:Next()
    self:DestoryScene();
    self:CreateScene(); 
end