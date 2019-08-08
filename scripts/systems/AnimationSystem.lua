AnimationSystem = class("AnimationSystem",System)

function AnimationSystem:start(actors)
    local actors = actors or {};
    if not next(actors) then 
        return 
    end
    for _,actor in ipairs(actors) do 
        local compo_Animate = actor:GetCompo("Animate")
        if compo_Animate then
			self:SetFrame(compo_Animate);
			if compo_Animate:GetData("bStartPlay") then 
				self:Play(actor,compo_Animate:GetData("nStartFrame"),compo_Animate:GetData("nEndFrame"));
			end
        end
    end
end

function AnimationSystem:SetFrame(compo_Animate)
	local compo_Animate = compo_Animate or {};
	local sImg = compo_Animate:GetData("sImg");
	local iImage = assmgr:GetTexture(sImg);
	compo_Animate:SetData("iImage",iImage);
	local nQuadW = compo_Animate:GetData("nQuadW") or 0;
	local nQuadH = compo_Animate:GetData("nQuadH") or 0;
	local nOffset = compo_Animate:GetData("nOffset") or 0;
	local nStartFrame = 1;
	local nImgW,nImgH = iImage:getWidth(), iImage:getHeight();
	local nCol = math.floor(nImgW/nQuadW);
	local nRow = math.floor(nImgH/nQuadH);
	compo_Animate:SetData("tbQuad",{});
	local nFrame = 1;
	compo_Animate:SetData("nCurFrame",nFrame);
	local tbQuad = compo_Animate:GetData("tbQuad");
	for i = 0, nRow-1 do
		for j = 0, nCol-1 do
			tbQuad[nFrame] = love.graphics.newQuad(j*nQuadW, i*nQuadH, nQuadW, nQuadH, nImgW, nImgH);
			nFrame = nFrame + 1;
		end
	end
	compo_Animate:SetData("nLastTime",0);
	compo_Animate:SetData("nCurPlayCount",0);
	compo_Animate:SetData("nTotalPlayCount",compo_Animate:GetData("nTotalPlayCount") - nOffset);
	compo_Animate:SetData("iCurQuad",tbQuad[nStartFrame or compo_Animate:GetData("nCurFrame")]);
end

function AnimationSystem:update(dt,actors)
    local actors = actors or {};
    if not next(actors) then 
        return 
    end
    for _,actor in ipairs(actors) do 
        local compo_Animate = actor:GetCompo("Animate")
        if compo_Animate then
			repeat
				local compo_Animate = actor:GetCompo("Animate").data;
				if not compo_Animate.bRunning then 
					break;
				end
				local nTimeAfterPlay = compo_Animate.nTimeAfterPlay;
				local nLastTime = compo_Animate.nLastTime or 0;
				local nTotalFrame = compo_Animate.nTotalFrame;
				local nEndFrame = compo_Animate.nEndFrame;--self.nEndFrame or nTotalFrame;
				local nStartFrame = compo_Animate.nStartFrame--self.nStartFrame or 1;
				local nCurPlayCount = compo_Animate.nCurPlayCount;
				local nTotalPlayCount = compo_Animate.nTotalPlayCount;
				local fComplete = compo_Animate.fComplete or nil;
				local nLoop = compo_Animate.nLoop;
				local nNowTime = GetTime();
				nTotalFrame = nEndFrame;
				if nNowTime - nLastTime > nTimeAfterPlay then 
					compo_Animate.nLastTime = nNowTime;
					compo_Animate.nCurFrame = compo_Animate.nCurFrame + 1;
					if compo_Animate.nCurFrame > nTotalFrame then 
						if nLoop == 0 then 
							compo_Animate.nCurPlayCount = compo_Animate.nCurPlayCount + 1;
							if compo_Animate.nCurPlayCount >= nTotalPlayCount then 
								compo_Animate.iCurQuad = nil;
								compo_Animate.bRunning = false;
								if fComplete then 
									fComplete();
								end 
								break;
							else 
								compo_Animate.nCurFrame = nStartFrame;
								compo_Animate.iCurQuad = compo_Animate.tbQuad[compo_Animate.nCurFrame];
								break;
							end
						elseif nLoop == 1 then  
							compo_Animate.nCurFrame = nStartFrame;
							compo_Animate.iCurQuad = compo_Animate.tbQuad[compo_Animate.nCurFrame];
						end
					else 
						compo_Animate.iCurQuad = compo_Animate.tbQuad[compo_Animate.nCurFrame];
					end
				end 
			until true
        end
    end
end 

function AnimationSystem:draw(actors)
    local actors = actors or {};
    if not next(actors) then 
        return 
    end
    for _,actor in ipairs(actors) do 
        local compo_Animate = actor:GetCompo("Animate")
        if compo_Animate then
			repeat
				local compo_Animate = actor:GetCompo("Animate").data;
				local compo_Position = actor:GetCompo("Position").data;
				local compo_Size = actor:GetCompo("Size").data;
				local compo_Color = actor:GetCompo("Color").data;
				if not compo_Animate.bRunning then 
					break;
				end 
				local x = compo_Position.x;
				local y = compo_Position.y;
				local iImage = compo_Animate.iImage;
				if iImage == nil then 
					self:trace(1,"there is no image")
					break;
				end 
				local iCurQuad = compo_Animate.iCurQuad;
				if iCurQuad == nil then 
					self:trace(1,"there is no quad")
					break;
				end 
				local nQuadW = compo_Animate.nQuadW;
				local nQuadH = compo_Animate.nQuadH;
				local w = compo_Size.x;
				local h = compo_Size.y;
				-- local r = compo_Position.r or 0;
				-- local ox = compo_Position.ox or 0;
				-- local oy = compo_Position.oy or 0;
				-- local sx = compo_Position.sx or 1;
				-- local sy = compo_Position.sy or 1;
				local nImageX = x - (nQuadW * 0.5 - w * 0.5);
				local nImageY = y - (nQuadH - h);
				love.graphics.setColor(unpack(compo_Color.color)); 
				-- love.graphics.draw(iImage, iCurQuad, nImageX, nImageY,r,sx,sy,ox,oy)
				love.graphics.draw(iImage, iCurQuad, nImageX, nImageY)
				if bDebug then 
					-- 贴图轮廓
					love.graphics.setColor(100,100,250,100);
					love.graphics.rectangle("line", nImageX, nImageY, nQuadW, nQuadH);
					-- 底部点
					love.graphics.setColor(250,0,0,250); 
					love.graphics.circle( "fill",nImageX + nQuadW / 2, nImageY + nQuadH, 7 ) 
					-- 帧序号
					love.graphics.setColor(255,0,0,250); 
					local nCurFrame = compo_Animate.nCurFrame;
					love.graphics.print(string.format("Frame:%d",nCurFrame or 0),nImageX + nQuadW / 2, nImageY + nQuadH + 10);
				end
			until true
        end
    end
end

function AnimationSystem:Play(actor,nStartFrame,nEndFrame,fComplete)
	if not actor then 
		return;
	end
	local compo_Animate = actor:GetCompo("Animate");
	compo_Animate:SetData("bRunning", true);
	compo_Animate:SetData("nCurFrame",nStartFrame)
	compo_Animate:SetData("nStartFrame",nStartFrame)
	compo_Animate:SetData("nEndFrame",nEndFrame)
	compo_Animate:SetData("fComplete",fComplete)
end