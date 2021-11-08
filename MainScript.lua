if not _G.Ventum then
	_G.Ventum = true
	
	function Search(Where, What, Type)
		if Where ~= nil and What ~= nil then
			if Type == 'Find' then
				local T = Where:FindFirstChildOfClass(What)
				if not T then
					T = Where:FindFirstChild(What)
				end
				if T then
					return T
				end
			elseif Type == 'Wait' then
				local T = Where:WaitForChild(What)
				if T then
					return T
				end
			end
		end
	end
	
	--/ Services
	local Services = {
		Players = game:GetService("Players"),
		ReplicatedStorage = game:GetService("ReplicatedStorage"),
		Lighting = game:GetService("Lighting"),
		Chat = game:GetService("Chat"),
		CoreGui = game:GetService("CoreGui"),
		StarterGui = game:GetService("StarterGui"),
		VirtualUser = game:GetService("VirtualUser"),
		UserInputService = game:GetService("UserInputService"),
		MarketplaceService = game:GetService("MarketplaceService"),
		HttpService = game:GetService("HttpService"),
		RunService = game:GetService("RunService"),
		TeleportService = game:GetService("TeleportService"),
		TweenService = game:GetService("TweenService")
	};

	--/ Register Details
	local Registry = {
		HWID = "",
		Registered = false

	};

	--/ Settings
	local Settings = {
		Time = 12
	};

	--/ Helpful
	local Inst = {New = Instance.new}
	local CF = {New = CFrame.new, Angles = CFrame.Angles}
	local Vec = {New = Vector3.new}
	local C3 = {RGB = Color3.fromRGB}

	--/ Globals
	local VentumPlayer = Services.Players.LocalPlayer
	local ChatRemote = Services.ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
	local Camera = workspace:WaitForChild("Camera")
	local VentumSettings = nil
	local VentumRegistry = nil
	
	--/ Client-Bridge
	local ClientBridge = {
		["2437074178"] = {
			Rank = 4,
			ESP_Title = 'Creator | Main',
			ESP_Color = C3.RGB(17,0,51)
		},
		["88401057"] = {
			Rank = 3,
			ESP_Title = 'Dae | Wifey',
			ESP_Color = C3.RGB(244, 194, 194)
		},
	};
	
	--/ Booleans
	local Booleans = {
		Flying = false,
		CommandBarOpen = false,
	};
	
	--/ Settings
	local Settings = {
		CommandBarHotkey = Enum.KeyCode.BackSlash,
		ChatPrefix = ""
	};
	
	--/ Connections
	local Connections = {
		Noclip = nil
	}
	
	--/ Local Functions
	local CheckSettings = pcall(function()
		VentumSettings = pcall(function()
			readfile("VentumSettings.lua")
		end)

		if VentumSettings and VentumSettings ~= nil then
			VentumSettings = Services.HttpService:JSONDecode(readfile("VentumSettings.lua"))
			for index, setting in next, Settings do
				if VentumSettings[index] ~= nil then
					Settings[index] = VentumSettings[index]
				end
			end
			writefile("VentumSettings.lua", Services.HttpService:JSONEncode(Settings))
		else
			writefile("VentumSettings.lua", Services.HttpService:JSONEncode(Settings))
		end
	end)
	
	--/ Create UI Elements
	local Ventum = Inst.New("ScreenGui")
	Ventum.Name = "Ventum"
	syn.protect_gui(Ventum)
	Ventum.Parent = Services.CoreGui
	
	local NotifyFrame = Inst.New("Frame", Ventum)
	NotifyFrame.Name = "Notify"
	NotifyFrame.Parent = Ventum
	NotifyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	NotifyFrame.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
	NotifyFrame.BackgroundTransparency = 0.200
	NotifyFrame.Position = UDim2.new(-0.2, 0, 0.909134269, 0)
	NotifyFrame.Size = UDim2.new(0.195963547, 0, 0.152337864, 0)
	
	local NotifyFrameCorner = Inst.New("UICorner", NotifyFrame)
	NotifyFrameCorner.CornerRadius = UDim.new(1, 0)
	
	local NotifyFrameStroke = Inst.New("UIStroke", NotifyFrame)
	NotifyFrameStroke.Color = C3.RGB(255, 218, 105)
	NotifyFrameStroke.Thickness = 1.5
	
	local NotifyStrokeGradient = Inst.New("UIGradient", NotifyFrameStroke)
	NotifyStrokeGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0)
	};
	
	local NotifyFrameRatio = Inst.New("UIAspectRatioConstraint", NotifyFrame)
	NotifyFrameRatio.AspectRatio = 2.980
	
	local Title = Inst.New("TextLabel", NotifyFrame)
	Title.Name = "Title"
	Title.Active = true
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.536544859, 0, 0.129999995, 0)
	Title.Size = UDim2.new(0.664451838, 0, 0.2772277, 0)
	Title.Font = Enum.Font.SourceSansSemibold
	Title.Text = "Notification"
	Title.TextColor3 = Color3.fromRGB(255, 218, 105)
	Title.TextScaled = true
	Title.TextSize = 14.000
	Title.TextWrapped = true
	
	local TitleSizeConstraint = Inst.New("UITextSizeConstraint", Title)
	TitleSizeConstraint.MaxTextSize = 28
	
	local NotifText = Inst.New("TextLabel", NotifyFrame)
	NotifText.Name = "NotifText"
	NotifText.AnchorPoint = Vector2.new(0.5, 0.5)
	NotifText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NotifText.BackgroundTransparency = 1.000
	NotifText.Position = UDim2.new(0.536694407, 0, 0.592198074, 0) -- (0.07, 0, 0.9, 0) Open Position
	NotifText.Size = UDim2.new(0.664451838, 0, 0.663366258, 0)
	NotifText.Font = Enum.Font.Nunito
	NotifText.Text = ""
	NotifText.TextColor3 = Color3.fromRGB(255, 218, 105)
	NotifText.TextScaled = false
	NotifText.TextSize = 20.000
	NotifText.TextWrapped = true
	
	local NotifTextConstraint = Inst.New("UITextSizeConstraint", NotifText)
	NotifTextConstraint.MaxTextSize = 20
	
	local CommandBarFrame = Inst.New("Frame", Ventum)
	CommandBarFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	CommandBarFrame.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
	CommandBarFrame.BackgroundTransparency = 0.200
	CommandBarFrame.Position = UDim2.new(1.2, 0, 0.5, 0) -- (0.93, 0, 0.5, 0) Open Position
	CommandBarFrame.Size = UDim2.new(0.15625, 0, 0.0452488735, 0)
	
	local CommandBarFrameRatio = Inst.New("UIAspectRatioConstraint", CommandBarFrame)
	CommandBarFrameRatio.AspectRatio = 8
	CommandBarFrameRatio.AspectType = Enum.AspectType.FitWithinMaxSize
	CommandBarFrameRatio.DominantAxis = Enum.DominantAxis.Width
	
	local CommandBarCorner = Inst.New("UICorner", CommandBarFrame)
	CommandBarCorner.CornerRadius = UDim.new(1, 0)
	
	local CommandBarStroke = Inst.New("UIStroke", NotifyFrame)
	CommandBarStroke.Color = C3.RGB(255, 218, 105)
	CommandBarStroke.Thickness = 1.5

	local CommandStrokeGradient = Inst.New("UIGradient", CommandBarStroke)
	CommandStrokeGradient.Rotation = 180
	CommandStrokeGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0)
	};
	
	local CommandBarBox = Inst.New("TextBox", CommandBarFrame)
	CommandBarBox.AnchorPoint = Vector2.new(0.5, 0.5)
	CommandBarBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CommandBarBox.BackgroundTransparency = 1.000
	CommandBarBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	CommandBarBox.Size = UDim2.new(1, 0, 1, 0)
	CommandBarBox.Font = Enum.Font.Jura
	CommandBarBox.PlaceholderColor3 = Color3.fromRGB(255, 218, 105)
	CommandBarBox.Text = ""
	CommandBarBox.TextColor3 = Color3.fromRGB(255, 218, 105)
	CommandBarBox.TextScaled = true
	CommandBarBox.TextSize = 30.000
	CommandBarBox.TextWrapped = true
	
	CommandBarBoxConstraint = Inst.New("UITextSizeConstraint", CommandBarBox)
	CommandBarBoxConstraint.MaxTextSize = 30
	
	--/ Command Functions
	function Notify(Text, Duration)
		local MoveIn = Services.TweenService:Create(NotifyFrame, TweenInfo.new(1), {Position = UDim2.new(0.07, 0, 0.9, 0)})
		NotifText.Text = Text
		MoveIn:Play()
		MoveIn.Completed:Wait()
		wait(Duration)
		local MoveBack = Services.TweenService:Create(NotifyFrame, TweenInfo.new(1), {Position = UDim2.new(-0.5, 0, 0.9, 0)})
		MoveBack:Play()
		MoveBack.Completed:Wait()
	end
	
	function Rejoin()
		coroutine.wrap(function()
			writefile("VentumSettings.lua", Services.HttpService:JSONEncode(Settings))
			Notify('Rejoining..', 3)
		end)
		Notify("Rejoining..", 3)
		Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
	end
	
	function WalkSpeed(Speed)
		local Hum = VentumPlayer.Character:WaitForChild("Humanoid")
		Hum.WalkSpeed = Speed
	end
	
	function JumpPower(Power)
		local Hum = VentumPlayer.Character:WaitForChild("Humanoid")
		Hum.JumpPower = Power
	end
	
	local function ClientBridgeCheck(Player)
		if ClientBridge[tostring(Player.UserId)] then
			print(Player.UserId .. ' is on client bridge')
			return ClientBridge[tostring(Player.UserId)]
		end
	end
	
	function CreateESP(ESP_Parent, ESP_Text, ESP_Color, ESP_Offset, ESP_TextSize, ESP_Font)
		local ESP = Search(ESP_Parent, 'BillboardGui', 'Find')
		local ESP_Label = Search(ESP_Parent, ESP, 'Find')
		
		if ESP == nil and ESP_Label == nil then
			ESP = Inst.New("BillboardGui", ESP_Parent)
			ESP.AlwaysOnTop = true
			ESP.Enabled = true
			ESP.MaxDistance = math.huge
			ESP.Size = UDim2.new(1, 0, 1, 0)
			ESP.ExtentsOffset = ESP_Offset
			
			ESP_Label = Inst.New("TextLabel", ESP)
			ESP_Label.Text = ESP_Text
			ESP_Label.BackgroundTransparency = 1
			ESP_Label.Position = UDim2.new(0, 0, -0.9, 0)
			ESP_Label.Size = UDim2.new(1, 0, 1, 0)
			ESP_Label.TextSize = ESP_TextSize
			ESP_Label.Font = ESP_Font
			ESP_Label.TextColor3 = ESP_Color
			ESP_Label.TextScaled = false
			ESP_Label.TextStrokeTransparency = 1
		end
		ESP.TextLabel.TextSize = ESP_TextSize
		ESP.ExtentsOffset = ESP_Offset
		ESP.TextLabel.Text = ESP_Text
		ESP.TextLabel.Font = ESP_Font
		ESP.TextLabel.TextColor3 = ESP_Color
		return ESP
	end
	
	--/ Commands
	local VentumCommands = {
		-- Template: {Name = "", Description = "", Triggers = {''}, ArgType = 'none', ArgsNeeded = 'none', Function = function(Caller, Args) end},
		{Name = "Rejoin", Description = "Rejoins your current JobId", Triggers = {'rejoin', 'rj'}, ArgType = 'none', ArgsNeeded = 'none', 
			Function = function(Caller, Args) 
				Rejoin()
			end},
		{Name = "Noclip", Description = "Lets you walk through stuff", Triggers = {'noclip', 'nclip'}, ArgType = 'none', ArgsNeeded = 'none', 
			Function = function(Caller, Args)
				Connections.Noclip = game.Loaded.Connect(Services.RunService.Stepped, function()
					for index, part in next, VentumPlayer.Character:GetChildren() do
						if part:IsA("BasePart") and part.CanCollide then
							part.CanCollide = false
						end
					end	
				end)
			end},
		{Name = "Clip", Description = "Prevents you from walking through stuff", Triggers = {'clip', 'unnoclip'}, ArgType = 'none', ArgsNeeded = 'none', 
			Function = function(Caller, Args)
				Connections.Noclip:Disconnect()
			end},
		{Name = "Fly", Description = "Makes you fly", Triggers = {'fly', 'bird'}, ArgType = 'none', ArgsNeeded = 'none',
			Function = function(Caller, Args)
				Notify('Fly Coming Soon..', 3)
			end},
		{Name = "WalkSpeed", Description = "Changes your Humanoid Walkspeed", Triggers = {'walkspeed', 'wspeed', 'ws', 'speed'}, ArgType = 'Number', ArgsNeeded = 'Speed Amount',
			Function = function(Caller, Args)
				local Speed = Args[2]
				print(Speed)
				WalkSpeed(Speed)
			end},
		{Name = "JumpPower", Description = "Changes your Humanoid Jump Power", Triggers = {'jumppower', 'jpower', 'jp', 'jump'}, ArgType = 'Number', ArgsNeeded = 'Power Amount',
			Function = function(Caller, Args)
				local Amount = Args[2]
				JumpPower(Amount)
			end},
		{Name = "Respawn", Description = "Resets your character and loads in the last position", Triggers = {'respawn', 'reset', 'refresh', 're'}, ArgType = 'none', ArgsNeeded = 'none',
			Function = function(Caller, Args)
				local OldPosition = VentumPlayer.Character.HumanoidRootPart.CFrame
				VentumPlayer.Character:BreakJoints()
				game.Loaded.Wait(VentumPlayer.CharacterAdded)
				VentumPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = OldPosition
				Notify('Refreshed Character', 2)
			end},
		{Name = "Time", Description = "Changes the in-game time", 
			Triggers = {'time', 'tod', 'timeofday'}, ArgType = 'Number', ArgsNeeded = 'Time Of Day',
			Function = function(Caller, Args)
				local Time = Args[2]
				
				if tonumber(Time) > 24 then
					Notify('Invalid Time Of Day | Choose a number under 24', 2)
				else
					Services.Lighting.TimeOfDay = tonumber(Time)
					Settings.Time = tonumber(Time)
				end
			end},
	};
	
	--/ Main Script
	function ProcessCommand(plr, message)
		local IsACommand = false
		local Prefix = Settings.ChatPrefix
		local Original = {message}
		
		for i = 1, #Original do
			local Args = {};
			for str in string.gmatch(Original[i], "%S+") do
				table.insert(Args, str)
			end
			
			if #Args > 0 then
				Args[1] = string.lower(Args[1])
				local Found = false
				
				for index, cmd in pairs(VentumCommands) do
					for index2, trigger in pairs(cmd.Triggers) do
						if trigger:lower() == Args[1]:lower() then
							cmd.Function(plr, Args)
						end
						Found = true
						break
					end
				end
				if Found then
					break
				else
					Notify('Invalid command | Please try again!', 2)
				end
			end
		end
	end
	
	CommandBarBox.FocusLost:Connect(function(Enter)
		CommandBarFrame:TweenPosition(UDim2.new(1.2, 0, 0.5, 0), "Out", "Quad", 1, false)
		if Enter then
			local Text
			if CommandBarBox.Text ~= '' then
				Text = CommandBarBox.Text
				ProcessCommand(VentumPlayer, Text)
			end	
		end
	end)
	
	Services.UserInputService.InputBegan:Connect(function(Button, Processed)
		if not Processed then
			if Button.KeyCode == Enum.KeyCode.BackSlash then
				CommandBarFrame.Size = UDim2.new(0.15625, 0, 0.0452488735, 0)
				CommandBarFrame:TweenPosition(UDim2.new(0.93, 0, 0.5, 0), "Out", "Quad", 1, false)
				CommandBarBox:CaptureFocus()
				Services.RunService.RenderStepped:Wait()
				CommandBarBox.Text = ""
			end
		end
	end)
	
	--coroutine.wrap(function()
		Notify('Checking Users..', 2)
		for index, plr in next, Services.Players:GetPlayers() do
			if plr ~= Services.Players then
				if ClientBridgeCheck(plr) ~= nil and plr.Character ~= nil then
					local Head = Search(plr.Character, 'Head', 'Find')
					if Head and Head ~= nil then
					CreateESP(Head, ClientBridgeCheck(plr).ESP_Title, ClientBridgeCheck(plr).ESP_Color, Vec.New(0, 1, 0), 20, Enum.Font.Jura)
					end					
					plr.CharacterAdded:Connect(function(Char)
						local Head2 = Search(plr.Character, 'Head', 'Wait')
						if Head2 and Head2 ~= nil then
						CreateESP(Head2, ClientBridgeCheck(plr).ESP_Title, ClientBridgeCheck(plr).ESP_Color, Vec.New(0, 1, 0), 20, Enum.Font.Jura)
						end
					end)
				end
			end
		end
		Notify('Checked Users!', 2)
	--end)
	
	Services.Players.PlayerAdded:Connect(function(plr)
		plr.CharacterAdded:Connect(function(char)
			local Head = char:WaitForChild('Head')
			if ClientBridgeCheck(plr) ~= nil then
				CreateESP(Head, ClientBridgeCheck(plr).ESP_Title, ClientBridgeCheck(plr).ESP_Color, Vec.New(0, 1, 0), 20, Enum.Font.Jura)
			end
			
			if plr.Character ~= nil and ClientBridgeCheck(plr) ~= nil then
				local Head2 = plr.Character:FindFirstChild('Head')
				if Head2 then
					CreateESP(plr.Character:WaitForChild('Head'), ClientBridgeCheck(plr).ESP_Title, ClientBridgeCheck(plr).ESP_Color, Vec.New(0, 1, 0), 20, Enum.Font.Jura)
				end
			end
		end)
	end)
end