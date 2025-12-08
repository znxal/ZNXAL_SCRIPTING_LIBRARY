local SecurityModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local WEBHOOK_URL = "WEBHOOK_URL_LINK"

local webhookCooldown = 30
local playerCooldowns = {}

function SecurityModule:sendWebhook(playerName, UserId, Reason)
	if playerCooldowns[UserId] and (tick() - playerCooldowns[UserId]) < webhookCooldown then
		warn("Webhook cooldown active for player " .. playerName)
		return
	end
	
	playerCooldowns[UserId] = tick()
	
	local data = {
		content = "<@&1373975847471550564>",
		embeds = {
			{
				title = "Suspicious Player Detected!",
				description = "**[EXTRAJOSS_EVENT]**: "..Reason,
				color = 0xFF0000, 
				fields = {
					{ name = "Player", value = playerName.. " (UserId: "..UserId.." )", inline = true },
					{ name = "Reason", value = "Reason: " .. Reason, inline = true },
					{ name = "Join Link", value = "https://www.roblox.com/games/start?placeId="..game.PlaceId.."&launchData="..game.PlaceId.."/"..game.JobId, inline = false }
				},
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") 
			}
		}
	}
	local jsonData = HttpService:JSONEncode(data)

	local success, err = pcall(function()
		HttpService:PostAsync(WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
	end)

	if not success then
		warn("Gagal kirim webhook: " .. err)
	end
end

return SecurityModule
