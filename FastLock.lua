script_name("FastLock")
script_author("Omar Nickson")
script_version("V2")

require "lib.moonloader"
require("sampfuncs")
local sampev = require("lib.samp.events")

-- Variables to track if roleplay lines are enabled
local rpLinesEnabled = true
-- Default RP lines
local defaultPersonalRpLine = "Uses their key fob to lock/unlock the vehicle."
local defaultFamilyRpLine = "Uses their family's key fob to lock/unlock the family vehicle."
-- Variables to store custom RP lines
local personalRpLine = defaultPersonalRpLine
local familyRpLine = defaultFamilyRpLine

-- Main function that runs continuously
function main()
    -- Wait until SAMP is available before proceeding
    while not isSampAvailable() do wait(50) end

    -- Register chat commands with their respective functions
    sampRegisterChatCommand("lockhelp", cmd_lockhelp)
    sampRegisterChatCommand("rpline", cmd_rpline)
    sampRegisterChatCommand("rpedit", cmd_rpedit)

    -- Notify user that the script is loaded and show the /lockhelp command usage
    sampAddChatMessage("{FFD700}FastLock {C0C0C0}Made By :{FFD700} Omar Nickson. {C0C0C0}/lockhelp", 0x01A0E9)

    -- Main loop that checks for key presses and sends chat messages
    while true do
        -- Check if the 'L' key is pressed to lock/unlock the personal vehicle
        if wasKeyPressed(VK_L) and not sampIsChatInputActive() and not sampIsDialogActive() then
            -- Send RP line message if enabled
            if rpLinesEnabled then
                sampSendChat("/me " .. personalRpLine)
            end
            -- Send chat command to lock/unlock personal vehicle
            sampSendChat("/pvl")
        end
        
        -- Check if the 'K' key is pressed to lock/unlock the family vehicle
        if wasKeyPressed(VK_K) and not sampIsChatInputActive() and not sampIsDialogActive() then
            -- Send RP line message if enabled
            if rpLinesEnabled then
                sampSendChat("/me " .. familyRpLine)
            end
            -- Send chat command to lock/unlock family vehicle
            sampSendChat("/gvl")
        end

        -- Wait a short period before the next loop iteration
        wait(10)
    end
end

-- Function to display help information
function cmd_lockhelp()
    sampShowDialog(
        69, 
        "{FFD700}FastLock Help", 
        "{FFFFFF}FastLock is a mod that allows you to easily lock and unlock your gang and personal vehicles in the game.\n\n" ..
        "{FFD700}Commands:{FFFFFF}\n" ..
        "{FFD700}/rpline{FFFFFF} - Toggles RP lines on and off.\n" ..
        "When RP lines are enabled, pressing \"K\" will send a message about locking/unlocking your gang vehicle, and pressing \"L\" will send a message about locking/unlocking your personal vehicle.\n\n" ..
        "{FFD700}/rpedit personal <message>{FFFFFF} - Customize the RP line for your personal vehicle. Replace <message> with your custom text.\n" ..
        "{FFD700}/rpedit family <message>{FFFFFF} - Customize the RP line for your family vehicle. Replace <message> with your custom text.\n" ..
        "{FFD700}/rpedit personal default{FFFFFF} - Reset the RP line for your personal vehicle to the default.\n" ..
        "{FFD700}/rpedit family default{FFFFFF} - Reset the RP line for your family vehicle to the default.\n\n" ..
        "Example:\n" ..
        "{FFD700}/rpedit personal Uses their personal key fob to unlock the car.{FFFFFF} - Updates the RP line for your personal vehicle.\n" ..
        "{FFD700}/rpline{FFFFFF} - Toggles RP lines on/off.\n" ..
        "When enabled, pressing \"K\" or \"L\" will send RP messages as set.\n" ..
        "When disabled, pressing \"K\" or \"L\" will not send any RP messages.\n" ..
        "Use this to quickly enable or disable RP line messages.", 
        "Okay"
    )
end

-- Function to toggle RP lines on and off
function cmd_rpline()
    rpLinesEnabled = not rpLinesEnabled -- Flip the RP lines enabled state
    local status = rpLinesEnabled and "enabled" or "disabled" -- Determine the current state
    sampAddChatMessage("Roleplay lines are now " .. status .. ".", 0x01A0E9) -- Notify the user
end

-- Function to edit RP lines or reset them to default
function cmd_rpedit(args)
    local splitArgs = split(args, " ")
    if #splitArgs < 2 then
        -- Inform user about correct usage if arguments are insufficient
        sampAddChatMessage("{FFD700}RpEdit{C0C0C0}Usage :{FFD700} /rpedit personal/family (your rp line, or 'default' to reset)", 0x01A0E9)
        return
    end

    local type = splitArgs[1] -- Get the type (personal or family)
    table.remove(splitArgs, 1) -- Remove the type from arguments
    local rpLine = table.concat(splitArgs, " ") -- Join the remaining arguments into the RP line

    if type == "personal" then
        if rpLine == "default" then
            personalRpLine = defaultPersonalRpLine -- Reset to default
            sampAddChatMessage("Personal RP line reset to default.", 0x01A0E9)
        else
            personalRpLine = rpLine -- Set the custom RP line
            sampAddChatMessage("Personal RP line updated to: " .. personalRpLine, 0x01A0E9)
        end
    elseif type == "family" then
        if rpLine == "default" then
            familyRpLine = defaultFamilyRpLine -- Reset to default
            sampAddChatMessage("Family RP line reset to default.", 0x01A0E9)
        else
            familyRpLine = rpLine -- Set the custom RP line
            sampAddChatMessage("Family RP line updated to: " .. familyRpLine, 0x01A0E9)
        end
    else
        -- Inform user about correct usage if the type is incorrect
        sampAddChatMessage("{FFD700}RpEdit{C0C0C0}Usage :{FFD700} /rpedit personal/family (your rp line, or 'default' to reset)", 0x01A0E9)
    end
end

-- Helper function to split a string by a delimiter
function split(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end