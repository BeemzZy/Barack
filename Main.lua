local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")

if game.PlaceId ~= 6839171747 then
	StarterGui:SetCore("SendNotification", {
		Title = "System",
		Text = "Your not in the game.",
		Duration = 5,
	})
	return
end

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local CurrentRooms = workspace.CurrentRooms

local ExtraSensoryPerception = {}
local AutoFunctions = {}

local AutoHide = true

local MonsterList = {
	"RushMoving",
	"AmbushMoving",
	"Eyes",
	"Dread",
	"A60",
	"A120"
}

local ToESP = {
	["KeyObtain"] = true,
	["LeverForGate"] = true,
	["Super Cool Bookshelf With Hint Book"] = {
		["LiveHintBook"] = true
	},
	Specials = {
		["FigureRagdoll"] = true
	}
}

function Sound (soundid, volume, playbackspeed, looped)
	local Audio = Instance.new("Sound", SoundService)
	Audio.SoundId = "http://www.roblox.com/asset/?id="..soundid
	Audio.Volume = volume
	Audio.PlaybackSpeed = playbackspeed
	Audio.Looped = false
	Audio:Play()
	task.delay(Audio.TimeLength, function()
		repeat wait() until Audio.IsPlaying == false
		Audio:Remove()
	end)
end

function Notify (title:string, text:string, duration:number, icon:string, button1:string, button2:string, callback:BindableFunction, sound)
	StarterGui:SetCore("SendNotification", {
		Title = title or "No Title",
		Text = text or "No text",
		Duration = duration or 5,
		Icon = icon or nil,
		Button1 = button1 or nil,
		Button2 = button2 or nil,
		Callback = callback or nil
	})
	if sound then
		Sound(sound.SoundId, sound.Volume, sound.PlaybackSpeed, sound.Looped)
	end
end
do -- Notification GUI Changer
	local function Change (child:Instance)
		if child:IsA("Frame") then
			local ListWhoToAdd = {
				["Button1"] = {
					["UICorner"] = {
						["CornerRadius"] = UDim.new(0, 4)
					}
				},
				["Button2"] = {
					["UICorner"] = {
						["CornerRadius"] = UDim.new(0, 4)
					}
				}
			}
			
			Instance.new("UICorner", child).CornerRadius = UDim.new(0, 4)
			Instance.new("UIStroke", child).Thickness = 1
			child.UIStroke.Color = Color3.fromRGB(190, 190, 190)
			
			for i,v in pairs(child:GetChildren()) do
				for i2,v2 in pairs(ListWhoToAdd) do
					if v.Name == i2 then
						for i3,v3 in pairs(v2) do
							local NewInstance = Instance.new(i3, v)
							for i4,v4 in pairs(v3) do -- Properties Adder
								NewInstance[i4] = v4
							end
						end
					end
				end
			end
		end
	end
	
	local RobloxGui = game.CoreGui:FindFirstChild("RobloxGui")
	local NotificationFrame:Frame = RobloxGui.NotificationFrame
	
	NotificationFrame.ChildAdded:Connect(function(child)
		if child:IsA("Frame") and child.Name == "Notification" then
			Change(child)
		end
	end)
end

do -- Extra Sensory Perception (ESP) Functions
	local function Highlight (child, fillcolor, outlinecolor, depthmode, filltransparency, outlinetransparency)
		if child then
			if child:FindFirstChild("Highlight") then
				child:FindFirstChild("Highlight"):Destroy()
			end
			
			local highlight = Instance.new("Highlight")
			highlight.Parent = child
			highlight.Adornee = child
			highlight.DepthMode = depthmode or Enum.HighlightDepthMode.AlwaysOnTop
			highlight.FillColor = fillcolor or Color3.fromRGB(255, 255, 255)
			highlight.OutlineColor = outlinecolor or Color3.fromRGB(255, 255, 0)
			highlight.FillTransparency = filltransparency or 0.5
			highlight.OutlineTransparency = outlinetransparency or 0
			highlight.Parent = child

			task.delay(1, function()
				while true do wait()
					UpdateHighlight(highlight)
				end
			end)
		end
	end
	
	function UpdateHighlight (highlight:Instance)
		if highlight:IsA("Highlight") then
			local highlightorgparent = highlight.Adornee
			highlight.Adornee = nil
			wait()
			highlight.Adornee = highlightorgparent
		end
	end
	
	local function ESPRoom_Assets (Room)
		if Room:FindFirstChild("Assets") then
			for _,v in pairs(Room:FindFirstChild("Assets"):GetDescendants()) do
				for _2,v2 in pairs(ToESP) do
					if v.Name == _2 and v2 == true then
						Highlight(v)
					elseif v.Name == _2 and typeof(v2) == "table" then 
						for _3,v3 in pairs(v2) do
							if v:FindFirstChild(_3) then
								Highlight(v:FindFirstChild(_3))
							end
						end
					end
				end
			end
		end
	end
	
	local function ESPRoom_FigureSetup (Room)
		if Room:FindFirstChild("FigureSetup") then
			for _,v in pairs(Room:FindFirstChild("FigureSetup"):GetChildren()) do
				for _2,v2 in pairs(ToESP.Specials) do
					if v.Name == _2 and v2 == true then
						Highlight(v)
					elseif v.Name == _2 and typeof(v2) == "table" then 
						for _3,v3 in pairs(v2) do
							if v:FindFirstChild(_3) then
								Highlight(v:FindFirstChild(_3))
							end
						end
					end
				end
			end
		end
	end
	
	local function Fake_Door_Detector (Room)
		for i,v in pairs(Room:GetChildren()) do
			if v.Name == "Closet" and v:FindFirstChild("DoorFake") then
				Highlight(v:FindFirstChild("DoorFake"), Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 0, 0), Enum.HighlightDepthMode.Occluded)
			end
		end
		if Room:FindFirstChild("Door") then
			if Room:FindFirstChild("Door"):FindFirstChild("Lock") then
				Room:FindFirstChild("Door"):FindFirstChild("Lock").UnlockPrompt.HoldDuration = 0
			end
		end
		Highlight(Room:FindFirstChild("Door"), Color3.fromRGB(1, 1, 1), Color3.fromRGB(255, 255, 0), Enum.HighlightDepthMode.Occluded, 1, 0)
	end
	
	local function SetESP (Room)
		local SpecialRooms = {
			["50"] = function()
				ESPRoom_FigureSetup(Room)
			end,
		}

		for i,v in pairs(SpecialRooms) do
			if Room.Name == i then
				v()
			end
		end
		
		-- Fake Door Detector
		Fake_Door_Detector(Room)
		
		-- Common ESP
		ESPRoom_Assets(Room)
	end

	function ExtraSensoryPerception:Room(room)
		if CurrentRooms:FindFirstChild(room) then
			SetESP(CurrentRooms:FindFirstChild(room))
		else
			if CurrentRooms:WaitforChild(room) then
				SetESP(CurrentRooms:FindFirstChild(room))
			end
		end
	end
	
	CurrentRooms.ChildAdded:Connect(function(child)
		task.delay(0.5, function()
			for i,v in pairs(CurrentRooms:GetChildren()) do
				ExtraSensoryPerception:Room(v.Name)
			end
		end)
	end)
end

do -- Auto Functions
	AutoFunctions["Hide"] = function ()
		spawn(function()
			Notify(
				"AutoHide",
				"Coming Soon!",
				3
			)
		end)
	end
end

do -- Monsters Instance Detection
	workspace.ChildAdded:Connect(function(child)
		local MonsterModel = nil
		for i,v in pairs(MonsterList) do
			if child.Name == v then
				MonsterModel = child
				break
			end
		end
		if MonsterModel then
			if MonsterModel.Name == MonsterList[5] then
				Notify(
					"System ⚠️",
					"It's "..MonsterModel.Name.." : HIDE!",
					5, nil, nil, nil, nil, {
						SoundId = 3165700530,
						Volume = 10,
						PlaybackSpeed = 0.3,
						Looped = false
					}
				)
				AutoFunctions.Hide()
			elseif MonsterModel.Name == MonsterList[6] then
				Notify(
					"System ⚠️",
					"It's "..MonsterModel.Name.." : This one is Special HIDE!",
					5, nil, nil, nil, nil, {
						SoundId = 8727102087,
						Volume = 10,
						PlaybackSpeed = 0.5,
						Looped = false
					}
				)
				
				AutoFunctions.Hide()
			else
				coroutine.resume(coroutine.create(function()
					repeat wait(0.5)
						if child then
						else
							break
						end
						if MonsterModel:FindFirstChild("RushNew") then
							if MonsterModel:FindFirstChild("RushNew"):FindFirstChild("Footsteps") then
								if MonsterModel.RushNew.Footsteps.Playing == true then
									Notify(
										"System ⚠️",
										MonsterModel.Name,
										5, nil, nil, nil, nil, {
											SoundId = 3165700530,
											Volume = 2,
											PlaybackSpeed = 1,
											Looped = false
										}
									)
									AutoFunctions.Hide()
									break
								end
							end
						end
					until false
				end))
			end
		end
	end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if not gameProcessedEvent then
		if input.KeyCode == Enum.KeyCode.Backquote then
			AutoHide = not AutoHide
			Notify(
				"AutoHide",
				tostring(AutoHide),
				2
			)
		end
	end
end)

do -- ESP
	for i,v in pairs(CurrentRooms:GetChildren()) do
		ExtraSensoryPerception:Room(v.Name)
	end
end
