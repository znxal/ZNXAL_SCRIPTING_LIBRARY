local Config = {}

-- Dependencies 
local BadgeService = game:GetService("BadgeService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Function
function Config:AwardBadge(player, badgeId)
	if not player or not badgeId then
		warn("Player atau badgeId tidak valid!")
	end
	
	local success, badgeInfo = pcall(BadgeService.GetBadgeInfoAsync, BadgeService, badgeId)
	if success then
		if badgeInfo.IsEnabled then
			local awarded, errorMessage = pcall(BadgeService.AwardBadge, BadgeService, player.UserId, badgeId)
			if awarded then
				print(player.Name..": Badge diberikan! :"..tostring(awarded))
			else
				warn(player.Name..": Kesalahan saat memberikan Badge! :", errorMessage)
			end
		end
	else
		warn(player.Name..": Kesalahan saat mengambil informasi Badge!: "..tostring(badgeInfo))
	end
end

function Config:PromptPurchase(player: Player, UGCId: number) -- UGC/Items bukan DevProduct
	if not player or not UGCId then
		warn("Player atau UGCId tidak valid!")
	end

	local success, errorMsg = pcall(function()
		MarketplaceService:PromptPurchase(player, UGCId)
	end)

	if success then
		print(player.Name..": Sukses mengclaim Product! :"..tostring(success))
	else
		warn(player.Name..": Terjadi kesalahan saat memproses pembelian! :" .. errorMsg)
	end
end

function Config:PromptProductPurchase(player: Player, DevProductId: number) -- DevProduct bukan UGC/Items
	if not player or not DevProductId then
		warn("Player atau DevProductId tidak valid!")
	end

	local success, errorMsg = pcall(function()
		MarketplaceService:PromptProductPurchase(player, DevProductId)
	end)

	if success then
		print(player.Name..": Sukses membeli DevProduct! :"..tostring(success))
	else
		warn(player.Name..": Terjadi kesalahan saat memproses pembelian! :" .. errorMsg)
	end
end

function Config:PromptGamePassPurchase(player: Player, GamePassId: number) -- UGC/Product bukan DevProduct
	if not player or not GamePassId then
		warn("Player atau GamePassId tidak valid!")
	end

	local success, errorMsg = pcall(function()
		MarketplaceService:PromptGamePassPurchase(player, GamePassId)
	end)

	if success then
		print(player.Name..": Sukses membeli GamePass! :"..tostring(success))
	else
		warn(player.Name..": Terjadi kesalahan saat memproses pembelian! :" .. errorMsg)
	end
end

function Config:CheckGamePass(player: Player, GamePassId: number)
	if not player or not GamePassId then
		warn("Player atau GamePassId tidak valid!")
		return false
	end
	
	local success, ownsPass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GamePassId)
	end)

	if success and ownsPass then
		print(player.Name..": memiliki GamePass! :"..tostring(ownsPass))
		return true
	elseif success and not ownsPass then
		print(player.Name..": tidak memiliki GamePass! :"..tostring(ownsPass))
		return false
	else
		warn(player.Name..": Terjadi kesalahan saat checking GamePass! :"..tostring(ownsPass))
		return false
	end
end

return Config
