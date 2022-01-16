-- Not adjusted to scale correctly
-- Radar scans based on camera direction

-- Executive:  Red (Corp+) 
-- Players: Green (Visitor-Co-Owner)
-- Planes: Blue


local ScanTime = 1.5 -- Change time of each scan (disco mode?)
local PlayerDetectionRadius = 75
local ExecutiveDetectionRadius = 1500
local PlaneDetectionRadius = 2000
local RadarSize = 1

-- Gui to Lua
-- Version: 3.2
    -- CFrame black magic (AxisAngle: DeconstructCFrame, CFrameTimesVector3)
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

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local ImageLabel = Instance.new("ImageLabel")
local UICorner = Instance.new("UICorner")
local Sectors = Instance.new("Folder")
local Sector = Instance.new("Frame")
local Sector_2 = Instance.new("Frame")
local Sector_3 = Instance.new("Frame")
local Sector_4 = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local ImageLabel_2 = Instance.new("ImageLabel")
local Circle = Instance.new("ImageLabel")
local UIGradient_2 = Instance.new("UIGradient")
local Enemy = Instance.new("ImageLabel")
local Scale = Instance.new("UIScale",ScreenGui)
Scale.Scale = RadarSize

--Properties:

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageLabel.Parent = ScreenGui
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = .25
ImageLabel.ClipsDescendants = true
ImageLabel.Position = UDim2.new(0.201562494, 0, 0.197222218, 0)
ImageLabel.Size = UDim2.new(0, 200, 0, 200)
ImageLabel.Image = "rbxassetid://8317997041"

UICorner.CornerRadius = UDim.new(0, 720)
UICorner.Parent = ImageLabel

Sectors.Name = "Sectors"
Sectors.Parent = ImageLabel

Sector.Name = "Sector"
Sector.Parent = Sectors
Sector.BackgroundColor3 = Color3.fromRGB(0, 255, 17)
Sector.BackgroundTransparency = 0.750
Sector.BorderColor3 = Color3.fromRGB(0, 255, 17)
Sector.Position = UDim2.new(0.5, 0, 0, 0)
Sector.Size = UDim2.new(0, 0, 0.5, 0)

Sector_2.Name = "Sector"
Sector_2.Parent = Sectors
Sector_2.BackgroundColor3 = Color3.fromRGB(0, 255, 17)
Sector_2.BackgroundTransparency = 0.750
Sector_2.BorderColor3 = Color3.fromRGB(0, 255, 17)
Sector_2.Position = UDim2.new(0.75, 0, 0.25, 0)
Sector_2.Rotation = 90.000
Sector_2.Size = UDim2.new(0, 0, 0.479999989, 0)

Sector_3.Name = "Sector"
Sector_3.Parent = Sectors
Sector_3.BackgroundColor3 = Color3.fromRGB(0, 255, 17)
Sector_3.BackgroundTransparency = 0.750
Sector_3.BorderColor3 = Color3.fromRGB(0, 255, 17)
Sector_3.Position = UDim2.new(0.5, 0, 0.495000005, 0)
Sector_3.Size = UDim2.new(0, 0, 0.5, 0)

Sector_4.Name = "Sector"
Sector_4.Parent = Sectors
Sector_4.BackgroundColor3 = Color3.fromRGB(0, 255, 17)
Sector_4.BackgroundTransparency = 0.750
Sector_4.BorderColor3 = Color3.fromRGB(0, 255, 17)
Sector_4.Position = UDim2.new(0.25, 0, 0.25, 0)
Sector_4.Rotation = 90.000
Sector_4.Size = UDim2.new(0, 0, 0.479999989, 0)

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.45, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(76, 255, 0)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))}

UIGradient.Offset = Vector2.new(0.7,0)
--UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.35, 0.25), NumberSequenceKeypoint.new(0.50, 0.45), NumberSequenceKeypoint.new(0.65, 0.25), NumberSequenceKeypoint.new(1.00, 0.00)}
UIGradient.Parent = ImageLabel

ImageLabel_2.Parent = ImageLabel
ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_2.BackgroundTransparency = 1.000
ImageLabel_2.ClipsDescendants = true
ImageLabel_2.Position = UDim2.new(0, 0, 0.00300000003, 0)
ImageLabel_2.Size = UDim2.new(1, 0, 1, 0)
ImageLabel_2.Image = "rbxassetid://4885490162"
ImageLabel_2.ImageColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel_2.ImageTransparency = 1.000
ImageLabel_2.ScaleType = Enum.ScaleType.Fit

Circle.Name = "Circle"
Circle.Parent = ImageLabel
Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Circle.BackgroundTransparency = 1.000
Circle.ClipsDescendants = true
Circle.Size = UDim2.new(1, 0, 1, 0)
Circle.Image = "rbxassetid://8317997041"
Circle.ImageColor3 = Color3.fromRGB(0, 0, 0)

--[[local RadarMesh = Circle:Clone()
RadarMesh.Parent = ImageLabel
RadarMesh.Name = "Grid"
RadarMesh.ImageColor3 = Color3.fromRGB(0, 125, 255)
RadarMesh.Image = "rbxassetid://29051010"
RadarMesh.Position = UDim2.new(0.005,0,0,0)
RadarMesh.ImageTransparency = .85--]]


UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))}
UIGradient_2.Rotation = 90
UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.06, 0.49), NumberSequenceKeypoint.new(0.20, 0.80), NumberSequenceKeypoint.new(0.49, 0.77), NumberSequenceKeypoint.new(0.83, 0.78), NumberSequenceKeypoint.new(0.96, 0.48), NumberSequenceKeypoint.new(1.00, 0.00)}
UIGradient_2.Parent = Circle

Enemy.Name = "Enemy"
Enemy.Parent = ImageLabel
Enemy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Enemy.BackgroundTransparency = 1.000
Enemy.BorderSizePixel = 0
Enemy.ClipsDescendants = true
Enemy.Position = UDim2.new(0.485000014, 0, 0.474999994, 0)
Enemy.Size = UDim2.new(0.0599999987, 0, 0.0599999987, 0)
Enemy.Image = "rbxassetid://8317997041"
Enemy.ImageColor3 = Color3.fromRGB(0, 255, 0)
Enemy.ImageTransparency = 1.000

-- Scripts:
--NEGNSX, Returns: [nil?], Args: [nil]
local function NEGNSX()
	local script = Instance.new('LocalScript', ImageLabel)

	_G.Scan = true
	local Scan = script.Parent.UIGradient
	local InRadar = {}
	--dragify, Returns: nil, Args: Frame
	function dragify(Frame)
		local dragToggle = nil
		local dragSpeed = .25
		local dragInput = nil
		local dragStart = nil
		local dragPos = nil
	
		local function updateInput(input)
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
	
	dragify(script.Parent)
	
	
	
	local TweenService = game:GetService("TweenService")
	task.wait(.25)
	local info = TweenInfo.new(ScanTime,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1,false,0)
	local Goals = {Sector1={Rotation = 180}}
	local Scanner  = TweenService:Create(Scan, info, Goals.Sector1)
	
	
	Scanner:Play()

	--  Thx to: cxuu for magnitude on random devforum question
	local Players = game:GetService('Players')
	local LocalPlayer = Players.LocalPlayer
	local RadarScaling = PlayerDetectionRadius + 20

	local HR = {"Corporate Officer","Chief Executive Officer","Group Manager","Group Administrator","Vice Chairman","Chairman"}
	-- scanPlayers, Return: [table], Args [nil]
	local function scanPlayers()
		local Nearby = {}
		for _,Player in next, game:GetService("Players"):GetChildren() do
			local character = Player.Character
			local plrRank = Player.leaderstats:FindFirstChild("Rank")
			if character and plrRank and character.Parent and Player ~= LocalPlayer and character:FindFirstChild("HumanoidRootPart") then
				local Magnitude = (workspace.Camera.CFrame.Position - character.HumanoidRootPart.Position).magnitude
				if table.find(HR,plrRank.Value) and Magnitude <= ExecutiveDetectionRadius  then
					local PlayerInformation = {Player.Name,Magnitude,character.HumanoidRootPart.Position,character,"RUN.",{Magnitude,ExecutiveDetectionRadius}}
					table.insert(Nearby, PlayerInformation)
				elseif Magnitude <= PlayerDetectionRadius then
					local PlayerInformation = {Player.Name,Magnitude,character.HumanoidRootPart.Position,character,false,{Magnitude,PlayerDetectionRadius}}
					table.insert(Nearby, PlayerInformation)
				end
			end
		end
		for _,plane in pairs(workspace["Ins/InsClr"].Value:GetChildren()) do
		    if plane:FindFirstChild("planeKit") then
			    if plane.planeKit.PrimaryPart ~= nil then
			        local Magnitude = (workspace.Camera.CFrame.Position - plane.planeKit.PrimaryPart.CFrame.Position).magnitude
				    if Magnitude <= PlaneDetectionRadius then
                        local PlaneInformation = {plane.Name,Magnitude,plane.planeKit.PrimaryPart.Position,plane.planeKit,true,{Magnitude,PlaneDetectionRadius}}
                        table.insert(Nearby, PlaneInformation)
                    end
                end
            end
        end
		return Nearby 
	end
	
	local Enemy = script.Parent.Enemy
	-- createBlip, Return: [nil], Args [table]
	local function createBlip(target)
		local Blip = Enemy:Clone()

		-- Restrict out of bounds area
		local Distance = CFrameTimesVector3(workspace.Camera.CFrame,target[3])
		local Multiplier = 1
		if target[6][1] > target[6][2] * .65 then Multiplier = .7 end
		local X_Distance = (Distance - Vector3.new()).X--.Unit.X
		local Z_Distance = (Distance - Vector3.new()).Z--.Unit.Z
		-- Center of Radar.
		local RadarX,RadarZ = .485,.475
		local OwO = .0075
		RadarX = RadarX + ( X_Distance * OwO * Multiplier )
		RadarZ = RadarZ + ( Z_Distance * OwO * Multiplier )

		Blip.Position = UDim2.new(RadarX,0,RadarZ,0)
		Blip.Parent = script.Parent
		local info = TweenInfo.new(ScanTime / 2,Enum.EasingStyle.Quad,Enum.EasingDirection.In,0,false,0)
		local infoFast = TweenInfo.new(ScanTime / 4,Enum.EasingStyle.Quad,Enum.EasingDirection.In,0,false,0)
		local Goals = {Fade={ImageTransparency = 1},FadeIn = {ImageTransparency = .4}}
		if target[5] == true then
	        	Blip.ImageColor3 = Color3.new(0,0,255)
	        	Blip.Size = UDim2.new(0.1, 0, 0.1, 0)
	        	Goals.FadeIn.ImageTransparency = 0
	    	elseif target[5] == "RUN." then
	        	Blip.ImageColor3 = Color3.new(255,0,0)
            		Blip.Size = UDim2.new(0.1, 0, 0.1, 0)
            		Goals.FadeIn.ImageTransparency = 0
	   	end
	   	
		local FadeIn  = TweenService:Create(Blip, infoFast, Goals.FadeIn)
		local FadeBlip  = TweenService:Create(Blip, info, Goals.Fade)
		
		FadeIn:Play()
	
	local DelayedDestruction = coroutine.wrap(function()
	            FadeIn.Completed:Wait()
				FadeBlip:Play()
				FadeBlip.Completed:Wait()
				Blip:Destroy()
		end)
		DelayedDestruction()
	end
	

	
	
	local RadarMode = coroutine.wrap(function()
		while _G.Scan == true do
		    repeat wait() until Scan.Rotation > 175 and Scan.Rotation < 180 or _G.Scan == false
			for _,foundPlayer in pairs(scanPlayers()) do
				createBlip(foundPlayer)
			end
		end
		script.Parent.Parent:Destroy()
	end)
	
	RadarMode()
	-- GEvent, Return: [nil], Args [InputObject,bool]
	local GEvent;GEvent = game:GetService("UserInputService").InputBegan:Connect(function(x,Observable)
		if Observable then return end
		if x.KeyCode == Enum.KeyCode.P then 
			_G.Scan = false
			Scanner:Cancel()
			GEvent:Disconnect() return
		end
	end)
	
	
end
coroutine.wrap(NEGNSX)()
