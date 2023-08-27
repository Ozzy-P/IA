--[[ TODO: 
* [Marked as done Delegate a scheduler based on current frame rotation -> Get objects currently at that angle from the camera (P: Ignore rescans of same object when camera is reangled.)
* [Marked as done] Make relative scaling to target instance scanner based on distance.
* [Marked as done] Move blips on radar relative to camera movement.
* [Marked as pending] Fix connection leak..
* [Marked as pending] Retry instance add.
--]]

local ScanRange = 50
local ScanTime = 1 + 1/3
local ScalingEnabled = false
local ScanMode = "Character" -- Scanning Relative to Object: Camera,Character

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
RADar.ResetOnSpawn = false

Main.Name = "Main"
Main.Parent = RADar
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.0269986596, 0, 0.25, 0)
Main.Size = UDim2.new(0.35, 0, 0.35, 0)

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
	local ContextActionService = game:GetService("ContextActionService")
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local Camera = workspace:WaitForChild("Camera")
	local Players = game:GetService("Players")
	local Debris = game:GetService("Debris")
	local LocalPlayer = Players.LocalPlayer
	local targetInstances = {}
	local activeSpotted = {}
	local Target = nil

	for _,Player in pairs(Players:GetChildren()) do
		if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
			table.insert(targetInstances,Player.Character.HumanoidRootPart)
		end
	end

	local PlayerAdded,LocalPlayerCharacterAdded = nil,nil; 
	PlayerAdded = Players.PlayerAdded:Connect(function(player:Player)
		local targetCharacter = player.Character::Model
		if not targetCharacter then
			targetCharacter = player.CharacterAdded:Wait()
		end
		table.insert(targetInstances,targetCharacter:WaitForChild("HumanoidRootPart"))

		local TMP_CHAR; TMP_CHAR = player.CharacterAdded:Connect(function(character)
			if not PlayerAdded.Connected then
				TMP_CHAR:Disconnect() 
				return 
			end
			table.insert(targetInstances,character:WaitForChild("HumanoidRootPart"))
		end)
	end)

	if ScanMode == "Character" then
		if LocalPlayer.Character and LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
			Target = LocalPlayer.Character.HumanoidRootPart
		else
			LocalPlayer.CharacterAdded:Wait()
			Target = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		end

		LocalPlayerCharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
			character:WaitForChild("HumanoidRootPart")
			if not character:FindFirstChild("HumanoidRootPart") then return end
			Target = character.HumanoidRootPart
		end)

	elseif ScanMode == "Camera" then
		Target = Camera
	end

	local TweeningInfo = TweenInfo.new(ScanTime,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1,false)
	local ScannerInstance = Delin::Frame
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
		local vx:number,vy:number,vz:number=Vector.X,Vector.Y,Vector.Z

		local rx,ry,rz=vx-px,vy-py,vz-pz--r for Relative

		local HowFarRight=rx*xx+ry*xy+rz*xz
		local HowFarUp=rx*yx+ry*yy+rz*yz
		local HowFarBack=rx*zx+ry*zy+rz*zz

		return Vector3.new(HowFarRight,HowFarUp,HowFarBack)
	end

	local function dragify(Frame)
		local dragToggle = nil
		local dragSpeed = .25
		local dragInput = nil
		local dragStart = nil
		local dragPos = nil
		local startPos = UDim2.new()

		local function updateInput(input:InputObject)
			local Delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
			game:GetService("TweenService"):Create(Frame, TweenInfo.new(.25), {Position = Position}):Play()
		end

		local IB = Frame.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				dragToggle = true
				dragStart = input.Position
				startPos = Frame.Position
				input.Changed:Connect(function()
					if (input.UserInputState == Enum.UserInputState.End) then
						dragToggle = false
					end
				end)
			end
		end)

		local IC = Frame.InputChanged:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				dragInput = input
			end
		end)

		local UIC = game:GetService("UserInputService").InputChanged:Connect(function(input)
			if (input == dragInput and dragToggle) then
				updateInput(input)
			end
		end)
	end

	local activeTrackers = {}
	local activeBlips = {}

	local function extendBlip(targetBlip:targetTable)

	end

	local function calcNewDist(targetPos)
		local Distance = CFrameTimesVector3(Target.CFrame,targetPos)
		local X_Distance = (Distance - Vector3.new()).X--.Unit.X
		local Z_Distance = (Distance - Vector3.new()).Z--.Unit.Z
		-- Center of Radar.
		local OwO = .0075
		return .485 + ( X_Distance * OwO * 1 ),.475 + ( Z_Distance * OwO * 1 )
	end


	type targetTable = {Name:string,
		Magnitude:any,
		LocalPosition:Vector3,
		TargetModel:Model,
		DRG:any,
		TargetPart:BasePart
	}

	local function createBlip(target:targetTable)

		local Blip = Enemy:Clone()

		-- Restrict out of bounds area
		local Multiplier = 1
		--[[if ScalingEnabled then
			if target[6][1] > target[6][2] * .9 then Multiplier = .965 end
			if target[6][1] > 75 and target[6][1] < 200 then
				Multiplier = .3
			elseif target[6][1] > 200 and target[6][1] < 350 then
				Multiplier = .2
			elseif target[6][1] > 350 and target[6][1] < 600 then
				Multiplier = .05
			end
		end--]]

		local RadarX, RadarZ = calcNewDist(target.TargetPart.Position)
		Blip.Position = UDim2.new(RadarX,0,RadarZ,0)
		Blip.Parent = Delin.Parent
		local info = TweenInfo.new(ScanTime / 0.75,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0)
		local infoFast = TweenInfo.new(ScanTime / 7,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0)
		local Goals = {Fade={BackgroundTransparency = 1},FadeIn = {BackgroundTransparency = .125}}

		if target.DRG== true then
			Blip.BackgroundColor3 = Color3.new(0,0,255)
			Blip.Size = UDim2.new(0.1, 0, 0.1, 0)
			Blip.ZIndex = 2
			Goals.FadeIn.BackgroundTransparency = 0
		elseif target.DRG == "RUN." then
			Blip.BackgroundColor3 = Color3.new(255,0,0)
			Blip.Size = UDim2.new(0.08, 0, 0.08, 0)
			Blip.ZIndex = 2
			Goals.FadeIn.BackgroundTransparency = 0
		else
			Blip.BackgroundColor3 = Color3.fromRGB(0,170,250)
			Blip.Size = UDim2.new(0.04, 0, 0.04, 0)
			Blip.ZIndex = 2
			Goals.FadeIn.BackgroundTransparency = 0.125
		end

		local ShowBlip  = TweenService:Create(Blip, infoFast, Goals.FadeIn)
		local HideBlip  = TweenService:Create(Blip, info, Goals.Fade)
		ShowBlip:Play()
		
		local DarkFade; DarkFade = ShowBlip.Completed:Connect(function()
			HideBlip:Play()
		end)

		local BlipFuncs = {
			BlipID = Blip,
			ShowBlip = ShowBlip,
			HideBlip = HideBlip,
			Looper = DarkFade
		}

		local posChanged,DestroyBlip
		posChanged = RunService.Heartbeat:Connect(function()
			if target.TargetModel.Parent ~= workspace then
				activeSpotted[target.Name] = nil
				DestroyBlip:Disconnect()
				posChanged:Disconnect()
				if BlipFuncs then
					BlipFuncs.Looper:Disconnect()
					BlipFuncs.HideBlip:Cancel()
					BlipFuncs = nil::any
				end
				Blip:Destroy()
				return
			end
			local newX, newZ = calcNewDist(target.TargetPart.Position)
			Blip.Position = UDim2.new(newX,0,newZ,0)
		end)

		table.insert(activeTrackers, posChanged)

		DestroyBlip = Blip:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
			if Blip.BackgroundTransparency <= 0.98 then return end
			DestroyBlip:Disconnect()
			Debris:AddItem(Blip,ScanTime/1.25)
			task.delay(ScanTime/1.25,function()
				activeSpotted[target.Name] = nil
				BlipFuncs.Looper:Disconnect()
				BlipFuncs = nil::any
			end)
		end)

		function BlipFuncs:Refresh()
			self.HideBlip:Cancel()
			self.Looper:Disconnect()
			self:ChangeLooper()
			self.ShowBlip:Play()
		end
		
		function BlipFuncs:ChangeLooper()
			local newInfo = TweenInfo.new(ScanTime / 7*(math.clamp(self.BlipID.BackgroundTransparency,0.02,1)),Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0)
			self.ShowBlip = TweenService:Create(Blip, infoFast, Goals.FadeIn)
			self.Looper = self.ShowBlip.Completed:Connect(function()
				self.HideBlip:Play()
			end)
		end

		activeBlips[target.Name] = BlipFuncs
	end

	local function checkPlayerTargets(results)
		for _,Part:BasePart in pairs(results) do
			local Player = Players:GetPlayerFromCharacter(Part:FindFirstAncestorWhichIsA("Model"))
			if not Player then continue end
			if not activeSpotted[Player.Name] then
				activeSpotted[Player.Name] = true
				createBlip({
					Name = Player.Name,
					Magnitude = (Target.CFrame.Position - Part.Position).Magnitude,
					LocalPosition = Target.Position,
					TargetModel = Player.Character,
					DRG = false,
					ExtraInfo = {(Target.CFrame.Position - Part.Position).Magnitude,
						ScanRange
					},
					TargetPart = Part
				})
			else
				activeBlips[Player.Name]:Refresh()
			end
		end
	end

	local function unbindScanner()
		for _,Connection:RBXScriptConnection in pairs(activeTrackers) do
			Connection:Disconnect()
		end
		ContextActionService:UnbindAction("DisableRadar")
		ContextActionService:UnbindAction("DBG")
		LocalPlayerCharacterAdded:Disconnect()
		PlayerAdded:Disconnect()
		radarScan:Cancel()
		RADar:Destroy()
		activeTrackers = nil::any
	end

	local function DBG()
		print(#targetInstances, PlayerAdded and PlayerAdded.Connected, #activeSpotted)
	end


	ScannerInstance:GetPropertyChangedSignal("Rotation"):Connect(function()
		local playerResults = workspace:GetPartBoundsInBox(((Target.CFrame)*CFrame.Angles(0,math.rad(-ScannerInstance.Rotation),0))+((Target.CFrame)*CFrame.Angles(0,math.rad(-ScannerInstance.Rotation),0)).LookVector * ScanRange/2, Vector3.new(5,ScanRange,ScanRange), overlap)
		if #playerResults > 0 then
			checkPlayerTargets(playerResults)
		end
	end)

	local TargetParentChangedSignal
	local function recursiveTargetChange()
		TargetParentChangedSignal = Target:GetPropertyChangedSignal("Parent"):Connect(function()
			TargetParentChangedSignal:Disconnect()
			for _,Connection:RBXScriptConnection in pairs(activeTrackers) do
				Connection:Disconnect()
			end
		end)
	end

	radarScan:Play()
	ContextActionService:BindAction("DisableRadar", unbindScanner, true, Enum.KeyCode.P)
	ContextActionService:BindAction("DBG", DBG, false, Enum.KeyCode.M)
	dragify(Main)
end
coroutine.wrap(LKJE_fake_script)()
