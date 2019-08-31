AssetsMgr = class("AssetsMgr",Class)

AssetsMgr.tbMedia = {images = {}, sounds = {}, fonts = {}};
AssetsMgr.loadlogo = nil;

function AssetsMgr:Start(active,callback) 
    self.loadlogo = nil;--love.graphics.newImage( "assets/textures/flash.jpg" )
	option.bLoaded = false; 
    self:trace(1,"[started loading]");
    local pfn = function ()
        self:trace(1,"[End loading]");
        option.bLoaded = true;
        callback();
    end  

    -- 通用资源只在第一次加载
    if active == 100 then 
        local sSceneName = "Currency"; 
        
        -- 字体资源
        local tbFont = AssetsFontCfg[sSceneName];
        if not next(tbFont) then 
            self:trace(1,"Not Find Font");
        else
            local iFont = {};
            local tbFontSize = { 22, 24, 32, 36, 72, 92 };
            if tbFont ~= nil then 
                for a = 1, #tbFont do 
                    for i = 1, #tbFontSize do 
                        iFont.sName = i;
                        iFont.sPath = tbFont[a].sPath;
                        iFont.nSize = tbFontSize[i];
                        self:trace(1,"Font:",iFont.sName)
                        AssetsMgr.tbMedia.fonts[tonumber(iFont.sName)] = love.graphics.newFont(iFont.sPath,iFont.nSize);
                    end
                end
            end 
        end
        
        -- 声音资源
        local tbSound = AssetsVoiceCfg[sSceneName];
        if not next(tbSound) then 
            self:trace(1,"Not Find Sound");
        else
            if tbSound ~= nil then 
                for _,iSound in pairs(AssetsVoiceCfg[sSceneName]) do 
                    if iSound ~= nil then 
                        self:trace(1,i,"Loading Sound ",iSound.sName);
                        AssetsMgr.tbMedia.sounds[iSound.sName] = love.audio.newSource(iSound.sPath, "stream" );
                    end    
                end
            end  
        end 
    end

    -- 贴图资源
    local tbImage = AssetsTextureCfg[active];
    tbImage = tbImage or {};
    if not next(tbImage) then 
        self:trace(1,"Not Find Image");
        pfn();
        return;
    else
        if tbImage ~= nil then 
            for i,iTexture in pairs(tbImage) do 
                self:trace(1,i,"Loading Image ",iTexture.sName);
                loader.newImage(self.tbMedia.images,iTexture.sName,iTexture.sPath);
            end
        end 
    end


    -- 开始加载
    loader.start(pfn, nil);
end 

function AssetsMgr:update(dt)
    loader.update();
end 

function AssetsMgr:draw() 
	self:DrawLoadingBar();
end 

function AssetsMgr:DrawLoadingBar()
	local separation = 30;
	local w = windows.w - 2 * separation;
	local h = 18;
	local x,y = separation, windows.h - separation - h;

	x, y = x + 3, y + 3;
	w, h = w - 6, h - 7;

	love.graphics.setColor(0.23,0.23,0.23,1);
	love.graphics.rectangle("fill", x, y, w, h,3,3);
	if loader.loadedCount > 0 then
		w = w * (loader.loadedCount / loader.resourceCount);
        love.graphics.setColor(1,1,1,0.7);
		love.graphics.rectangle("fill", x, y, w, h,3,3);
		love.graphics.setColor(1,1,1,0.19);
		love.graphics.rectangle("fill", x, y, windows.w - 2 * separation - 6, h,3,3);
		love.graphics.setColor(1,1,1,1);
	end
end 

function AssetsMgr:GetTexture(sImage)
    return self.tbMedia.images[sImage];
end 

function AssetsMgr:GetFont(nFont)
    return self.tbMedia.fonts[nFont];
end 

function AssetsMgr:GetSound(sSound)
    return self.tbMedia.sounds[sSound];
end 
