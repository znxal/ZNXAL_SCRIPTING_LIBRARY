local Config = {}

local BadgeService = game:GetService("BadgeService")
local MarketplaceService = game:GetService("MarketplaceService")

function Config:AwardBadge(player, badgeId)
	if not player or not badgeId then
		warn("Player atau badgeId tidak valid!")
	end
	
	local success, badgeInfo = pcall(BadgeService.GetBadgeInfoAsync, BadgeService, badgeId)
	if success then
		if badgeInfo.IsEnabled then
			local awarded, errorMessage = pcall(BadgeService.AwardBadge, BadgeService, player.UserId, badgeId)
			if awarded then
				print(player..": Badge diberikan! :"..awarded)
			else
				
				warn(player..": Kesalahan saat memberikan Badge! :", errorMessage)
			end
		end
	else
		warn(player..": Kesalahan saat mengambil informasi Badge!: "..badgeInfo)
	end
end

function Config:PromptPurchase(player, ProductId)
	if not player or not ProductId then
		warn("Player atau ProductId tidak valid!")
	end

	local success, errorMsg = pcall(function()
		MarketplaceService:PromptProductPurchase(player, ProductId)
	end)

	if success then
		print(player..": Sukses mengclaim Product! :"..success)
	else
		warn(player..": Terjadi kesalahan saat memproses pembelian! :" .. errorMsg)
	end
end



return Config
