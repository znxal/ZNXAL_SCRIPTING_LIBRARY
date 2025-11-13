local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local SomethincData = DataStoreService:GetDataStore("SomethincData__TEST")


local function SetupData(player)
	local SomethincAssets = Instance.new("Folder", player)
	SomethincAssets.Name = "SomethincAssets"

	local IsOnQuest = Instance.new("BoolValue", SomethincAssets)
	IsOnQuest.Name = "IsOnQuest"

	local Quest = Instance.new("IntValue", SomethincAssets)
	Quest.Name = "Quest"

	local success, data = pcall(function()
		return SomethincData:GetAsync("Key_"..player.UserId)
	end)

	if success and data then
		IsOnQuest.Value = data[1] or false
		Quest.Value = data[2] or 0
	else
		IsOnQuest.Value = false
		Quest.Value = 0
	end
end

local function SaveData(player)
	local IsOnQuest = player.SomethincAssets.InOnQuest
	local Quest = player.SomethincAssets.Quest
	local data = {IsOnQuest.Value, Quest.Value}

	local maxRetries = 5
	local retryDelay = 2 

	local function attemptSave(attempts)
		local success, errorMessage = pcall(function()
			SomethincData:SetAsync("Key_"..player.UserId, data)
		end)

		if not success then
			if attempts < maxRetries then
				warn("Gagal menyimpan data pemain " .. player.Name .. ". Coba lagi... (" .. attempts .. "/" .. maxRetries .. ")")
				wait(retryDelay) 
				attemptSave(attempts + 1) 
			else
				warn("Gagal menyimpan data pemain " .. player.Name .. " setelah beberapa kali percobaan: " .. errorMessage)
			end
		else
			print("Data pemain " .. player.Name .. " berhasil disimpan.")
		end
	end
	attemptSave(1)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Wait()
	SetupData(player)
end)

Players.PlayerRemoving:Connect(function(player)
	SaveData(player)
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		SaveData(player)
	end
end)
