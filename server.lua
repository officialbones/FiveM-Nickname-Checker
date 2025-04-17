local CHECK_API_URL = "http://127.0.0.1:4000/check-nickname"
## Leave this alone. 127.0.0.1 is localhost. Change the port if needed.

print([[
       ______
    .-'      '-.
   /            \
  |              |
  |,  .-.  .-.  ,|
  | )(_o/  \o_)( |
  |/     /\     \|
  (_     ^^     _)
   \__|IIIIII|__/
    | \IIIIII/ |
    \          /
     `--------`

 ██████   ██████  ███    ██ ███████ ██████      
 ██   ██ ██    ██ ████   ██ ██      ██        
 ██████  ██    ██ ██ ██  ██ █████     ███        
 ██   ██ ██    ██ ██  ██ ██ ██           ██     
 ███████  ██████  ██   ████ ███████ ███████   
           ☠️  BONES DEV  ☠️    
]])

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    deferrals.defer()
    local src = source
    local discordId = nil

    print("[Nickname Check] Player attempting to connect: " .. playerName)
    
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        print("[Nickname Check] Found identifier: " .. id)
        if id:match("^discord:") then
            discordId = id:gsub("discord:", "")
            print("[Nickname Check] Extracted Discord ID: " .. discordId)
            break
        end
    end

    if not discordId then
        print("[Nickname Check] No Discord ID found. Kicking player.")
        deferrals.done("You must have Discord open and connected to join.")
        return
    end

    deferrals.update("Validating your nickname with Discord...")

    local encodedPlayerName = playerName:gsub(" ", "%%20"):gsub("|", "%%7C")
    local url = CHECK_API_URL .. "?discordId=" .. discordId .. "&playerName=" .. encodedPlayerName
    print("[Nickname Check] Sending API request to: " .. url)

    PerformHttpRequest(url, function(statusCode, response, headers)
        print("[Nickname Check] HTTP Status Code: " .. tostring(statusCode))
        print("[Nickname Check] Raw Response: " .. tostring(response))

        if statusCode == 200 and response then
            local success, result = pcall(json.decode, response)
            if not success then
                print("[Nickname Check] Failed to decode JSON response!")
                deferrals.done("Nickname check failed: invalid server response.")
                return
            end

            print("[Nickname Check] Parsed JSON match value: " .. tostring(result.match))
            print("[Nickname Check] Parsed Discord nickname: " .. tostring(result.nickname))

            if result.match then
                print("[Nickname Check] Nickname matched. Letting player in.")
                deferrals.done()
            else
                print("[Nickname Check] Nickname mismatch. Expected: " .. result.nickname .. ", got: " .. playerName)
                deferrals.done("Your in-game name must match your Discord nickname: " .. result.nickname)
            end
        else
            print("[Nickname Check] API call failed. Could not verify nickname.")
            deferrals.done("Error validating nickname. Try again later.")
        end
    end, "GET", "", {})
end)
