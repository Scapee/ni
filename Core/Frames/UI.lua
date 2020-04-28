local CreateFrame,
	UIFrameFadeOut,
	GetMouseFocus,
	ActionButton_GetPagedID,
	ChatFrame1,
	ActionButton_CalculateAction,
	HasAction,
	GetActionInfo =
	CreateFrame,
	UIFrameFadeOut,
	GetMouseFocus,
	ActionButton_GetPagedID,
	ChatFrame1,
	ActionButton_CalculateAction,
	HasAction,
	GetActionInfo

ni.frames.notification = CreateFrame("Frame", nil, ChatFrame1);
ni.frames.notification:SetSize(ChatFrame1:GetWidth(), 30);
ni.frames.notification:Hide();
ni.frames.notification:SetPoint("TOP", 0, 0);
ni.frames.notification.text = ni.frames.notification:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont");
ni.frames.notification.text:SetAllPoints();
ni.frames.notification.texture = ni.frames.notification:CreateTexture();
ni.frames.notification.texture:SetAllPoints();
ni.frames.notification.texture:SetTexture(0, 0, 0, .50);
function ni.frames.notification:message(message)
	self.text:SetText(message);
	self:Show();
end

ni.frames.spellqueueholder = CreateFrame("Frame");
ni.frames.spellqueueholder:ClearAllPoints();
ni.frames.spellqueueholder:SetHeight(30);
ni.frames.spellqueueholder:SetWidth(275);
ni.frames.spellqueueholder:SetMovable(true);
ni.frames.spellqueueholder:SnableMouse(true);
ni.frames.spellqueueholder:RegisterForDrag("LeftButton");
ni.frames.spellqueueholder:SetBackdrop(
	{
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	}
);
ni.frames.spellqueueholder:SetBackdropColor(0, 0, 0, 1);
ni.frames.spellqueueholder:SetPoint("CENTER", UIParent, "BOTTOM", 0, 130);
ni.frames.spellqueueholder:Hide();

ni.frames.spellqueue = CreateFrame("Frame", nil, ni.frames.spellqueueholder);
ni.frames.spellqueue:ClearAllPoints();
ni.frames.spellqueue:SetHeight(20);
ni.frames.spellqueue:SetWidth(200);
ni.frames.spellqueue:Show();
ni.frames.spellqueue.text = ni.frames.spellqueue:CreateFontString(nil, "BACKGROUND", "GameFontNormal");
ni.frames.spellqueue.text:SetAllPoints();
ni.frames.spellqueue.text:SetJustifyV("MIDDLE");
ni.frames.spellqueue.text:SetJustifyH("CENTER");
ni.frames.spellqueue.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615None");
ni.frames.spellqueue:SetPoint("CENTER", ni.frames.spellqueueholder, 0, 0);
function ni.frames.spellqueue.update(str, bool)
	local bool = true and bool or false;
	if bool then
		if ni.frames.spellqueueholder:IsShown() == nil then
			ni.frames.spellqueueholder:Show();
		end
		ni.frames.spellqueue.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615" .. GetSpellInfo(str));
	else
		ni.frames.spellqueue.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615None");
		if ni.frames.spellqueueholder:IsShown() == 1 then
			ni.frames.spellqueueholder:Hide();
		end
	end
end

ni.frames.floatingtext = CreateFrame("Frame");
ni.frames.floatingtext:setSize(400, 30);
ni.frames.floatingtext:setAlpha(0);
ni.frames.floatingtext:SetPoint("CENTER", 0, 80);
ni.frames.floatingtext.text = ni.frames.floatingtext:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont");
ni.frames.floatingtext.text:SetAllPoints();
ni.frames.floatingtext.texture = ni.frames.floatingtext:CreateTexture();
ni.frames.floatingtext.texture:SetAllPoints();
function ni.frames.floatingtext:message(message)
	self.text:SetText(message);
	UIFrameFadeOut(self, 2.5, 1, 0);
end

ni.showstatus = function(str)
	if ni.vars.profiles.enabled then
		ni.frames.floatingtext:message("\124cff00ff00" .. str);
	else
		ni.frames.floatingtext:message("\124cffff0000" .. str);
	end
end

ni.showintstatus = function()
	if ni.vars.profiles.interrupt then
		ni.frames.floatingtext:message("Interrupts: \124cff00ff00Enabled");
	else
		ni.frames.floatingtext:message("Interrupts: \124cffff0000Disabled");
	end
end

ni.updatefollow = function(enabled)
	if enabled then
		ni.frames.floatingtext:message("Auto follow: \124cff00ff00Enabled");
	else
		ni.frames.floatingtext:message("Auto follow: \124cffff0000Disabled");
	end
end

ni.getspellidfromactionbar = function()
	local focus = GetMouseFocus():GetName();
	if string.match(focus, "Button") then;
		local button = _G[focus];
		local slot =
			ActionButton_GetPagedID(button) or ActionButton_CalculateAction(button) or button:GetAttribute("action") or 0;
		if HasAction(slot) then
			local aType, aID, _, aMaxID = GetActionInfo(slot);
			if aType == "spell" then
				return aMaxID ~= nil and aMaxID or aID;
			end
		end
	end
end
