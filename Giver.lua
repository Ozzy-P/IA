local GIVER = nil
local PLAYERS = game:GetService("Players")
local HttpService = game:GetService("HttpService")

assert(GIVER ~= nil, "INVALID REMOTE PASSED TO SCRIPT SCOPE (check upval?)")

_G.PREFIX = "!"
_G.ENABLED = true
_G.ToggleBlacklist = false
_G.ToggleON = "ON"
_G.ToggleOFF = "OFF"

local food = {}

local QUEUE_DELAY = 1.2
local queue = {}
local target = {}
queue.data = {}

function queue:Pop()
    if #self.data < 1 then return end
    task.wait((#self.data) * QUEUE_DELAY)
    table.remove(self.data,self.data[1]())
end

function queue:Add(func)
    table.insert(self.data,func)
    self:Pop()
end

local function SendNotification(msg)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Giver Sys";
		Text = msg;
		Duration = 3;
		Button1 = "Dismiss";
	})
end

_G.Data = (isfile("giver.txt") and HttpService:JSONDecode(readfile("giver.txt"))) or (writefile("giver.txt",'{"RESTRICTED_ITEMS":[],"BLACKLIST":{"USERNAMEHERE":0}}') and HttpService:JSONDecode(readfile("giver.txt")))

_G.BlacklistF = _G.BlacklistF or function(x)
    if(_G.Data.BLACKLIST[x]) then
        _G.Data.BLACKLIST[x] = nil
    else
        _G.Data.BLACKLIST[x] = true
    end

    target.Info.Main.Status.Text = ("BLACKLISTED: %s"):format(_G.Data.BLACKLIST[x] and "TRUE" or "FALSE")
    writefile("giver.txt",HttpService:JSONEncode(_G.Data))
    _G.Data = HttpService:JSONDecode(readfile("giver.txt"))

end


local state = Enum.RaycastFilterType.Include

local function giveItem(PLAYER,itemName)
    if not _G.ENABLED or _G.Data.BLACKLIST[PLAYER.Name] then return end
    queue:Add(function()
        if (not PLAYER) or (PLAYER.Parent ~= PLAYERS) then SendNotification("Player left before action was completed") return 1 end
        GIVER:FireServer(PLAYER,itemName)
        SendNotification(("Gave %s to %s"):format(itemName,PLAYER.Name))
        return 1
    end)
end

local function checkItem(Player,x)
    local item = x:lower():gsub(("[ %s]*[%s]*[%s ]*"):format(table.unpack((_G.PREFIX .. " "):rep(3):split(" "))),""):split(" ")[1]
    if food[item] then
        giveItem(Player,food[item])
    end
end

local function GetPlayer(plrname)
    for _,player in pairs(game:GetService("Players"):GetPlayers()) do
        if plrname:lower() == player.Name:sub(1,plrname:len()):lower() then
            return player
        end
    end
    return nil
end		

    
for _, Player in pairs(PLAYERS:GetChildren()) do
    Player.Chatted:Connect(function(x)
        checkItem(Player,x)
    end)
end

PLAYERS.ChildAdded:Connect(function(Player)
    Player.Chatted:Connect(function(x)
        checkItem(Player,x)
    end)
end)

if not _G.Givers then
    _G.Givers = PLAYERS.LocalPlayer.Chatted:Connect(function(x)
        if x == ("!%s"):format(_G.ToggleON) then
            _G.ENABLED = true
        elseif x == ("!%s"):format(_G.ToggleOFF) then
            _G.ENABLED = false
        elseif x:split(" ")[1] == ":handto" then
            local plrGive = GetPlayer(x:split(" ")[2])
            local tool = PLAYERS.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            local toolCurr = tool and tool.Name:lower()
            if plrGive and toolCurr and food[toolCurr] then
                queue:Add(function()
                    if (not plrGive) or (plrGive.Parent ~= PLAYERS) then SendNotification("Player left before action was completed") return 1 end
                        GIVER:FireServer(plrGive,food[toolCurr])
                        if tool and tool.Parent == PLAYERS.LocalPlayer.Character then
                            tool:Destroy()
                        end
                        SendNotification(("Gave %s to %s"):format(toolCurr,plrGive.Name))
                    return 1
                end)
            end
        end
    end)
end

local mouse = PLAYERS.LocalPlayer:GetMouse()

local function createInfo(chara, stat)
   local Bill = Instance.new("BillboardGui",chara)
   local Main = Instance.new("Frame",Bill)
   local Status = Instance.new("TextLabel", Main)
   local UIP = Instance.new("UIPadding",Status)

   Bill.Name = "GeeGee"
   Bill.Size = UDim2.new(5,0,1,0)
   Bill.StudsOffset = Vector3.new(0,4,0)
   Bill.AlwaysOnTop = false
   Bill.LightInfluence = 0
   Bill.Adornee = chara.Head

   Main.Name = "Main"
   Main.BackgroundTransparency = 1
   Main.Size = UDim2.new(1,0,1,0)

   Status.Text = "BLACKLISTED: " .. stat
   Status.Size = UDim2.new(1,0,1,0)
   Status.TextColor3 = Color3.fromRGB(81, 0, 255)
   Status.TextStrokeColor3 = Color3.new(1,1,1)
   Status.TextStrokeTransparency = 0
   Status.Font = Enum.Font.GothamBold
   Status.TextScaled = true
   Status.Name = "Status"
   Status.BackgroundTransparency = 1
   
   UIP.PaddingBottom = UDim.new(0.15,0)

   target.Info = Bill
end

local function createInventoryStatus()
    local Bill = Instance.new("BillboardGui", target.Player.Character)
    Bill.Adornee = target.Player.Character.Head
    Bill.Size = UDim2.new(10,0,8,0)
    Bill.LightInfluence = 0
    Bill.StudsOffsetWorldSpace = Vector3.new(0,10,0)
    Bill.AlwaysOnTop = false
    Bill.Brightness = 2

    local Main = Instance.new("Frame",Bill)
    local Grid = Instance.new("UIGridLayout",Main)
    local Pad = Instance.new("UIPadding",Main)

    Main.Name = "Inventory"
    Main.Size = UDim2.new(1,0,1,0)
    Main.BackgroundTransparency = 1

    Grid.CellPadding = UDim2.new(0.05, 0, 0.05, 0)
    Grid.CellSize = UDim2.new(0.2, 0, 0.2, 0)
    Grid.FillDirection = Enum.FillDirection.Horizontal
    Grid.FillDirectionMaxCells = 5
    Grid.SortOrder = Enum.SortOrder.Name
    Grid.VerticalAlignment = Enum.VerticalAlignment.Bottom

    Pad.PaddingLeft = UDim.new(0.05,0)
    Pad.PaddingRight = UDim.new(0.05,0)
    Pad.PaddingTop = UDim.new(0.05,0)
    Pad.PaddingBottom = UDim.new(0.05,0)

    local labels = 0
    local function createLabel(Name,Image,Count)
        local SampleTool= Instance.new("ImageLabel",Main)
        local UIC = Instance.new("UICorner",SampleTool)
        local AS = Instance.new("UIAspectRatioConstraint",SampleTool)
        local Amount = Instance.new("TextLabel", SampleTool)
        local PlaceHolder = Instance.new("TextLabel",SampleTool)

        SampleTool.Size = UDim2.new(0.2,0,0.2,0)
        SampleTool.AnchorPoint = Vector2.new(.5,.5) 
        SampleTool.Position = UDim2.new(.5,0,.5,0)
        SampleTool.Name = tostring(labels)
        SampleTool.Image = Image
        
        PlaceHolder.Text = Name
        PlaceHolder.Font = Enum.Font.GothamBlack
        PlaceHolder.Position = UDim2.new(0,0,0.25,0)
        PlaceHolder.TextColor3 = Color3.new(0,0,0)
        PlaceHolder.BackgroundTransparency = 1
        PlaceHolder.TextStrokeTransparency = 0.3
        PlaceHolder.TextStrokeColor3 = Color3.new(1,1,1)
        PlaceHolder.Size = UDim2.new(1,0,.45,0)
        PlaceHolder.TextScaled = true
        
        if Image ~= "" then
            PlaceHolder.Visible = false
        end

        Amount.BackgroundTransparency = 1
        Amount.Text = "x" .. Count
        Amount.Font = Enum.Font.GothamBlack
        Amount.Size = UDim2.new(0.75, 0, 0.75, 0)
        Amount.Position = UDim2.new(-0.25, 0,-0.25, 0)
        Amount.Name = "Amount"
        Amount.TextScaled = true
        Amount.TextColor3 = Color3.new(1,1,1)
        Amount.TextStrokeTransparency = 0

        UIC.CornerRadius = UDim.new(1,0)
        labels += 1
    end

    local totals = {}
    for _,tool in pairs(target.Player.Backpack:GetChildren()) do
        if(not tool:IsA("Tool")) then continue end
        totals[tool.Name] = totals[tool.Name] or {Count = 0, Image = tool.TextureId}
        totals[tool.Name].Count += 1
    end
    for _,tool in pairs(target.Player.Character:GetChildren()) do
        if(not tool:IsA("Tool")) then continue end
        totals[tool.Name] = totals[tool.Name] or {Count = 0, Image = tool.TextureId}
        totals[tool.Name].Count += 1
    end

    for toolName,toolData in pairs(totals) do
        createLabel(toolName,toolData.Image,tostring(toolData.Count))
    end



    target.Inventory = Bill

end

game:GetService("RunService").Stepped:Connect(function()
    if not _G.ToggleBlacklist or mouse.Target == nil then return end
    
    local t = mouse.Target
    local plr = PLAYERS:GetPlayerFromCharacter(t.Parent)
    if plr and target.Player and target.Player ~= plr then
        target.Player = nil
        target.highlight:Destroy()
        target.Info:Destroy()
        target.Inventory:Destroy()
    end
    if plr and target.Player ~= plr then
        target.Player = plr
        target.highlight = Instance.new("Highlight",t.Parent)
        target.highlight.FillColor = Color3.fromRGB(0, 145, 255)
        target.highlight.FillTransparency = 0.35
        createInfo(t.Parent,(_G.Data.BLACKLIST[plr.Name] and "TRUE") or "FALSE")
        createInventoryStatus()
    end
end)



game:GetService("UserInputService").InputBegan:Connect(function(x,Observable)
    if Observable then return end
    if x.KeyCode == Enum.KeyCode.B and target.Player then
        _G.BlacklistF(target.Player.Name)
    end
    if x.KeyCode == Enum.KeyCode.T then
        _G.ToggleBlacklist = not _G.ToggleBlacklist
        if target.Player then
            target.Player = nil
            target.highlight:Destroy()
            target.Info:Destroy()
            target.Inventory:Destroy()
        end
    end
    if x.KeyCode == Enum.KeyCode.O then
        _G.ToggleBlacklist = not _G.ToggleBlacklist
    end
end)
