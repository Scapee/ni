--1 - Frames.lua
local version = "1.0.0";
local GetTime = GetTime;
ni.waittable = {};
ni.waitframe = CreateFrame('Frame');
ni.waitframe:SetScript("OnUpdate", function(self, elapsed)
	local count = #ni.waittable;
	local i = 1;
	while i <= count do
		local waitRecord = tremove(ni.waittable,i);
		local d = tremove(waitRecord, 1);
		local f = tremove(waitRecord, 1);
		local p = tremove(waitRecord, 1);
		if d > elapsed then
			tinsert(ni.waittable, i, {d - elapsed, f, p});
			i = i + 1;
		else
			count = count - 1;
			f(unpack(p));
		end
	end
end);
ni.delayfor = function(delay, func, ...)
	if type(delay)~="number" or type(func)~="function" then
		return false;
	end
	tinsert(ni.waittable, {delay, func, {...}});
	return true;
end;
local function onUpdate(self,elapsed)
	if self.time == nil then
		self.time = 0;
	end
	if self.time < GetTime() - 2 then
		if self:GetAlpha() == 0 then self:Hide() else self:SetAlpha(self:GetAlpha() - .05) end
	end
end
ni.getFrameSpellID = function()
	local focus = GetMouseFocus():GetName();
	if string.match(focus, "Button") then
		local button = _G[focus];
		local slot = ActionButton_GetPagedID(button) or ActionButton_CalculateAction(button) or button:GetAttribute("action") or 0;
		if HasAction(slot) then
			local aType, aID, _, aMaxID = GetActionInfo(slot);
			if aType == "spell" then
				return aMaxID ~= nil and aMaxID or aID;
			end
		end
	end
end
ni.notification = CreateFrame('Frame', nil, ChatFrame1);
ni.notification:SetSize(ChatFrame1: GetWidth(), 30);
ni.notification:Hide();
--ni.notification:SetScript('OnUpdate', onUpdate);
ni.notification:SetPoint('TOP', 0, 0);
ni.notification.text = ni.notification:CreateFontString(nil, 'OVERLAY', 'MovieSubtitleFont');
ni.notification.text:SetAllPoints();
ni.notification.texture = ni.notification:CreateTexture();
ni.notification.texture:SetAllPoints();
ni.notification.texture:SetTexture(0, 0, 0, .50);
ni.message = function(message)
	ni.notification.text:SetText(message);
	ni.notification:Show();
end;
ni.Frame1 = CreateFrame('Frame');
ni.Frame1:ClearAllPoints();
ni.Frame1:SetHeight(30);
ni.Frame1:SetWidth(275);
ni.Frame1:SetMovable(true);
ni.Frame1:EnableMouse(true);
ni.Frame1:RegisterForDrag('LeftButton');
ni.Frame1:SetScript('OnDragStart', ni.Frame1.StartMoving);
ni.Frame1:SetScript('OnDragStop', ni.Frame1.StopMovingOrSizing);
ni.Frame1:SetBackdrop({
				bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
				edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
				tile = true, tileSize = 16, edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 }
			} );
ni.Frame1:SetBackdropColor(0, 0, 0, 1);
ni.Frame1:SetPoint('CENTER', UIParent, 'BOTTOM', 0, 130);
ni.Frame1:Hide();
ni.Info = CreateFrame('Frame', nil, ni.Frame1);
ni.Info:ClearAllPoints();
ni.Info:SetHeight(20);
ni.Info:SetWidth(200);
ni.Info:Show();
ni.Info.text = ni.Info:CreateFontString(nil, 'BACKGROUND', 'GameFontNormal');
ni.Info.text:SetAllPoints();
ni.Info.text:SetJustifyV('MIDDLE');
ni.Info.text:SetJustifyH('CENTER');
ni.Info.text:SetText('\124cFFFFFFFFQueued Ability: \124cFF15E615None');
ni.Info:SetPoint('CENTER', ni.Frame1, 0, 0);
ni.Info.update = function(str, bool)
	local bool = true and bool or false;
	if bool then
		if ni.Frame1:IsShown() == nil then
			ni.Frame1:Show();
		end
        ni.Info.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615"..GetSpellInfo(str));
    else
        ni.Info.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615None");
		if ni.Frame1:IsShown() == 1 then
			ni.Frame1:Hide();
		end
	end
end
local messanger = CreateFrame('Frame',nil,UIParent) 
messanger:SetSize(ChatFrame1:GetWidth(), 30)
messanger:Hide()
messanger:SetPoint('CENTER', 0, 70)
messanger.text = messanger:CreateFontString(nil, 'OVERLAY', 'MovieSubtitleFont')
messanger.text:SetAllPoints()
messanger.texture = messanger:CreateTexture()
messanger.texture:SetAllPoints()
function messanger:message(message)
	self.text:SetText(message)
	self:SetAlpha(1)
	self:Show()
end
ni.FloatingText = CreateFrame('Frame');
ni.FloatingText:SetSize(400, 30);
ni.FloatingText:SetAlpha(0);
ni.FloatingText:SetPoint('CENTER', 0, 80);
ni.FloatingText.text = ni.FloatingText:CreateFontString(nil,'OVERLAY','MovieSubtitleFont');
ni.FloatingText.text:SetAllPoints();
ni.FloatingText.texture = ni.FloatingText:CreateTexture();
ni.FloatingText.texture:SetAllPoints();
function ni.FloatingText:Message(message)
	self.text:SetText(message);
	UIFrameFadeOut(self, 2.5, 1, 0);
end
ni.showstatus = function(str)
	if ni.vars.profiles.enabled then
		ni.FloatingText:Message('\124cff00ff00'..str);
	else
		ni.FloatingText:Message('\124cffff0000'..str);
	end
end
ni.showintstatus = function()
	if ni.vars.profiles.interrupt then
		ni.FloatingText:Message('Interrupts: \124cff00ff00Enabled');
	else
		ni.FloatingText:Message('Interrupts: \124cffff0000Disabled');
	end
end
ni.updatefollow = function(enabled)
	if enabled then
		ni.FloatingText:Message('Auto follow: \124cff00ff00Enabled');
	else
		ni.FloatingText:Message('Auto follow: \124cffff0000Disabled');
	end
end