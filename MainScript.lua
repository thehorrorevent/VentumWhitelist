if not _G.Ventum then
	_G.Ventum = true
	
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

	};

	--/ Helpful
	local Inst = {New = Instance.new}
	local CF = {New = CFrame.new, Angles = CFrame.Angles}
	local Vec = {New = Vector3.new}
	local C3 = {RGB = Color3.fromRGB}

	--/ Commands
	local VentumCommands = {
		-- Template: {Name = "", Description = "", Triggers = {''}, ArgType = 'none', ArgsNeeded = 'none'},
		{Name = "Rejoin", Description = "Rejoins your current JobId", Triggers = {'rejoin', 'rj'}, ArgType = 'none', ArgsNeeded = 'none'},
		{Name = "Fly", Description = "Makes you fly", Triggers = {'fly', 'bird'}, ArgType = 'none', ArgsNeeded = 'none'},
		{Name = "Walkspeed", Description = "Changes your Humanoid Walkspeed", Triggers = {'walkspeed', 'wspeed', 'ws', 'speed'}, ArgType = 'Number', ArgsNeeded = 'Speed Amount'},
		{Name = "Jump Power", Description = "Changes your Humanoid Jump Power", Triggers = {'jumppower', 'jpower', 'jp', 'jump'}, ArgType = 'Number', ArgsNeeded = 'Power Amount'},
		{Name = "Respawn", Description = "Resets your character and loads in the last position", Triggers = {'respawn', 'reset', 'refresh', 're'}, ArgType = 'none', ArgsNeeded = 'none'},
		{Name = "Time", Description = "Changes the in-game time", Triggers = {'time', 'tod', 'timeofday'}, ArgType = 'Number', ArgsNeeded = 'Time Of Day'},
	};

	--/ Globals
	local VentumPlayer = Services.Players.LocalPlayer
	local ChatRemote = Services.ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
	local Camera = workspace:WaitForChild("Camera")
	local VentumSettings = nil
	local VentumRegistry = nil

	--/ Booleans
	local Booleans = {
		Flying = false,
		CommandBarOpen = false,
	};

	--/ Values
	local Values = {
		Time = ""
	};
	
	--/ Settings
	local Settings = {
		CommandBarHotkey = Enum.KeyCode.BackSlash,
		ChatPrefix = ""
	};
	
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
	NotifText.TextScaled = true
	NotifText.TextSize = 14.000
	NotifText.TextWrapped = true
	
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
	
	--/ Main Script
	function ProcessCommand(message)
		local IsACommand = false
		local Prefix = Settings.ChatPrefix
		local Original = {message}

		if message:sub(1,string.len(Prefix)) == Prefix then
			IsACommand = true
		end

		if IsACommand  then
			for index, msg in pairs(Original) do
				if string.lower(msg:sub(1, string.len(Prefix))) == Prefix then
					msg = msg:sub(string.len(Prefix) + 1)
					message[index] = msg
				end
				
				for i = 1, string.len(msg) do
					if Prefix == string.lower(msg:sub(i, i + string.len(Prefix) - 1)) then
						table.insert(Original, msg:sub(1, i - 1))
						table.insert(Original, msg:sub(i + string.len(Prefix)))
						table.remove(Original, i)
					end
				end
			end
			
			for i = 1, #Original do
				local Args = {}
				for v in string.gmatch(Original[i], "%S+") do
					table.insert(Args, v)
				end
				
				if #Args > 0 then
					Args[1] = string.lower(Args[1])
					local FoundCommand = false
					
					for index, cmd in pairs(VentumCommands) do
						for i, trigger in pairs(cmd.Triggers) do
							if trigger == Args[1] then
								-- Figure out how to add command action here Tomorrow
							end
							FoundCommand = true
							break
						end
					end
					if FoundCommand then
						break
					end
				end
			end
		end
	end
	
	CommandBarBox.FocusLost:Connect(function()
		CommandBarFrame:TweenPosition(UDim2.new(1.2, 0, 0.5, 0), "Out", "Quad", 1, false)
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
end