-- PM/SM/H data not encrypted, yet.
-- Removed comments due to legal reasons, ask HR..

repeat task.wait() until game:GetService("Players").LocalPlayer ~= nil
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Essentials = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Essentials Client",4)
assert(Essentials ~= nil, "Index error.")
local baseClip = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Essentials Client"):WaitForChild("Base Clip")
local dmFrame =  baseClip["Direct Messages"]
local dmInner = dmFrame["Inner"]
local displayPM

local tweenService = game:GetService("TweenService")
local PMData = nil -- REMOVED
local Send = nil  -- REMOVED
local PrivateMessage = nil -- REMOVED
local ServerMessage = nil -- REMOVED
local HintMessage = nil -- REMOVED
local RbxSignal = nil -- REMOVED
local PrivateMessageEvent = {OnClientEvent = PrivateMessage[RbxSignal]}
local ServerMessageEvent = {OnClientEvent = ServerMessage[RbxSignal]}
local HintMessageEvent = {OnClientEvent = HintMessage[RbxSignal]}
local Display

Display = function(Type,Data)
	local Connections = {}

	local function Disconnect()
		if #Connections > 0 then
			repeat
				local Connection = Connections[1]
				Connection:Disconnect()
				table.remove(Connections,1)
			until #Connections == 0
		end
	end

	if Type == "Message" then
		pcall(function()
			for a,b in next,baseClip:GetChildren() do
				if b.Name == 'Message Clone' then
					b:TweenPosition(UDim2.new(0,0,1,0),'Out','Quint',0.3,true,function(Done)
						if Done == Enum.TweenStatus.Completed and b then
							b:Destroy()
						elseif Done == Enum.TweenStatus.Canceled and b then
							b:Destroy()
						end
					end)
				end
			end
		end)
		local Title,Message = Data[1],Data[2]
		local messageTemplate = baseClip:WaitForChild('Message Template')
		local messageClone = messageTemplate:Clone()
		messageClone.Name = "Message Clone"
		messageClone.Size = UDim2.new(1,0,0,baseClip.AbsoluteSize.Y)
		messageClone.Position = UDim2.new(0,0,-1,0)
		messageClone.Parent = baseClip
		messageClone.Visible = true
		local closeButton = messageClone:WaitForChild('TextButton')
		local Top = messageClone:WaitForChild('Top')
		local Body = messageClone:WaitForChild('Body')
		local topTitle = Top:WaitForChild('Title')
		local bodyText = Body:WaitForChild('To Name Later')
		local Left = Top:WaitForChild('Left')
		topTitle.Text = Title
		bodyText.Text = Message
		local bodyBounds_Y = bodyText.TextBounds.Y
		if bodyBounds_Y < 30 then
			bodyBounds_Y = 30
		else
			bodyBounds_Y = bodyBounds_Y + 15
		end
		local titleSize_Y = Top.Size.Y.Offset
		messageClone.Size = UDim2.new(1,0,0,bodyBounds_Y+titleSize_Y)

		local function Resize()
			local toDisconnect
			local Success, Message = pcall(function()
				toDisconnect = baseClip.Changed:connect(function(Prop)
					if Prop == "AbsoluteSize" then
						messageClone.Size = UDim2.new(1,0,0,baseClip.AbsoluteSize.Y)
						local bodyBounds_Y = bodyText.TextBounds.Y
						if bodyBounds_Y < 30 then
							bodyBounds_Y = 30
						else
							bodyBounds_Y = bodyBounds_Y + 15
						end
						local titleSize_Y = Top.Size.Y.Offset
						messageClone.Size = UDim2.new(1,0,0,bodyBounds_Y+titleSize_Y)
						if (messageClone ~= nil and messageClone.Parent == baseClip) then
							messageClone:TweenPosition(UDim2.new(0,0,0.5,-messageClone.Size.Y.Offset/2),'Out','Quint',0.5,true)
						else
							if toDisconnect then
								toDisconnect:Disconnect()
							end
							return
						end
					end
				end)
			end)
			if Message and toDisconnect then
				toDisconnect:Disconnect()
				return
			end
		end

		messageClone:TweenPosition(UDim2.new(0,0,0.5,-messageClone.Size.Y.Offset/2),'Out','Quint',0.5,true,function(Status)
			if Status == Enum.TweenStatus.Completed then
				Resize()
			end
		end)

		table.insert(Connections,closeButton.MouseButton1Click:connect(function()
			pcall(function()
				messageClone:TweenPosition(UDim2.new(0,0,1,0),'Out','Quint',0.3,true,function(Done)
					if Done == Enum.TweenStatus.Completed and messageClone then
						messageClone:Destroy()
					elseif Done == Enum.TweenStatus.Canceled and messageClone then
						messageClone:Destroy()
					end
				end)
			end)
		end))

		local waitTime = (#bodyText.Text*0.1)+1
		local Position_1,Position_2 = string.find(waitTime,"%p")
		if Position_1 and Position_2 then
			local followingNumbers = tonumber(string.sub(waitTime,Position_1))
			if followingNumbers >= 0.5 then
				waitTime = tonumber(string.sub(waitTime,1,Position_1))+1
			else
				waitTime = tonumber(string.sub(waitTime,1,Position_1))
			end
		end
		if waitTime > 15 then
			waitTime = 15
		elseif waitTime <= 1 then
			waitTime = 2
		end
		Left.Text = waitTime..'.00'
		for i=waitTime,1,-1 do
			if not Left then break end
			Left.Text = i..'.00'
			wait(1)
		end
		Left.Text = "Closing.."
		wait(0.3)
		if messageClone then
			pcall(function()
				messageClone:TweenPosition(UDim2.new(0,0,1,0),'Out','Quint',0.3,true,function(Done)
					if Done == Enum.TweenStatus.Completed and messageClone then
						messageClone:Destroy()
					elseif Done == Enum.TweenStatus.Canceled and messageClone then
						messageClone:Destroy()
					end
				end)
			end)
		end
	elseif Type == "Hint" then
		if baseClip:FindFirstChild('Hint Clone') then
			local toRemove = baseClip:FindFirstChild('Hint Clone')
			toRemove:TweenPosition(UDim2.new(0,0,0,-toRemove.AbsoluteSize.Y),'Out','Quint',0.3,true,function(Stat)
				if Stat == Enum.TweenStatus.Completed then
					toRemove:Destroy()
				end
			end)
		end

		local hintTemplate = baseClip:WaitForChild('Hint Template')
		local hintClone = hintTemplate:Clone()
		hintClone.Name = "Hint Clone"
		local hintButton = hintClone:WaitForChild('TextButton')
		local hintTop = hintClone:WaitForChild('Top')
		local hintBody = hintClone:WaitForChild('Body')
		local hintTitleText = hintTop:WaitForChild('Title')
		local hintBodyText = hintBody:WaitForChild('To Name Later')

		hintButton.MouseButton1Click:connect(function()
			hintClone:TweenPosition(UDim2.new(0,0,0,-hintClone.AbsoluteSize.Y),'Out','Quint',0.3,true,function(Stat)
				if Stat == Enum.TweenStatus.Completed then
					hintClone:Destroy()
				end
			end)
		end)

		hintTitleText.Text = Data[1]
		hintBodyText.Text = Data[2]
		hintClone.Parent = baseClip
		hintClone.Visible = true
		hintClone.Position = UDim2.new(0,0,-1,0)
		hintClone:TweenPosition(UDim2.new(0,0,0,0),'Out','Quint',0.3,true)
		local waitTime = (#hintBodyText.Text*0.1)+1
		if waitTime <= 1 then
			waitTime = 2.5
		elseif waitTime > 10 then
			waitTime = 10
		end
		wait(waitTime)
		pcall(function()
			if hintClone then
				hintClone:TweenPosition(UDim2.new(0,0,0,-hintClone.AbsoluteSize.Y),'Out','Quint',0.3,true,function(Stat)
					if Stat == Enum.TweenStatus.Completed then
						hintClone:Destroy()
					end
				end)
			end
		end)
	end
end



local Stacks = {Notifs = {},Frames = {}}
local function figureFrames(Stack)
	local stacksize = 0
	local i = #Stack
	while i > 0 do
		local gui = Stack[i]
		if gui then
			local guiSize = gui.AbsoluteSize.X+10
			stacksize = stacksize + guiSize
			local desiredpos = UDim2.new(0,stacksize-250,0.5,-150)
			if gui.Position ~= desiredpos then
				gui:TweenPosition(desiredpos,"Out","Quint",0.3,true)
				if desiredpos.X.Offset > baseClip.AbsoluteSize.X-250 and gui.Name ~= gui.Name.."_RemovingThis" then
					gui.Name = gui.Name.."_RemovingThis"
					table.remove(Stack,i)
					gui:TweenPosition(UDim2.new(1,5,0.5,-150),"Out","Quint",0.3,true)
					repeat wait() if not gui then return end until gui.Position == UDim2.new(1,0,0.5,-150)
					gui:Destroy()
				end
			end
		end
		i = i-1
	end
end

local function moveOn(pageLayout,dmInner,lastPm)
	pageLayout:Previous()
	local function Fade(Wait)
		local Done = Instance.new('BindableEvent')
		local countEvent = Instance.new('BindableEvent')
		local Frames,Tweens_Completed = {},{}
		local Count_Connection
		Count_Connection = countEvent.Event:Connect(function(Data)
			table.insert(Tweens_Completed,Data)
			if #Frames == #Tweens_Completed then
				Count_Connection:Disconnect()
				countEvent:Destroy()
				lastPm:Destroy()
				Done:Fire()
			end
		end)
		for a,b in next,lastPm:GetDescendants() do
			if b:IsA('Frame') or b:IsA('TextBox') or b:IsA('TextLabel') or b:IsA('TextButton') then
				table.insert(Frames,b)
			end
		end
		for c,d in next,Frames do
			local Tween = tweenService:Create(
				d,
				TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
				{BackgroundTransparency = 1}				
			)
			local CompletedCon
			CompletedCon = Tween.Completed:Connect(function()
				CompletedCon:Disconnect()
				Tween:Destroy()
				countEvent:Fire(d)
			end)
			Tween:Play()
			if d:IsA('TextBox') or d:IsA('TextLabel') or d:IsA('TextButton') then
				local Tween = tweenService:Create(
					d,
					TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
					{TextTransparency = 1}				
				)
				local CompletedCon2
				CompletedCon2 = Tween.Completed:Connect(function()
					CompletedCon2:Disconnect()
					Tween:Destroy()
					countEvent:Fire(d)
				end)
				Tween:Play()
			end
		end
		if Wait then
			Done.Event:Wait()
			Done:Destroy()
		end
	end
	Fade()
	local Con_1
	Con_1 = pageLayout.PageLeave:Connect(function(Obj)
		if Obj == lastPm then
			Con_1:Disconnect()
			Obj:Destroy()
		end
	end)
	local Con_2
	Con_2 = pageLayout.PageEnter:Connect(function(Obj)
		if Obj == lastPm then
			Con_2:Disconnect()
			Obj:Destroy()
		end
	end)
	local Con_3
	Con_3 = pageLayout.Stopped:Connect(function(Obj)
		if Obj == lastPm then
			Con_3:Disconnect()
			Obj:Destroy()
		end
	end)
	local realChildren = 0
	for a,b in next,dmInner:GetChildren() do
		if b:IsA('Frame') then
			realChildren = realChildren + 1
		end
	end
	lastPm.Changed:Connect(function()
		if lastPm.Parent == nil then
			local realChildren = 0
			for a,b in next,dmInner:GetChildren() do
				if not b:IsA('UIPageLayout') then
					realChildren = realChildren + 1
				end
			end
			if realChildren == 0 then
				Fade(true)
				dmInner.Visible = false
			end
		end
	end)
end


function figureNotifs(Stack,Container)
	local stacksize = 0
	local i = #Stack
	while i > 0 do
		local gui = Stack[i]
		if gui then
			stacksize = stacksize+gui.AbsoluteSize.Y+5
			local desiredpos = UDim2.new(0,0,1,-stacksize)
			if gui.Position ~= desiredpos then
				gui:TweenPosition(desiredpos,"Out","Quint",0.3,true)
				if desiredpos.Y.Offset<-Container.AbsoluteSize.Y then -- and gui.Name ~= "RemovingThis" 
					local Inner = gui:WaitForChild('Inner')
					Inner:TweenPosition(UDim2.new(0,0,1,0),'Out','Quint',0.3,true)
				else
					local Inner = gui:WaitForChild('Inner')
					Inner:TweenPosition(UDim2.new(0,0,0,0),'Out','Quint',0.3,true)
				end
			end
		end
		i = i-1
	end
end

local function pendNotif(Title,Desc,Data)
	spawn(function()
		local notificationContainer = baseClip:WaitForChild('Container')
		local Notification = notificationContainer:WaitForChild('Template')	
		local notifClone = Notification:Clone()
		local notifInner = notifClone:WaitForChild('Inner')
		local notifControls = notifInner:WaitForChild('Controls')
		local notifTitle = notifControls.Decoration:WaitForChild('Title')
		local notifExit = notifControls:WaitForChild('Exit')
		local notifOpen = notifInner:WaitForChild('Open')
		local notifDesc = notifInner:WaitForChild('Desc')
		notifClone.Name = 'Notif Clone'
		notifClone.Visible = true
		notifClone.Parent = notificationContainer
		notifTitle.Text = Title
		notifDesc.Text = Desc

		local receiveSound = Instance.new('Sound',Workspace.CurrentCamera)
		receiveSound.Name = 'Notification'
		receiveSound.SoundId = 'rbxassetid://255881176'
		receiveSound.Volume = 1
		receiveSound.Pitch = 1
		receiveSound.PlayOnRemove = true
		receiveSound:Destroy()

		notifClone.Position = UDim2.new(0,0,1,0)
		notifInner.Position = UDim2.new(0,0,1,0)
		notifInner:TweenPosition(UDim2.new(0,0,0,0),'Out','Quint',0.3,true)

		if Data[5] then
			local Tag = Instance.new('StringValue',notifClone)
			Tag.Name = "Tag"
			Tag.Value = Data[5]
		end

		local exitConnection
		exitConnection = notifExit.MouseButton1Click:connect(function()
			exitConnection:Disconnect()
			if Data[5] then
			end
			for a,b in pairs(Stacks.Notifs) do
				if b == notifClone then
					table.remove(Stacks.Notifs,a)
				end
			end
			notifClone:Destroy()
			figureNotifs(Stacks.Notifs,notificationContainer)
		end)

		local openConnection
		openConnection = notifOpen.MouseButton1Click:connect(function()
			openConnection:Disconnect()
			local Data = PMData["\70\79"]["\86\97\108\117\101"]
			local Override = true
			local ID = 42069
			local TargetPlayer = string.split(PMData["\70\78"]["\86\97\108\117\101"]," ")
			displayPM(PMData["\80\105\108\111\116"]["\86\97\108\117\101"],Data,Override,ID)
			for a,b in pairs(Stacks.Notifs) do
				if b == notifClone then
					table.remove(Stacks.Notifs,a)
				end
			end
			notifClone:Destroy()
			figureNotifs(Stacks.Notifs,notificationContainer)
		end)
		table.insert(Stacks.Notifs,notifClone)
		figureNotifs(Stacks.Notifs,notificationContainer)
	end)
end

local layoutConnection
displayPM = function(Sender,Data,Override,ID)
	local dmFrame = baseClip:WaitForChild('Direct Messages')
	local holderFrame = dmFrame:WaitForChild('Holder')
	local dmInner = dmFrame:WaitForChild('Inner')
	local pageLayout = dmInner:WaitForChild('UIPageLayout')

	local SenderData = PMData["\80\105\108\111\116"]["\86\97\108\117\101"]
	if not Override then
		task.wait(.25)
		pendNotif("Personal Message","From "..PMData["\80\105\108\111\116"]["\86\97\108\117\101"],{"Receive",SenderData,Data,true,ID})
		return
	end

	local pmFrame = baseClip:WaitForChild('Personal Message Template')
	local pmClone = pmFrame:Clone()

	if layoutConnection and layoutConnection.Connected then
		layoutConnection:Disconnect()
	end

	layoutConnection = pageLayout.Changed:Connect(function(Prop)
		if Prop == "CurrentPage" then
			dmInner:TweenSize(UDim2.new(0,420,0.1,pageLayout.CurrentPage.Size.Y.Offset),'Out','Quint',0.3,true)
		end
	end)	

	dmInner.Visible = true

	if ID then
		local Tag = Instance.new('StringValue',pmClone)
		Tag.Name = "Tag"
		Tag.Value = ID
	end

	local pmTop = pmClone:WaitForChild('Top')
	local pmControls = pmTop:WaitForChild('Controls')
	local pmTitle = pmControls.Decoration:WaitForChild('Title')
	local pmBottom = pmClone:WaitForChild('Bottom')

	local pmExit = pmControls:WaitForChild('Exit')
	local pmBody = pmTop.Body['To Name Later']
	local pmBox = pmBottom.Frame.Entry:WaitForChild('TextBox')
	local pmBoxButtonlolz = pmBox:WaitForChild('TextButton')
	local pmSend = pmBottom.Frame.Options:WaitForChild('Send')
	local pmCancel = pmBottom.Frame.Options:WaitForChild('Cancel')

	local pmRead = pmBottom.Frame.Options:WaitForChild('Read')	
	local pmReadReceipt = pmRead:WaitForChild('Toggled')

	pmReadReceipt.Size = UDim2.new(0,0,0,0)
	pmReadReceipt.Visible = true

	pmClone.Name = "PM Clone"
	pmClone.Parent = holderFrame
	pmClone.Visible = true

	if ID then
		pmTitle.Text = "Message from "..SenderData
	else
		pmSend.Visible = false
		pmCancel.Text = "Close"
		pmTitle.Text = Sender
	end

	local addedConnection 
	addedConnection = pmBody.Changed:Connect(function(Wa)
		if Wa == "TextBounds" then
			addedConnection:Disconnect()
			local bodyBounds_Y = pmBody.TextBounds.Y
			pmTop.Size = UDim2.new(1,0,0,bodyBounds_Y+47)
			pmClone.Size = UDim2.new(0,420,0,pmTop.AbsoluteSize.Y+pmBottom.AbsoluteSize.Y+5)
			dmInner:TweenSize(UDim2.new(0,420,0.1,pmClone.Size.Y.Offset),'Out','Quint',0.3,true)
			pmClone.Parent = dmInner
			if Override then
				pageLayout:JumpTo(pmClone)
			end
		end
	end)	

	if (not Data) or Data == "" then
		Data = "This message is empty."
	end

	pmBody.Text = Data

	if ID then
		local sendConnection
		sendConnection = pmSend.MouseButton1Click:connect(function()
			sendConnection:Disconnect()
			Send:FireServer(math.random(1,10000) .. " " .. Sender,666,pmBox.Text,game:GetService("Players").LocalPlayer.Name,"230VUwU","230VOwO",0)
			moveOn(pageLayout,dmInner,pmClone)
		end)
	end

	local exitConnection
	exitConnection = pmExit.MouseButton1Click:connect(function()
		exitConnection:Disconnect()
		moveOn(pageLayout,dmInner,pmClone)
	end)

	local cancelConnection
	cancelConnection = pmCancel.MouseButton1Click:connect(function()
		cancelConnection:Disconnect()
		moveOn(pageLayout,dmInner,pmClone)
	end)

	local lastClick
	pmBoxButtonlolz.MouseButton1Down:Connect(function()
		if not lastClick then
			lastClick = tick()
			pmBox:CaptureFocus()
		else
			if tick()-lastClick < 0.25 then
				pmBox.Text = ""
				pmBox:CaptureFocus()
			else
				pmBox:CaptureFocus()
			end
			lastClick = tick()
		end
	end)

	local Delaying
	pmBox.Focused:Connect(function()
		Delaying = math.random(1,10000)
		local storedDelay = Delaying
		delay(0.5,function()
			if Delaying == storedDelay then
				if pmBox:IsFocused() and pmBoxButtonlolz then
					pmBoxButtonlolz.Visible = false
				end
			end
		end)
	end)

	if ID then
		local focusConnection
		focusConnection = pmBox.FocusLost:connect(function(enterPressed)
			pmBoxButtonlolz.Visible = true
			if enterPressed then
				focusConnection:Disconnect()
				Send:FireServer(math.random(1,10000) .. " " .. Sender,666,pmBox.Text,game:GetService("Players").LocalPlayer.Name,"230VUwU","230VOwO",0)
				moveOn(pageLayout,dmInner,pmClone)
			end
		end)
	else
		pmBox.Text = "You cannot reply to this message."
	end

	local acceptableText
	pmBox.Changed:Connect(function(Prop)
		if Prop == "TextBounds" then
			pmBottom.Size = UDim2.new(1,0,0,200)
			if pmBox.TextFits then
				if ID then
					acceptableText = pmBox.Text
				else
					acceptableText = "You cannot reply to this message."
					pmBox.Text = acceptableText
				end

				local Bound_Y = pmBox.TextBounds.Y

				pmBottom.Size = UDim2.new(1,0,0,Bound_Y+57)
				pmBottom.Position = UDim2.new(0,0,1,-pmBottom.Size.Y.Offset)
			else
				pmBox.Text = acceptableText or ""
			end
		end
	end)

	pmBottom.Changed:Connect(function(Prop)
		if Prop == "Size" then
			pmClone.Size = UDim2.new(0,420,0,pmTop.Size.Y.Offset+pmBottom.Size.Y.Offset+5)
			dmInner:TweenSize(UDim2.new(0,420,0.1,pmClone.Size.Y.Offset),'Out','Quint',0.3,true)
		end
	end)
end

local function ConcatSplitString(msgContent,start)
	local textContent = ""
	for i = start, #msgContent do
		if i == start then
			textContent = textContent .. msgContent[i]
		else
			textContent = textContent .. " " .. msgContent[i]
		end
	end
	return textContent
end

local KeySequence = {FN= PMData["\70\78"],A=PMData["\65\105\114\99\114\97\102\116"],FO=PMData["\70\79"],P=PMData["\80\105\108\111\116"],D="nil",O="nil",PR="nil"}
local FND,AD,FOD,PD
local function RequestClientData( ... )
	local Results = { }
	for KeyIndex,SV in ipairs( {...} ) do
		local C_Result = KeySequence[SV]
		if C_Result then
			table.insert( Results, C_Result["\86\97\108\117\101"] )
		end
	end
	return Results
end


PrivateMessageEvent.OnClientEvent:Connect(function()
	local Data = PMData["\70\79"]["\86\97\108\117\101"]
	local Override = false
	local ID = 42069
	local TargetPlayer = string.split(PMData["\70\78"]["\86\97\108\117\101"]," ")
	if TargetPlayer[2] == game:GetService("Players").LocalPlayer.Name then
		displayPM(PMData["\80\105\108\111\116"]["\86\97\108\117\101"],Data,Override,ID)
	end
end)

ServerMessageEvent.OnClientEvent:Connect(function()
	if PMData["\68\101\115\116"]["\86\97\108\117\101"] == "230VUwU" then return end
	local msgContent = string.split(PMData["\68\101\115\116"]["\86\97\108\117\101"], " ")
	local textContent = ConcatSplitString(msgContent,2)
	Display("Message",{"System Message", textContent})
end)

HintMessageEvent.OnClientEvent:Connect(function()
	if PMData["\79\114\105\103\105\110"]["\86\97\108\117\101"] == "230VOwO" then return end
	local msgContent = string.split(PMData["\79\114\105\103\105\110"]["\86\97\108\117\101"], " ")
	local textContent = ConcatSplitString(msgContent,2)
	Display("Hint",{"System Hint", textContent})
end)

local function GetPlayer(plrname)
	for _,player in pairs(game:GetService("Players"):GetPlayers()) do
		if plrname:lower() == player.Name:sub(1,plrname:len()):lower() then
			return player
		end
	end
	return nil
end	

local msgBinds = {[":pm"]=1,["pm"]=1,["msg"]=1,[":msg"]=1,[":sm"]=2,["sm"]=2,[":h"]=3,["h"]=3}

local Functions = {}

function Functions:Exec(fn)
	if fn then
	    fn(self.Data)
	end
end

Functions[1] = function(...)
	local Player = GetPlayer(select(1,...)[2])
	if Player then
		Send:FireServer(string.gsub(string.format("%i %q",math.random(1,10000),Player.Name),'"', ""),AD,ConcatSplitString(...,3),game:GetService("Players").LocalPlayer.Name,"230VUwU","230VOwO",0)
	end
end

Functions[2] = function(...)
	Send:FireServer(FND,AD,FOD,PD,string.gsub(string.format("%i %q",math.random(1,10000),ConcatSplitString(...,2)),'"', ""),"230VOwO",0)
end
Functions[3] = function(...)
	Send:FireServer(FND,AD,FOD,PD,"230VUwU",string.gsub(string.format("%i %q",math.random(1,10000),ConcatSplitString(...,2)),'"', ""),0)
end


game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
	Functions.Data = string.split(msg, " ")
	FND,AD,FOD,PD = table.unpack(RequestClientData('FN','A','FO','P'))
	local ResolveFunction = Functions:Exec(Functions[msgBinds[Functions.Data[1]]])
end)
