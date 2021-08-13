--Bunny's VFA-469 Greenie Board Data Function v1.0
--Obviously you must desanitize the io in missionscripting.lua

-- a simple function to see if fields are nil or empty to eliminate concatenation errors
local function isempty(s)
  return s == nil or s == ''
end

--initiating IO operation on the file
local fdir = lfs.writedir() .. [[Logs\Stats\]] .. "lsoscores.lua"
local f,err = io.open(fdir,"a")
	if not f then
		local errmsg = 'Error: Need to create new folder in the Logs folder with the name' .. 'Stats . sample: C:\Users\yourname\Saved Games\DCS\Logs\Stats' 
		trigger.action.outText(errmsg, 10)
		return print(err)
	end
-- used to debug io
--f:write("File Opened Successfully \n") 
--trigger.action.outText("File opened",10)

--add the event handler (current test is for startups + scored landings)
local Event_Handler = {}

function Event_Handler:onEvent(event)
	-- if (event.id == 18) then -- handles startups, can be used for debugging with a common event.
		-- callsign = event.initiator:getPlayerName()
		-- if isempty(callsign) then
			-- callsign = "Unknown Pilot"
		-- end
		-- eventNotice = ("Engine Start Detected for " .. event.initiator:getName() .. " flown by " .. callsign)
		-- writeNotice = (event.time .. "," .. "start," .. event.initiator:getTypeName().. "," .. event.initiator:getName() .. "," .. callsign .. "\n")
		-- trigger.action.outText(eventNotice, 10)
		-- f:write(writeNotice)
	-- end
	
	if (event.id == 36) then  -- handles scored landings
		callsign = event.initiator:getPlayerName()
		if isempty(callsign) then
			callsign = "Unknown Pilot"
		end
		writeNotice = (os.date().. "," ..event.time .. "," .. event.place:getName() .. "," .. event.initiator:getTypeName().. "," .. event.initiator:getName() .. "," .. callsign .. "," .. event.comment .."\n")
		f:write(writeNotice)
	end
		
end

world.addEventHandler(Event_Handler)


