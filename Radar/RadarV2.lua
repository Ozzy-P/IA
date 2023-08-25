-- Placeholder file, mostly an idea board at the moment.
--[[ TODO: 
* [MARKED AS DONE] Delegate a scheduler based on current frame rotation -> Get objects currently at that angle from the camera (P: Ignore rescans of same object when camera is reangled.)
* Move blips on radar relative to camera movement.
* Fix scaling [among other stuff from V1]
--]]

-- Below is an untested full version of the aforementioned new version (v3 when?).


-- Gui to Lua
-- Version: 3.2
-- Instances:

local ScanRange = 200
local ScanTime = 2

local RADar = Instance.new("ScreenGui")
local Main = Instance.new("CanvasGroup")
local UICorner = Instance.new("UICorner")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local Delin = Instance.new("Frame")
local DelinShade = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local Dot = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Inner = Instance.new("Frame")
local UICorner_3 = Instance.new("UICorner")
local Outer = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")
local Enemy = Instance.new("Frame")
local UICorner_5 = Instance.new("UICorner")

--Properties:

RADar.Name = "RADar"
RADar.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
RADar.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = RADar
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.0269986596, 0, 0.25, 0)
Main.Size = UDim2.new(0.5, 0, 0.5, 0)

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Main

UIAspectRatioConstraint.Parent = Main

Delin.Name = "Delin"
Delin.Parent = Main
Delin.AnchorPoint = Vector2.new(0.5, 0.5)
Delin.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Delin.BackgroundTransparency = 1.000
Delin.BorderColor3 = Color3.fromRGB(0, 0, 0)
Delin.BorderSizePixel = 0
Delin.Position = UDim2.new(0.5, 0, 0.5, 0)
Delin.Size = UDim2.new(0.00700000022, 0, 1, 0)

DelinShade.Name = "DelinShade"
DelinShade.Parent = Delin
DelinShade.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
DelinShade.BorderColor3 = Color3.fromRGB(0, 0, 0)
DelinShade.BorderSizePixel = 0
DelinShade.Position = UDim2.new(-4, 0, 0, 0)
DelinShade.Size = UDim2.new(5, 0, 0.5, 0)

UIGradient.Rotation = -3.5
UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.17, 0.95), NumberSequenceKeypoint.new(0.40, 0.75), NumberSequenceKeypoint.new(0.68, 0.15), NumberSequenceKeypoint.new(0.91, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
UIGradient.Parent = DelinShade

Dot.Name = "Dot"
Dot.Parent = Main
Dot.AnchorPoint = Vector2.new(0.5, 0.5)
Dot.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
Dot.BorderColor3 = Color3.fromRGB(0, 0, 0)
Dot.BorderSizePixel = 0
Dot.Position = UDim2.new(0.5, 0, 0.5, 0)
Dot.Size = UDim2.new(0.0350000001, 0, 0.0350000001, 0)

UICorner_2.CornerRadius = UDim.new(1, 0)
UICorner_2.Parent = Dot

Inner.Name = "Inner"
Inner.Parent = Main
Inner.AnchorPoint = Vector2.new(0.5, 0.5)
Inner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Inner.BorderColor3 = Color3.fromRGB(0, 0, 0)
Inner.BorderSizePixel = 0
Inner.Position = UDim2.new(0.5, 0, 0.5, 0)
Inner.Size = UDim2.new(0.980000019, 0, 0.980000019, 0)
Inner.ZIndex = 0

UICorner_3.CornerRadius = UDim.new(1, 0)
UICorner_3.Parent = Inner

Outer.Name = "Outer"
Outer.Parent = Main
Outer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Outer.BorderColor3 = Color3.fromRGB(0, 0, 0)
Outer.BorderSizePixel = 0
Outer.Size = UDim2.new(1, 0, 1, 0)
Outer.ZIndex = -1

UICorner_4.CornerRadius = UDim.new(1, 0)
UICorner_4.Parent = Outer

Enemy.Name = "Enemy"
Enemy.Parent = Main
Enemy.AnchorPoint = Vector2.new(0.5, 0.5)
Enemy.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
Enemy.BorderColor3 = Color3.fromRGB(0, 0, 0)
Enemy.BorderSizePixel = 0
Enemy.Position = UDim2.new(0.5, 0, 0.5, 0)
Enemy.Size = UDim2.new(0.0350000001, 0, 0.0350000001, 0)

UICorner_5.CornerRadius = UDim.new(1, 0)
UICorner_5.Parent = Enemy

-- Scripts:

local function LKJE_fake_script() -- Delin.LocalScript 
	local TweenService = game:GetService("TweenService")
	local Debris = game:GetService("Debris")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace:WaitForChild("Camera")
	local targetInstances = {}
	local activeSpotted = {}
	
	for _,Player in pairs(Players:GetChildren()) do
		if Player.Character then
			table.insert(targetInstances,Player.Character)
		end
	end
	
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			table.insert(targetInstances,character)
		end)
	end)
	
	local TweeningInfo = TweenInfo.new(ScanTime,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1,false)
	local ScannerInstance = Delin
	local radarScan = TweenService:Create(ScannerInstance,TweeningInfo,{Rotation = 360})
	local overlap = OverlapParams.new()
	overlap.FilterType = Enum.RaycastFilterType.Include
	overlap.FilterDescendantsInstances = targetInstances
	
	
	local function DeconstructCFrame(CFrame)
		local px,py,pz,xx,yx,zx,xy,yy,zy,xz,yz,zz=CFrame:components()
	
		local Position=Vector3.new(px,py,pz)
		local Right=Vector3.new(xx,xy,xz)
		local Top=Vector3.new(yx,yy,yz)
		local Back=Vector3.new(zx,zy,zz)
	
		return Position,Right,Top,Back
	end
	
	-- CFrame:inverse() * Vector3
	local function CFrameTimesVector3(CFrame,Vector)
		local px,py,pz,xx,yx,zx,xy,yy,zy,xz,yz,zz=CFrame:components()
		local vx,vy,vz=Vector.x,Vector.y,Vector.z
	
		local rx,ry,rz=vx-px,vy-py,vz-pz--r for Relative
	
		local HowFarRight=rx*xx+ry*xy+rz*xz
		local HowFarUp=rx*yx+ry*yy+rz*yz
		local HowFarBack=rx*zx+ry*zy+rz*zz
	
		return Vector3.new(HowFarRight,HowFarUp,HowFarBack)
	end
	
	local Enemy = ScannerInstance.Parent.Enemy
	local function createBlip(target)
		local Blip = Enemy:Clone()
	
		-- Restrict out of bounds area
		local Distance = CFrameTimesVector3(workspace.Camera.CFrame,target[3])
		local Multiplier = 1
		if target[6][1] > target[6][2] * .9 then Multiplier = .965 end
		if target[6][1] > 75 and target[6][1] < 200 then
			Multiplier = .3
		elseif target[6][1] > 200 and target[6][1] < 350 then
			Multiplier = .2
		elseif target[6][1] > 350 and target[6][1] < 600 then
			Multiplier = .05
		end
		local X_Distance = (Distance - Vector3.new()).X--.Unit.X
		local Z_Distance = (Distance - Vector3.new()).Z--.Unit.Z
		-- Center of Radar.
		local RadarX,RadarZ = .485,.475
		local OwO = .0075
		RadarX = RadarX + ( X_Distance * OwO * Multiplier )
		RadarZ = RadarZ + ( Z_Distance * OwO * Multiplier )
	
		Blip.Position = UDim2.new(RadarX,0,RadarZ,0)
		Blip.Parent = Delin.Parent
		local info = TweenInfo.new(ScanTime / 2,Enum.EasingStyle.Quad,Enum.EasingDirection.In,0,false,0)
		local infoFast = TweenInfo.new(ScanTime / 4,Enum.EasingStyle.Quad,Enum.EasingDirection.In,0,false,0)
		local Goals = {Fade={BackgroundTransparency = 1},FadeIn = {BackgroundTransparency = .125}}
		if target[5] == true then
			Blip.BackgroundColor3 = Color3.new(0,0,255)
			Blip.Size = UDim2.new(0.1, 0, 0.1, 0)
			Blip.ZIndex = 2
			Goals.FadeIn.BackgroundTransparency = 0
		elseif target[5] == "RUN." then
			Blip.BackgroundColor3 = Color3.new(255,0,0)
			Blip.Size = UDim2.new(0.08, 0, 0.08, 0)
			Blip.ZIndex = 2
			Goals.FadeIn.BackgroundTransparency = 0
		else
			Blip.BackgroundColor3 = Color3.fromRGB(0,170,250)
			Blip.Size = UDim2.new(0.04, 0, 0.04, 0)
			Blip.ZIndex = 2
			Goals.FadeIn.BackgroundTransparency = 0
		end
	
		local FadeIn  = TweenService:Create(Blip, infoFast, Goals.FadeIn)
		local FadeBlip  = TweenService:Create(Blip, info, Goals.Fade)
	
		FadeIn:Play()
	
		local FadeOut;FadeOut = FadeIn.Completed:Connect(function()
			FadeOut:Disconnect()
			FadeBlip:Play()
			Debris:AddItem(Blip,ScanTime/2)
			task.delay(ScanTime/2,function()
				activeSpotted[target[1]] = nil
			end)
		end)
	
	end
	
	
	local function checkPlayerTargets(results)
		for _,Part:BasePart in pairs(results) do
			local Player = Players:GetPlayerFromCharacter(Part:FindFirstAncestorWhichIsA("Model"))
			if not activeSpotted[Player.Name] then
				activeSpotted[Player.Name] = true
				createBlip({Player.Name,(Camera.CFrame.Position - Part.Position).Magnitude,Player.Character.HumanoidRootPart.Position,Player.Character,false,{(Camera.CFrame.Position - Part.Position).Magnitude,ScanRange}},Player.Name)
			end
		end
	end
	
	
	ScannerInstance:GetPropertyChangedSignal("Rotation"):Connect(function()
		local targetCF = (Camera.CFrame) * CFrame.Angles(0,math.rad(-ScannerInstance.Rotation),0)
		local playerResults = workspace:GetPartBoundsInBox(targetCF + targetCF.LookVector * ScanRange/2, Vector3.new(5,ScanRange,ScanRange), overlap)
		if #playerResults > 0 then
			checkPlayerTargets(playerResults)
		end
	end)
	
	radarScan:Play()
end
coroutine.wrap(LKJE_fake_script)()
