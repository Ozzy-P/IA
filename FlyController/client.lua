-- Fly controller for IA, only compatible for anchored tools for controlling while seated (preferred)
-- Anchored tools may move the whole character relative to arm displacement from grip origin ([unfixable?] bug).
--!strict

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer



local Controller = {
	ActiveTool = nil,
	MaxSpeed = 50,
	V = 0,
	Connections = {}
}


function Controller:resetController()
	self.V = 0
	self.Run = false
	for _,Connection in pairs(self.Connections) do
		Connection:Disconnect()
	end
	self.ActiveTool.Parent = Player.Character
	self.ActiveTool:Destroy()
end


function Controller:stopController()
	self:resetController()
	warn("Stop.")
end


function Controller:unbind()
	Controller.Connections.Update:Disconnect();
	Controller.Connections.Update = nil
	Controller:stopController();
end


function Controller:pause()
	Controller.Run = false
end


function Controller:startControl()
	Controller.Run = true
	local Character = Player.Character
	local Camera = workspace.Camera
	coroutine.wrap(function()
		while Controller.Run do
			task.wait(.15)
			Controller.ActiveTool.Grip = CFrame.new((Character["Right Arm"].CFrame.Position - (Character["Right Arm"].CFrame.Position + Camera.CFrame.LookVector * Controller.V) )) 
			Controller.ActiveTool.Parent = Player.Backpack
			Controller.ActiveTool.Parent = Player.Character
		end
	end)()
end


function Controller.startController(Tool)
	Controller.ActiveTool = Tool
	Controller.Run = true
	local Character = Player.Character
	local Handle = Tool:FindFirstChild("Handle") -- :: BasePart
	local Mouse = Player:GetMouse()

	local ABackpackGui = Player.PlayerGui.BackpackGui.LocalScript
	if not ABackpackGui.Disabled then
		ABackpackGui.Disabled = not ABackpackGui.Disabled
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,true)
	end

	if Character == nil then
		warn"Controller:startController() was called, but player currently has no character."
		return
	end

	-- Redundant typecheck but why not
	assert(Handle:IsA("BasePart"), "PANIC: HANDLE IS NOT A BASEPART.")

	if Tool == nil or (Handle and Handle.Anchored == false) then
		warn"Controller:startController() was called, but tool is not a valid instance."
		return
	end

	local UIS, UIE, Update, CurrentMovement

	UIS = UserInputService.InputBegan:Connect(function(x,Observable)
		if Observable then return end
		if x.KeyCode == Enum.KeyCode["W"] then
			local NewMovement = HttpService:GenerateGUID()
			CurrentMovement = NewMovement
			coroutine.wrap(function()
				while CurrentMovement == NewMovement and Controller.V <= Controller.MaxSpeed  do
					Controller.V += 1.75
					task.wait(.15)
				end
			end)()
		elseif x.KeyCode == Enum.KeyCode["S"] then
			local NewMovement = HttpService:GenerateGUID()
			CurrentMovement = NewMovement
			coroutine.wrap(function()
				while CurrentMovement == NewMovement and Controller.V >= -Controller.MaxSpeed do
					Controller.V -= 1.75
					task.wait(.15)
				end
			end)()
		elseif x.KeyCode == Enum.KeyCode["Q"] then
			Controller:stopController()
		elseif x.KeyCode == Enum.KeyCode["A"] then
			if Controller.Run then
				Controller:pause()
				--CurrentMovement = nil
			else
				Controller:startControl()
			end
		elseif x.KeyCode == Enum.KeyCode["B"] then
			CurrentMovement = nil
			Controller.V = 0
		end
	end)

	UIS = UserInputService.InputEnded:Connect(function(x,Observable)
		if Observable then return end
		if (x.KeyCode == Enum.KeyCode["W"]) or (x.KeyCode == Enum.KeyCode["S"]) then
			CurrentMovement = nil
		end
	end)

	Update = RunService.Stepped:Connect(function()
		if not Tool or Tool.Parent == nil then warn("Invalid tool status.")
			Controller:unbind()
			return
		end
		if not Player.Character or Character ~= Player.Character then warn("Invalid character state.")
			Controller:unbind()
			return
		end
	end)

	Controller:startControl()


	Controller.Connections.UIS = UIS
	Controller.Connections.UIE = UIS
	Controller.Connections.Update = Update
end



task.wait(1)
Controller.startController(Player.Backpack:FindFirstChild("Sleeping Kit"))
