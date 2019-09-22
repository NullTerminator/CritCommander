----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, ns = ...;
ns.Crit = {}; -- adds Crit table to addon namespace
local Crit = ns.Crit;
local critListener;




----------------------------------------
-- Events / Handlers
----------------------------------------
-- Subscribes to combat event.
function Crit:StartListening()
	critListener = CreateFrame("Frame");
	critListener:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	critListener:SetScript("OnEvent", function(self, event) self:OnEvent(event, CombatLogGetCurrentEventInfo()) end);
end

-- Parses event, plays sound if its a crit.
function critListener:OnEvent(event, ...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool
	local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand


	if subevent == "SWING_DAMAGE" then
		amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
	elseif subevent == "SPELL_DAMAGE" then
		spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    elseif subevent == "RANGE_DAMAGE" then
		spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    end

	
	if critical and sourceGUID == CritCommanderDB[GetRealmName()][UnitName("player")].GUID then
		C_Timer.After(thisPlayer.SoundDelay, playSound)
	end
end




----------------------------------------
-- Functions
----------------------------------------
-- Fucntion to play sound file.
local function playSound()
	_playSound("wow1.mp3")
end


-- Backing function to play the sound files.
local function _playSound(soundFileName)
	PlaySoundFile("Interface\\AddOns\\CritCommander\\Sounds\\" .. soundFileName, thisPlayer.SoundChannel)
end


-- Crit.lua end.
SendSystemMessage("Crit Commander - Crit.lua has been loaded.")