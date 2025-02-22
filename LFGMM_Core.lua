--[[
	LFG MatchMaker - Addon for World of Warcraft.
	Version: 1.0.9
	URL: https://github.com/AvilanHauxen/LFG_MatchMaker
	Copyright (C) 2019-2020 L.I.R.

	This file is part of 'LFG MatchMaker' addon for World of Warcraft.

    'LFG MatchMaker' is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    'LFG MatchMaker' is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with 'LFG MatchMaker'. If not, see <https://www.gnu.org/licenses/>.
]]--


------------------------------------------------------------------------------------------------------------------------
-- CORE
------------------------------------------------------------------------------------------------------------------------


function LFGMM_Core_Initialize()
	tinsert(UISpecialFrames, "LFGMM_MainWindow");

	LFGMM_LfgTab_Initialize();
	LFGMM_LfmTab_Initialize();
	LFGMM_ListTab_Initialize();
	LFGMM_SettingsTab_Initialize();
	LFGMM_PopupWindow_Initialize();
	LFGMM_MinimapButton_Initialize();
	LFGMM_BroadcastWindow_Initialize();

	LFGMM_Core_SetInfoWindowLocations();

	if (LFGMM_DB.SETTINGS.ShowQuestLogButton) then
		LFGMM_QuestLog_Button_Frame:Show();
	end

	LFGMM_MainWindow:RegisterForDrag("LeftButton");
	LFGMM_MainWindow:SetScript("OnDragStart", LFGMM_MainWindow.StartMoving);
	LFGMM_MainWindow:SetScript("OnDragStop", LFGMM_MainWindow.StopMovingOrSizing);
	LFGMM_MainWindow:SetScript("OnShow", function() PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN); LFGMM_Core_Refresh(); end);
	LFGMM_MainWindow:SetScript("OnHide", function() PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE); end);

	LFGMM_MainWindowTab1:SetScript("OnClick", function() PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB); LFGMM_LfgTab_Show(); end);
	LFGMM_MainWindowTab2:SetScript("OnClick", function() PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB); LFGMM_LfmTab_Show(); end);
	LFGMM_MainWindowTab3:SetScript("OnClick", function() PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB); LFGMM_ListTab_Show(); end);
	LFGMM_MainWindowTab4:SetScript("OnClick", function() PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB); LFGMM_SettingsTab_Show(); end);

	PanelTemplates_SetNumTabs(LFGMM_MainWindow, 4);

	local groupSize = table.getn(LFGMM_GLOBAL.GROUP_MEMBERS);
	if (groupSize > 1) then
		LFGMM_LfmTab_Show();
	else
		LFGMM_LfgTab_Show();
	end

	LFGMM_GLOBAL.READY = true;
end


function LFGMM_Core_Refresh()
	LFGMM_LfgTab_Refresh();
	LFGMM_LfmTab_Refresh();
	LFGMM_ListTab_Refresh();
end


function LFGMM_Core_MainWindow_ToggleShow()
	if (LFGMM_MainWindow:IsVisible()) then
		LFGMM_LfgTab_BroadcastMessageInfoWindow:Hide();
		LFGMM_LfmTab_BroadcastMessageInfoWindow:Hide();
		LFGMM_SettingsTab_RequestInviteMessageInfoWindow:Hide();
		LFGMM_SettingsTab_ChannelsDropDownInfoWindow:Hide();
		LFGMM_ListTab_MessageInfoWindow_Hide();
		LFGMM_ListTab_ConfirmForgetAll:Hide();
		LFGMM_MainWindow:Hide();
	else
		LFGMM_LfgTab_BroadcastMessageInfoWindow:Hide();
		LFGMM_LfmTab_BroadcastMessageInfoWindow:Hide();
		LFGMM_SettingsTab_RequestInviteMessageInfoWindow:Hide();
		LFGMM_SettingsTab_ChannelsDropDownInfoWindow:Hide();
		LFGMM_ListTab_MessageInfoWindow_Hide();
		LFGMM_ListTab_ConfirmForgetAll:Hide();
		LFGMM_MainWindow:Show();
		LFGMM_Core_Refresh();
		LFGMM_Core_SetGuiEnabled(true);
	end
end


function LFGMM_Core_SetGuiEnabled(enabled)
	if (enabled) then
		LFGMM_DisableMainWindowOverlay:Hide();
		LFGMM_MainWindowTab1:Enable();
		LFGMM_MainWindowTab2:Enable();
		LFGMM_MainWindowTab3:Enable();
		LFGMM_MainWindowTab4:Enable();
	else
		LFGMM_DisableMainWindowOverlay:Show();
		LFGMM_MainWindowTab1:Disable();
		LFGMM_MainWindowTab2:Disable();
		LFGMM_MainWindowTab3:Disable();
		LFGMM_MainWindowTab4:Disable();
	end
end


function LFGMM_Core_SetInfoWindowLocations()
	if (LFGMM_DB.SETTINGS.InfoWindowLocation == "right") then
		LFGMM_SettingsTab_InfoWindowLocationButton:SetText("right >");

		LFGMM_LfgTab_BroadcastMessageInfoWindow:ClearAllPoints();
		LFGMM_LfgTab_BroadcastMessageInfoWindow:SetPoint("BOTTOMLEFT", "LFGMM_MainWindow", "BOTTOMRIGHT", 10, -2);

		LFGMM_LfmTab_BroadcastMessageInfoWindow:ClearAllPoints();
		LFGMM_LfmTab_BroadcastMessageInfoWindow:SetPoint("BOTTOMLEFT", "LFGMM_MainWindow", "BOTTOMRIGHT", 10, -2);

		LFGMM_ListTab_MessageInfoWindow:ClearAllPoints();
		LFGMM_ListTab_MessageInfoWindow:SetPoint("BOTTOMLEFT", "LFGMM_MainWindow", "BOTTOMRIGHT", 10, -2);

		LFGMM_SettingsTab_RequestInviteMessageInfoWindow:ClearAllPoints();
		LFGMM_SettingsTab_RequestInviteMessageInfoWindow:SetPoint("BOTTOMLEFT", "LFGMM_MainWindow", "BOTTOMRIGHT", 10, -2);

		LFGMM_SettingsTab_ChannelsDropDownInfoWindow:ClearAllPoints();
		LFGMM_SettingsTab_ChannelsDropDownInfoWindow:SetPoint("BOTTOMLEFT", "LFGMM_MainWindow", "BOTTOMRIGHT", 10, -2);
	else
		LFGMM_SettingsTab_InfoWindowLocationButton:SetText("< left");

		LFGMM_LfgTab_BroadcastMessageInfoWindow:ClearAllPoints();
		LFGMM_LfgTab_BroadcastMessageInfoWindow:SetPoint("BOTTOMRIGHT", "LFGMM_MainWindow", "BOTTOMLEFT", -10, -2);

		LFGMM_LfmTab_BroadcastMessageInfoWindow:ClearAllPoints();
		LFGMM_LfmTab_BroadcastMessageInfoWindow:SetPoint("BOTTOMRIGHT", "LFGMM_MainWindow", "BOTTOMLEFT", -10, -2);

		LFGMM_ListTab_MessageInfoWindow:ClearAllPoints();
		LFGMM_ListTab_MessageInfoWindow:SetPoint("BOTTOMRIGHT", "LFGMM_MainWindow", "BOTTOMLEFT", -10, -2);

		LFGMM_SettingsTab_RequestInviteMessageInfoWindow:ClearAllPoints();
		LFGMM_SettingsTab_RequestInviteMessageInfoWindow:SetPoint("BOTTOMRIGHT", "LFGMM_MainWindow", "BOTTOMLEFT", -10, -2);

		LFGMM_SettingsTab_ChannelsDropDownInfoWindow:ClearAllPoints();
		LFGMM_SettingsTab_ChannelsDropDownInfoWindow:SetPoint("BOTTOMRIGHT", "LFGMM_MainWindow", "BOTTOMLEFT", -10, -2);
	end
end


function LFGMM_Core_StartWhoCooldown()
	if (LFGMM_GLOBAL.WHO_COOLDOWN <= 0) then
		LFGMM_GLOBAL.WHO_COOLDOWN = 5;
		C_Timer.After(1, LFGMM_Core_WhoCooldown);
	end
end


function LFGMM_Core_WhoCooldown()
	LFGMM_GLOBAL.WHO_COOLDOWN = LFGMM_GLOBAL.WHO_COOLDOWN - 1;

	LFGMM_ListTab_MessageInfoWindow_Refresh();
	LFGMM_PopupWindow_Refresh();

	if (LFGMM_GLOBAL.WHO_COOLDOWN > 0) then
		C_Timer.After(1, LFGMM_Core_WhoCooldown);
	end
end


function LFGMM_Core_WhoRequest(message)
	-- Send who request
	C_FriendList.SendWho("n-\"" .. message.Player .. "\"");

	-- Start cooldown
	LFGMM_Core_StartWhoCooldown();
end


function LFGMM_Core_Ignore(message)
	-- Ignore message for current type
	message.Ignore[message.Type] = true;
end


function LFGMM_Core_Invite(message)
	-- Invite player
	InviteUnit(message.Player);

	-- Mark as contacted
	message.Invited = true;
end


function LFGMM_Core_RequestInvite(message)
	-- Send request
	local whisper = LFGMM_DB.SETTINGS.RequestInviteMessage;
	SendChatMessage(whisper, "WHISPER", nil, message.Player);

	-- Mark as contacted
	message.InviteRequested = true;
end


function LFGMM_Core_OpenWhisper(message)
	ChatFrame_SendTell(message.Player, DEFAULT_CHAT_FRAME);
end


function LFGMM_Core_RemoveUnavailableDungeonsFromSelections()
	local removeSelections = {};
	for _,dungeon in ipairs(LFGMM_Utility_GetAllUnavailableDungeonsAndRaids()) do
		table.insert(removeSelections, dungeon.Index);

		if (not LFGMM_DB.SEARCH.LFM.Running and LFGMM_DB.SEARCH.LFM.Dungeon == dungeon.Index) then
			LFGMM_DB.SEARCH.LFM.Dungeon = nil;
		end
	end

	LFGMM_Utility_ArrayRemove(LFGMM_DB.LIST.Dungeons, removeSelections);

	if (not LFGMM_DB.SEARCH.LFG.Running) then
		LFGMM_Utility_ArrayRemove(LFGMM_DB.SEARCH.LFG.Dungeons, removeSelections);
	end

	LFGMM_LfgTab_DungeonsDropDown_UpdateText();
	LFGMM_LfgTab_UpdateBroadcastMessage();

	LFGMM_LfmTab_DungeonsDropDown_UpdateText();
	LFGMM_LfmTab_UpdateBroadcastMessage();

	LFGMM_ListTab_DungeonsDropDown_UpdateText(LFGMM_KEYS.DUNGEON_CATEGORIES.VANILLA);
	LFGMM_ListTab_DungeonsDropDown_UpdateText(LFGMM_KEYS.DUNGEON_CATEGORIES.TBC);
	LFGMM_ListTab_DungeonsDropDown_UpdateText(LFGMM_KEYS.DUNGEON_CATEGORIES.PVP);
end


function LFGMM_Core_GetGroupMembers()
	local groupMembers = {};

	-- Raid
	for index=1, 40 do
		local playerName = UnitName("raid" .. index);
		if (playerName ~= nil) then
			table.insert(groupMembers, playerName);
		end
	end

	-- Party
	if (table.getn(groupMembers) == 0) then
		local player = UnitName("player");
		table.insert(groupMembers, player);

		for index=1, 4 do
			local playerName = UnitName("party" .. index);
			if (playerName ~= nil) then
				table.insert(groupMembers, playerName);
			end
		end
	end

	-- Store group members
	LFGMM_GLOBAL.GROUP_MEMBERS = groupMembers;
end

function LFGMM_Core_GetCategoryByCode(categoryCode)
	for _, category in ipairs(LFGMM_GLOBAL.CATEGORIES) do
		if category.Code == categoryCode then
			return category;
		end
	end

	return nil;
end

function LFGMM_Core_GetModeByCode(modeCode)
	for _, mode in ipairs(LFGMM_GLOBAL.MODES) do
		if mode.Code == modeCode then
			return mode;
		end
	end

	return nil;
end

function LFGMM_Core_FindSearchMatch()
	-- Return if stopped
	if (not LFGMM_DB.SEARCH.LFG.Running and not LFGMM_DB.SEARCH.LFM.Running) then
		return;
	end

	-- Return if match popup window is open
	if (LFGMM_PopupWindow:IsVisible()) then
		return;
	end

	-- Ensure lock
	if (LFGMM_GLOBAL.SEARCH_LOCK) then
		return;
	end

	-- Lock
	LFGMM_GLOBAL.SEARCH_LOCK = true;

	-- Determine dungeons to search for
	local searchDungeonIndexes = {};
	if (LFGMM_DB.SEARCH.LFG.Running) then
		searchDungeonIndexes = LFGMM_DB.SEARCH.LFG.Dungeons;
	elseif (LFGMM_DB.SEARCH.LFM.Running) then
		searchDungeonIndexes = { LFGMM_DB.SEARCH.LFM.Dungeon };
	end

	-- Get max message age
	local maxMessageAge = time() - (60 * LFGMM_DB.SETTINGS.MaxMessageAge);

	-- Look for messages matching search criteria and show popup
	for _,message in pairs(LFGMM_GLOBAL.MESSAGES) do
		local skip = false;

		-- Skip ignored
		if (message.Ignore[message.Type] ~= nil) then
			skip = true;

		-- Skip old
		elseif (message.Timestamp < maxMessageAge) then
			skip = true;

		-- Skip contacted
		elseif (message.Type == "LFG" and message.Invited) then
			skip = true;

		elseif (message.Type == "LFM" and message.InviteRequested) then
			skip = true;

		elseif (message.Type == "UNKNOWN" and (message.Invited or message.InviteRequested)) then
			skip = true;

		-- Skip LFG and/or UNKNOWN match for LFG search
		elseif (LFGMM_DB.SEARCH.LFG.Running) then
			if not message.ShowAsLfgMatch then
				skip = true;
			end

			if (message.Type == "LFG" and not LFGMM_DB.SEARCH.LFG.MatchLfg) then
				skip = true;
			elseif (message.Type == "UNKNOWN" and not LFGMM_DB.SEARCH.LFG.MatchUnknown) then
				skip = true;
			end

		-- Skip LFM and/or UNKNOWN match for LFM search
		elseif (LFGMM_DB.SEARCH.LFM.Running) then
			if not message.ShowAsLfmMatch then
				skip = true;
			end

			if (message.Type == "LFM" and not LFGMM_DB.SEARCH.LFM.MatchLfm) then
				skip = true;
			elseif (message.Type == "UNKNOWN" and not LFGMM_DB.SEARCH.LFM.MatchUnknown) then
				skip = true;
			end

		-- Skip messages from group members
		elseif (LFGMM_Utility_ArrayContains(LFGMM_GLOBAL.GROUP_MEMBERS, message.Player)) then
			skip = true;
		end

		-- Find dungeon match
		if (not skip) then
			for _,searchDungeonIndex in ipairs(searchDungeonIndexes) do
				for _,dungeon in ipairs(message.Dungeons) do
					if (dungeon.Index == searchDungeonIndex) then
						LFGMM_PopupWindow_ShowForMatch(message);
						return;
					end
				end
			end
		end
	end

	-- Release lock if popup window has not been shown
	if (not LFGMM_PopupWindow:IsVisible()) then
		LFGMM_GLOBAL.SEARCH_LOCK = false;
	end
end


function LFGMM_Core_JoinChannels()
	LFGMM_GLOBAL.LFG_CHANNEL_NAME = LFGMM_Utility_GetLfgChannelName();
	JoinTemporaryChannel(LFGMM_GLOBAL.LFG_CHANNEL_NAME);

	LFGMM_GLOBAL.GENERAL_CHANNEL_NAME = LFGMM_Utility_GetGeneralChannelName();
	if (LFGMM_DB.SETTINGS.UseGeneralChannel) then
		JoinTemporaryChannel(LFGMM_GLOBAL.GENERAL_CHANNEL_NAME);
	end

	LFGMM_GLOBAL.TRADE_CHANNEL_NAME, LFGMM_GLOBAL.TRADE_CHANNEL_AVAILABLE = LFGMM_Utility_GetTradeChannelName();
	if (LFGMM_DB.SETTINGS.UseTradeChannel and LFGMM_GLOBAL.TRADE_CHANNEL_AVAILABLE) then
		JoinTemporaryChannel(LFGMM_GLOBAL.TRADE_CHANNEL_NAME);
	end

	LFGMM_SettingsTab_ChannelsDropDown_UpdateText();
end

function LFGMM_Core_IsHc(message)
	local nhcFound = LFGMM_Utility_IsMatchForAnyLanguage(message, LFGMM_GLOBAL.NOT_HC_IDENTIFIERS);
	if nhcFound then
		return false;
	end

	local hcFound = LFGMM_Utility_IsMatchForAnyLanguage(message, LFGMM_GLOBAL.HC_IDENTIFIERS);
	if hcFound then
		return true;
	end

	return false;
end

function LFGMM_Core_ValidatesAgainstModeFilter(message, lfgOrLfmNode)
	if lfgOrLfmNode["Running"] and lfgOrLfmNode["Category"] == LFGMM_KEYS.DUNGEON_CATEGORIES.TBC then
		local isHc = LFGMM_Core_IsHc(message);
		if lfgOrLfmNode["Mode"] == LFGMM_KEYS.DUNGEON_MODES.HC and not isHc then
			return false;
		elseif lfgOrLfmNode["Mode"] == LFGMM_KEYS.DUNGEON_MODES.NHC and isHc then
			return false;
		end
	end

	return true;
end

function LFGMM_Core_IsBoost(message)
	local noBoostFound = LFGMM_Utility_IsMatchForAnyLanguage(message, LFGMM_GLOBAL.NOT_BOOST_IDENTIFIERS);
	if noBoostFound then
		return false;
	end

	local boostFound = LFGMM_Utility_IsMatchForAnyLanguage(message, LFGMM_GLOBAL.BOOST_IDENTIFIERS);
	if boostFound then
		return true;
	end

	return false;
end

function LFGMM_Core_ValidatesAgainstBoostFilter(message, lfgOrLfmNode)
	if lfgOrLfmNode["Running"] and lfgOrLfmNode["IgnoreBoosts"] then
		local isBoost = LFGMM_Core_IsBoost(message);
		if isBoost then
			return false;
		end
	end

	return true;
end

------------------------------------------------------------------------------------------------------------------------
-- EVENT HANDLER
------------------------------------------------------------------------------------------------------------------------

function LFGMM_Core_EventHandler(self, event, ...)
	-- Initialize
	if (not LFGMM_GLOBAL.READY and event == "PLAYER_ENTERING_WORLD") then
		-- Get player info
		LFGMM_GLOBAL.PLAYER_NAME = UnitName("player");
		LFGMM_GLOBAL.PLAYER_LEVEL = UnitLevel("player");
		LFGMM_GLOBAL.PLAYER_CLASS = LFGMM_GLOBAL.CLASSES[select(2, UnitClass("player"))];

		-- Get group members
		LFGMM_Core_GetGroupMembers();

		-- Load
		LFGMM_Load();
		LFGMM_Core_Initialize();

		-- Join channels
		C_Timer.After(5, function()
			LFGMM_Core_JoinChannels();
		end);

	-- Return if not ready
	elseif (not LFGMM_GLOBAL.READY) then
		return;

	-- Zone changed (join channels)
	elseif (event == "ZONE_CHANGED_NEW_AREA") then
		C_Timer.After(5, function()
			LFGMM_Core_JoinChannels();
		end);

	-- Update player level
	elseif (event == "PLAYER_LEVEL_UP") then
		LFGMM_GLOBAL.PLAYER_LEVEL = select(1, ...);
		LFGMM_LfgTab_UpdateBroadcastMessage();
		LFGMM_SettingsTab_UpdateRequestInviteMessage();

	-- Show invited popup
	elseif (event == "PARTY_INVITE_REQUEST") then
		local player = select(1, ...);
		local message = LFGMM_GLOBAL.MESSAGES[player];

		if (message ~= nil) then
			LFGMM_PopupWindow_ShowForInvited(message);
			LFGMM_PopupWindow_MoveToPartyInviteDialog();
		end

	-- Parse /who response for player level
	elseif (event == "CHAT_MSG_SYSTEM") then
		local message = select(1, ...);
		local player, level = string.match(message, "%[(.+)%]%ph%s?: [^%s]* (%d*)");

		if (LFGMM_GLOBAL.MESSAGES[player] ~= nil) then
			LFGMM_GLOBAL.MESSAGES[player].PlayerLevel = level;

			LFGMM_ListTab_Refresh();
			LFGMM_ListTab_MessageInfoWindow_Refresh();
			LFGMM_PopupWindow_Refresh();
		end

	-- Update group members
	elseif (event == "GROUP_ROSTER_UPDATE") then
		LFGMM_Core_GetGroupMembers();

		LFGMM_Core_Refresh();
		LFGMM_LfmTab_UpdateBroadcastMessage();
		LFGMM_ListTab_MessageInfoWindow_Refresh();

		-- Get group size
		local groupSize = table.getn(LFGMM_GLOBAL.GROUP_MEMBERS);

		-- Abort LFG if group is joined
		if (LFGMM_DB.SEARCH.LFG.Running and LFGMM_DB.SEARCH.LFG.AutoStop and LFGMM_GLOBAL.AUTOSTOP_AVAILABLE) then
			if (groupSize > 1) then
				LFGMM_DB.SEARCH.LFG.Running = false;
				LFGMM_PopupWindow_Hide();
				LFGMM_BroadcastWindow_CancelBroadcast();

				LFGMM_MainWindowTab1:Show();
				LFGMM_MainWindowTab2:Show();

				LFGMM_Core_Refresh();
				LFGMM_Core_RemoveUnavailableDungeonsFromSelections();

				LFGMM_MinimapButton_Refresh();
			end

		-- Abort LFM if dungeon group size is reached
		elseif (LFGMM_DB.SEARCH.LFM.Running and LFGMM_DB.SEARCH.LFM.AutoStop and LFGMM_GLOBAL.AUTOSTOP_AVAILABLE) then
			local dungeonSize = LFGMM_GLOBAL.DUNGEONS[LFGMM_DB.SEARCH.LFM.Dungeon].Size;
			if (groupSize >= dungeonSize) then
				LFGMM_DB.SEARCH.LFM.Running = false;
				LFGMM_PopupWindow_Hide();
				LFGMM_BroadcastWindow_CancelBroadcast();

				LFGMM_MainWindowTab1:Show();
				LFGMM_MainWindowTab2:Show();

				LFGMM_Core_Refresh();
				LFGMM_Core_RemoveUnavailableDungeonsFromSelections();

				LFGMM_MinimapButton_Refresh();
			end
		end

	-- Parse LFG channel message
	elseif (event == "CHAT_MSG_CHANNEL") then
		local channelName = select(9, ...);

		local isGeneralChannel = string.find(channelName, "^" .. LFGMM_GLOBAL.GENERAL_CHANNEL_NAME);
		local isTradeChannel = string.find(channelName, "^" .. LFGMM_GLOBAL.TRADE_CHANNEL_NAME);

		if (channelName == LFGMM_GLOBAL.LFG_CHANNEL_NAME or
			(isGeneralChannel and LFGMM_DB.SETTINGS.UseGeneralChannel) or
			(isTradeChannel and LFGMM_DB.SETTINGS.UseTradeChannel))
		then
			local now = time();
			local player = select(5, ...);
			local playerGuid = select(12, ...);
			local messageOrg = select(1, ...);

			-- Ignore own messages
			if (player == LFGMM_GLOBAL.PLAYER_NAME) then
				return;
			end

			local message = LFGMM_Utility_NormalizeChatMessage(messageOrg, LFGMM_DB.SETTINGS.IdentifierLanguages);
			local uniqueDungeonMatches = LFGMM_Utility_CreateUniqueDungeonsList();
			local showAsLfgMatch, showAsLfmMatch = true, true;

			-- Boost filter validation
			showAsLfgMatch = showAsLfgMatch and LFGMM_Core_ValidatesAgainstBoostFilter(message, LFGMM_DB.SEARCH.LFG);
			showAsLfmMatch = showAsLfmMatch and LFGMM_Core_ValidatesAgainstBoostFilter(message, LFGMM_DB.SEARCH.LFM);

			-- Mode filter validation
			showAsLfgMatch = showAsLfgMatch and LFGMM_Core_ValidatesAgainstModeFilter(message, LFGMM_DB.SEARCH.LFG);
			showAsLfmMatch = showAsLfmMatch and LFGMM_Core_ValidatesAgainstModeFilter(message, LFGMM_DB.SEARCH.LFM);

			-- Find dungeon matches
			for _,dungeon in ipairs(LFGMM_GLOBAL.DUNGEONS) do
				local matched = false;

				for _,languageCode in ipairs(LFGMM_DB.SETTINGS.IdentifierLanguages) do
					if (dungeon.Identifiers[languageCode] ~= nil) then
						for _,identifier in ipairs(dungeon.Identifiers[languageCode]) do
							if LFGMM_Utility_IsMatch(message, identifier) then
								matched = true;
								break;
							end
						end
					end

					if (matched) then
						break;
					end
				end

				if (matched and dungeon.NotIdentifiers ~= nil) then
					for _,languageCode in ipairs(LFGMM_DB.SETTINGS.IdentifierLanguages) do
						if (dungeon.NotIdentifiers[languageCode] ~= nil) then
							for _,notIdentifier in ipairs(dungeon.NotIdentifiers[languageCode]) do
								if LFGMM_Utility_IsMatch(message, notIdentifier) then
									matched = false;
									break;
								end
							end
						end

						if (not matched) then
							break;
						end
					end
				end

				if (matched) then
					uniqueDungeonMatches:Add(dungeon);

					if (dungeon.ParentDungeon ~= nil) then
						uniqueDungeonMatches:Add(LFGMM_GLOBAL.DUNGEONS[dungeon.ParentDungeon]);
					end
				end
			end

			-- Find dungeon fallback matches
			for _,dungeonsFallback in ipairs(LFGMM_GLOBAL.DUNGEONS_FALLBACK) do
				local matched = false;

				for _,languageCode in ipairs(LFGMM_DB.SETTINGS.IdentifierLanguages) do
					if (dungeonsFallback.Identifiers[languageCode] ~= nil) then
						for _,identifier in ipairs(dungeonsFallback.Identifiers[languageCode]) do
							if LFGMM_Utility_IsMatch(message, identifier) then
								matched = true;
								break;
							end
						end
					end

					if (matched) then
						break;
					end
				end

				if (matched) then
					local singleInFallbackMatched = false;

					for _,dungeonIndex in ipairs(dungeonsFallback.Dungeons) do
						if (uniqueDungeonMatches.List[dungeonIndex] ~= nil) then
							singleInFallbackMatched = true;
							break;
						end
					end

					if (not singleInFallbackMatched) then
						for _,dungeonIndex in ipairs(dungeonsFallback.Dungeons) do
							local dungeon = LFGMM_GLOBAL.DUNGEONS[dungeonIndex];
							uniqueDungeonMatches:Add(dungeon);

							if (dungeon.ParentDungeon ~= nil) then
								uniqueDungeonMatches:Add(LFGMM_GLOBAL.DUNGEONS[dungeon.ParentDungeon]);
							end
						end
					end
				end
			end

			-- Remove Deadmines or Dire Maul if both are matched by the "DM" identifier and another dungeon is mentioned, based on level of the other dungeon.
			if (uniqueDungeonMatches.List[3] ~= nil and
				uniqueDungeonMatches.List[39] ~= nil and
				uniqueDungeonMatches.List[40] == nil and
				uniqueDungeonMatches.List[41] == nil and
				uniqueDungeonMatches.List[42] == nil and
				uniqueDungeonMatches.List[43] == nil)
			then
				for _,dungeon in ipairs(uniqueDungeonMatches:GetDungeonList()) do
					-- Remove Dire Maul as match if low level dungeon is mentioned
					if (dungeon.Index ~= 3 and dungeon.MinLevel <= 30) then
						uniqueDungeonMatches:Remove(LFGMM_GLOBAL.DUNGEONS[39]);
						break;
					end

					-- Remove Deadmines as match if high level dungeon is mentioned
					if (dungeon.Index ~= 39 and dungeon.MinLevel >= 50) then
						uniqueDungeonMatches:Remove(LFGMM_GLOBAL.DUNGEONS[3]);
						break;
					end
				end
			end

			-- "Any dungeon" match
			local isAnyDungeonMatch = LFGMM_Utility_ArrayContainsAll(uniqueDungeonMatches:GetIndexList(), LFGMM_GLOBAL.DUNGEONS_FALLBACK[4].Dungeons);

			-- Convert to indexed list
			local dungeonMatches = uniqueDungeonMatches:GetDungeonList();

			-- Find type of message (LFG / LFM / UNKNOWN)
			local typeMatch = nil;
			for _,languageCode in ipairs(LFGMM_DB.SETTINGS.IdentifierLanguages) do
				if (LFGMM_GLOBAL.MESSAGETYPE_IDENTIFIERS[languageCode] ~= nil) then
					for _,identifierCollection in ipairs(LFGMM_GLOBAL.MESSAGETYPE_IDENTIFIERS[languageCode]) do
						for _,identifier in ipairs(identifierCollection.Identifiers) do
							if (string.find(message, identifier) ~= nil) then
								typeMatch = identifierCollection.Type;
							end
						end

						if (typeMatch ~= nil) then
							break;
						end
					end
				end

				if (typeMatch ~= nil) then
					break;
				end
			end

			if (typeMatch == nil) then
				typeMatch = "UNKNOWN";

				if (table.getn(dungeonMatches) > 0) then
					if (string.find(message, "wts.-boost") ~= nil) then
						typeMatch = "LFM";
					elseif (string.find(message, "wtb.-boost") ~= nil) then
						typeMatch = "LFG";
					elseif (string.find(message, "heal[i]?[n]?[g]?[%W]*service[s]?") ~= nil or string.find(message, "tank[i]?[n]?[g]?[%W]*service[s]?") ~= nil) then
						typeMatch = "LFG";
					end
				end
			end

			if (typeMatch == "UNKNOWN" and table.getn(dungeonMatches) == 0) then
				-- Ignore general and trade messages without dungeon and type match
				if (isGeneralChannel or isTradeChannel) then
					return;
				end

				-- Ignore WTB and WTS messages
				if (string.find(message, "wtb") ~= nil or string.find(message, "wts") ~= nil) then
					return;
				end
			end

			-- Find sort index
			local messageSortIndex;
			if (table.getn(dungeonMatches) == 0) then
				messageSortIndex = -1;

			elseif (isAnyDungeonMatch) then
				messageSortIndex = 0;

			else
				table.sort(dungeonMatches, function(left, right) return left.Index < right.Index; end);
				messageSortIndex = dungeonMatches[1].Index;

				-- Sort by first subdungeon (if present) if first dungeon is a parent
				if (dungeonMatches[1].SubDungeons ~= nil and table.getn(dungeonMatches) > 1) then
					if (LFGMM_Utility_ArrayContains(dungeonMatches[1].SubDungeons, dungeonMatches[2].Index)) then
						messageSortIndex = dungeonMatches[2].Index;
					end
				end
			end

			-- Remove icons from message
			messageOrg = string.gsub(messageOrg, "{[rR][tT][%d]}", "");
			messageOrg = string.gsub(messageOrg, "{[sS][tT][aA][rR]}", "");
			messageOrg = string.gsub(messageOrg, "{[yY][eE][lL][lL][oO][wW]}", "");
			messageOrg = string.gsub(messageOrg, "{[cC][iI][rR][cC][lL][eE]}", "");
			messageOrg = string.gsub(messageOrg, "{[oO][rR][aA][nN][gG][eE]}", "");
			messageOrg = string.gsub(messageOrg, "{[dD][iI][aA][mM][oO][nN][dD]}", "");
			messageOrg = string.gsub(messageOrg, "{[pP][uU][rR][pP][lL][eE]}", "");
			messageOrg = string.gsub(messageOrg, "{[tT][rR][iI][aA][nN][gG][lL][eE]}", "");
			messageOrg = string.gsub(messageOrg, "{[gG][rR][eE][eE][nN]}", "");
			messageOrg = string.gsub(messageOrg, "{[mM][oO][oO][nN]}", "");
			messageOrg = string.gsub(messageOrg, "{[sS][qQ][uU][aA][rR][eE]}", "");
			messageOrg = string.gsub(messageOrg, "{[bB][lL][uU][eE]}", "");
			messageOrg = string.gsub(messageOrg, "{[cC][rR][oO][sS][sS]}", "");
			messageOrg = string.gsub(messageOrg, "{[xX]}", "");
			messageOrg = string.gsub(messageOrg, "{[rR][eE][dD]}", "");
			messageOrg = string.gsub(messageOrg, "{[sS][kK][uU][lL][lL]}", "");
			messageOrg = string.gsub(messageOrg, "{[wW][hH][iI][tT][eE]}", "");

			-- Trim spaces and remove double spaces in message
			while (string.find(messageOrg, "%s%s") ~= nil) do
				messageOrg = string.gsub(messageOrg, "%s%s", " ");
			end
			messageOrg = string.gsub(messageOrg, "^%s", "");
			messageOrg = string.gsub(messageOrg, "%s$", "");

			-- Update existing message
			if (LFGMM_GLOBAL.MESSAGES[player] ~= nil) then
				local savedMessage = LFGMM_GLOBAL.MESSAGES[player];

				-- Ignore message if previous message from player matched dungeons and the new message dont match any
				if (table.getn(savedMessage.Dungeons) > 0 and table.getn(dungeonMatches) == 0) then
					return;
				end

				-- Update message
				savedMessage.Timestamp = now;
				savedMessage.Type = typeMatch;
				savedMessage.Message = messageOrg;
				savedMessage.Dungeons = dungeonMatches;
				savedMessage.SortIndex = messageSortIndex;
				savedMessage.ShowAsLfgMatch = showAsLfgMatch;
				savedMessage.ShowAsLfmMatch = showAsLfmMatch;

			-- Add new message
			else
				local classFile = select(2, GetPlayerInfoByGUID(playerGuid));

				local newMessage = {
					Player = player,
					PlayerClass = LFGMM_GLOBAL.CLASSES[classFile],
					PlayerLevel = nil,
					Timestamp = now,
					Type = typeMatch,
					Message = messageOrg,
					Dungeons = dungeonMatches,
					Ignore = {},
					Invited = false,
					InviteRequested = false,
					SortIndex = messageSortIndex,
					ShowAsLfgMatch = showAsLfgMatch,
					ShowAsLfmMatch = showAsLfmMatch
				};

				LFGMM_GLOBAL.MESSAGES[player] = newMessage;
			end

			-- Traverse messages and remove old ones (over 30 minutes)
			local maxAge = now - (60 * 30);
			for player,message in pairs(LFGMM_GLOBAL.MESSAGES) do
				if (message.Timestamp < maxAge) then
					LFGMM_GLOBAL.MESSAGES[player] = nil;
				end
			end

			-- Search for match
			if (LFGMM_DB.SEARCH.LFG.Running or LFGMM_DB.SEARCH.LFM.Running) then
				LFGMM_Core_FindSearchMatch();
			end

			-- Refresh
			LFGMM_ListTab_Refresh();
			LFGMM_ListTab_MessageInfoWindow_Refresh();
			LFGMM_PopupWindow_Refresh();
		end
	end
end

-- OnHide party invite
local PARTY_INVITE_OnHide = StaticPopupDialogs["PARTY_INVITE"].OnHide;
StaticPopupDialogs["PARTY_INVITE"].OnHide = function(self)
	LFGMM_PopupWindow_HideForInvited();
	LFGMM_PopupWindow_RestorePosition();
	PARTY_INVITE_OnHide(self);
end


------------------------------------------------------------------------------------------------------------------------
-- STARTUP
------------------------------------------------------------------------------------------------------------------------


-- Register events
LFGMM_MainWindow:RegisterEvent("PLAYER_ENTERING_WORLD");
LFGMM_MainWindow:RegisterEvent("ZONE_CHANGED_NEW_AREA");
LFGMM_MainWindow:RegisterEvent("CHAT_MSG_CHANNEL");
LFGMM_MainWindow:RegisterEvent("PLAYER_LEVEL_UP");
LFGMM_MainWindow:RegisterEvent("GROUP_ROSTER_UPDATE");
LFGMM_MainWindow:RegisterEvent("CHAT_MSG_SYSTEM");
LFGMM_MainWindow:RegisterEvent("PARTY_INVITE_REQUEST");
LFGMM_MainWindow:SetScript("OnEvent", LFGMM_Core_EventHandler);

-- Register slash commands
SLASH_LFGMM1 = "/lfgmm";
SLASH_LFGMM2 = "/lfgmatchmaker";
SLASH_LFGMM3 = "/matchmaker";
SlashCmdList["LFGMM"] = function()
	LFGMM_Core_MainWindow_ToggleShow();
end

