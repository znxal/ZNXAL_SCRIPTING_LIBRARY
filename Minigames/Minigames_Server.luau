local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local ExtraJossRep = ReplicatedStorage:WaitForChild("ExtraJoss")
local Minigames_Remote = ExtraJossRep:WaitForChild("Minigames")
local ReplicatedModules = ExtraJossRep:WaitForChild("ReplicatedModule")
local MiniGames = require(ReplicatedModules:WaitForChild("Minigames"))

local Arcade = Workspace:WaitForChild("Arcade")
local ProximityPrompt = Arcade:WaitForChild("ProximityPrompt")
local counterText = Arcade.Counter.SurfaceGui.CounterText
local IsOccupied = false

local function AnimateCounter(counterText, target)
	counterText.Text = "0"

	local current = 0
	local step = math.ceil(target / 50) 

	while current < target do
		current += step
		if current > target then
			current = target
		end

		counterText.Text = tostring(current)
		task.wait(0.02) 
	end
end


Minigames_Remote.OnServerEvent:Connect(function(player)
	if IsOccupied then return end
	IsOccupied = true
	ProximityPrompt.Enabled = false

	MiniGames:Start(player, function(clicks)
		print("RESULT:", clicks)

		local hadiahMin = clicks * 5
		local hadiahMax = 0

		if clicks >= 15 then
			hadiahMax = 100

		elseif clicks >= 10 then
			hadiahMax = 75

		elseif clicks >= 5 then
			hadiahMax = 20
		else
			Arcade.Counter.SurfaceGui.CounterText.Text = "0"
			Minigames_Remote:FireClient(player)
			ProximityPrompt.Enabled = true
			IsOccupied = false
			return
		end

		local finalHadiah = math.random(
			math.min(hadiahMin, hadiahMax),
			math.max(hadiahMin, hadiahMax)
		)

		AnimateCounter(counterText, finalHadiah)

		Minigames_Remote:FireClient(player)
		ProximityPrompt.Enabled = true
		IsOccupied = false
	end)
end)
