local TapMiniGame = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

TapMiniGame.GameDuration = nil          
TapMiniGame.RespawnDelay = 0.15        
TapMiniGame.ButtonSize = UDim2.fromOffset(100, 100)
TapMiniGame.SAFE_LEFT = 0.02   
TapMiniGame.SAFE_RIGHT = 0.90  
TapMiniGame.SAFE_TOP = 0.05    
TapMiniGame.SAFE_BOTTOM = 0.82

function TapMiniGame:Start(player, duration, callback)
	self.GameDuration = duration
	local uiTemplate = script.Minigames:Clone()
	uiTemplate.Parent = player.PlayerGui

	local screen = uiTemplate.Canvas
	local clickCount = 0
	local running = true

	local function spawnRandomButton()
		if not running then return end

		local btn = screen.Click:Clone()
		btn.Visible = true
		btn.Parent = screen
		btn.ClickCircleFrame.ImageColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))

		btn.Size = self.ButtonSize

		btn.Position = UDim2.new(
			math.random() * (self.SAFE_RIGHT - self.SAFE_LEFT) + self.SAFE_LEFT,
			0,
			math.random() * (self.SAFE_BOTTOM - self.SAFE_TOP) + self.SAFE_TOP,
			0
		)


		btn.MouseButton1Click:Connect(function()
			clickCount += 1

			TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.fromOffset(115,115)}):Play()

			task.delay(0.1, function()
				if btn then btn:Destroy() end
				task.delay(self.RespawnDelay, spawnRandomButton)
			end)
		end)
	end

	spawnRandomButton()

	task.delay(self.GameDuration, function()
		running = false
		uiTemplate:Destroy()
		callback(clickCount)
		self.GameDuration = nil
	end)
end

return TapMiniGame
