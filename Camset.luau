local Camset = {}

local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera

local tweenInfo_Set = TweenInfo.new(
	0.7,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.In,
	0,
	false,
	0 
)

local tweenInfo_Res = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out,
	0,
	false,
	0 
)

function Camset:SetCamera(Player: Players,targetPart: BasePart)
	if camera.CameraType ~= Enum.CameraType.Scriptable then
		camera.CameraType = Enum.CameraType.Scriptable
	end

	local goal = {
		CFrame = targetPart.CFrame
	}

	local tween = TweenService:Create(camera, tweenInfo_Set, goal)
	tween:Play()
end

function Camset:Reset(Player: Players)
	task.wait(0.7)
	local Head = Player.Character:WaitForChild("Head")

	local goal = {
		CFrame = Head.CFrame
	}

	local tween = TweenService:Create(camera, tweenInfo_Res, goal)
	tween:Play()
	tween.Completed:Wait()

	camera.CameraType = Enum.CameraType.Custom
	camera.CFrame = Workspace.CurrentCamera.CFrame
	camera.Focus = Workspace.CurrentCamera.Focus
end

return Camset
