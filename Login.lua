--[[
To any skid looking to copy or modify, credit me. Literally its not that hard. Im not even a good scripter and ur skidding off me?
Looking like a whole clown to skid and copy off ME LOL

Anyways, Copyright @smokinsins, 11/5/2021
--]]


local _VERSION = 1
_G.LoadedVentum = false

if not _G.LoadedVentum then
	_G.LoadedVentum = true
	
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
		LoggedIn = false
	};
	
	--/ Values
	local Values = {
		Time = ""
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
	
	local CheckRegistry = pcall(function()
		VentumRegistry = pcall(function()
			readfile("VentumRegistry.lua")
		end)

		if VentumRegistry and VentumRegistry ~= nil then
			VentumRegistry = Services.HttpService:JSONDecode(readfile("VentumRegistry.lua"))
			for index, info in next, Registry do
				print(info)
				if VentumRegistry[index] ~= nil and info then
					print("Already Registered")
					Registry[index] = VentumRegistry[index]
				end
			end
			writefile("VentumRegistry.lua", Services.HttpService:JSONEncode(Registry))
		else
			writefile("VentumRegistry.lua", Services.HttpService:JSONEncode(Registry))
		end
	end)
	
	local function GetHWID()
		local http_request = http_request;
		if syn then
			http_request = syn.request
		elseif SENTINEL_V2 then
			function http_request(tb)
				return {
					StatusCode = 200;
					Body = request(tb.Url, tb.Method, (tb.Body or ''))
				}
			end
		end

		local body = http_request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body;
		local decoded = game:GetService('HttpService'):JSONDecode(body)
		local hwid_list = {"Syn-Fingerprint", "Exploit-Guid", "Proto-User-Identifier", "Sentinel-Fingerprint"};
		local hwid = "";

		for i, v in next, hwid_list do
			if decoded.headers[v] then
				hwid = decoded.headers[v];
				break
			end
		end

		if hwid then
			setclipboard(hwid)
			VentumPlayer:Kick("Copied HWID to Clipboard | Send to zer")
		else
			VentumPlayer:Kick("Cannot find / copy HWID | Exploit potentially unsupported!")
		end
	end
	
	local function DragUI(UI)
		local Dragging = false
		local DragInput = nil
		local DragStart = nil
		local StartPos = nil
		
		local function Update(input)
			local delta = input.Position - DragStart
			UI.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
		end
		
		UI.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = true
				DragStart = Input.Position
				StartPos = UI.Position
				
				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		
		UI.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				DragInput = Input
			end
		end)
		
		Services.UserInputService.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				Update(Input)
			end
		end)
	end
	
	
	--/ Create UI
	local VentumUI = Instance.new("ScreenGui")
	VentumUI.Name = "Ventum"
	syn.protect_gui(VentumUI)
	VentumUI.Parent = Services.CoreGui
	VentumUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	VentumUI.ResetOnSpawn = false
	
	local RegisterFrame = Inst.New("Frame", VentumUI)
	RegisterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	RegisterFrame.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
	RegisterFrame.BackgroundTransparency = 0.300
	RegisterFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	RegisterFrame.Size = UDim2.new(0.276692718, 0, 0.236802489, 0)
	DragUI(RegisterFrame)
	
	local RegisterFrameRatio = Inst.New("UIAspectRatioConstraint", RegisterFrame)
	RegisterFrameRatio.AspectRatio = 2.707
	
	local RegisterFrameCorner = Inst.New("UICorner", RegisterFrame)
	RegisterFrameCorner.CornerRadius = UDim.new(1, 0)
	RegisterFrameCorner.Parent = RegisterFrame
	
	local RegisterFrameStroke = Inst.New("UIStroke", RegisterFrame)
	RegisterFrameStroke.Color = C3.RGB(255, 65, 255)
	RegisterFrameStroke.Thickness = 1.5
	
	local StrokeGradient = Inst.New("UIGradient", RegisterFrameStroke)
	StrokeGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.145, 0),
		NumberSequenceKeypoint.new(0.375, 0.25),
		NumberSequenceKeypoint.new(1, 1),
	};
	
	local Title = Inst.New("TextLabel", RegisterFrame)
	Title.Name = "Title"
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.498280317, 0, 0.0719056651, 0)
	Title.Size = UDim2.new(0.39761433, 0, 0.146226391, 0)
	Title.Font = Enum.Font.Nunito
	Title.Text = "Ventum: Register"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextScaled = true
	Title.TextSize = 14.000
	Title.TextWrapped = true
	
	local TitleConstraint = Inst.New("UITextSizeConstraint", Title)
	TitleConstraint.MaxTextSize = 22
	
	local DetailsBox = Inst.New("TextBox", RegisterFrame)
	DetailsBox.Name = "DetailsBox"
	DetailsBox.Parent = RegisterFrame
	DetailsBox.AnchorPoint = Vector2.new(0.5, 0.5)
	DetailsBox.BackgroundColor3 = Color3.fromRGB(93, 93, 93)
	DetailsBox.Position = UDim2.new(0.496718287, 0, 0.340773553, 0)
	DetailsBox.Size = UDim2.new(0.485941529, 0, 0.278301895, 0)
	DetailsBox.Font = Enum.Font.Nunito
	DetailsBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
	DetailsBox.RichText = true
	DetailsBox.PlaceholderText = "Enter Key"
	DetailsBox.Text = ""
	DetailsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	DetailsBox.TextScaled = true
	DetailsBox.TextSize = 14.000
	DetailsBox.TextWrapped = true
	
	local DetailsBoxCorner = Inst.New("UICorner", DetailsBox)
	DetailsBoxCorner.Parent = DetailsBox
	
	local DetailsBoxConstraint = Inst.New("UITextSizeConstraint", DetailsBox)
	DetailsBoxConstraint.MaxTextSize = 39
	
	local CheckButton = Inst.New("TextButton", RegisterFrame)
	CheckButton.Name = "Check"
	CheckButton.Parent = RegisterFrame
	CheckButton.AnchorPoint = Vector2.new(0.5, 0.5)
	CheckButton.BackgroundColor3 = Color3.fromRGB(88, 88, 88)
	CheckButton.Position = UDim2.new(0.498280346, 0, 0.845490456, 0)
	CheckButton.Size = UDim2.new(0.39761433, 0, 0.165094316, 0)
	CheckButton.Font = Enum.Font.SourceSansSemibold
	CheckButton.Text = "Check"
	CheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CheckButton.TextScaled = true
	CheckButton.TextSize = 14.000
	CheckButton.TextWrapped = true
	
	local RegisterButtonCorner = Inst.New("UICorner", CheckButton)
	RegisterButtonCorner.CornerRadius = UDim.new(1, 0)
	
	local RegisterButtonConstraint = Inst.New("UITextSizeConstraint", CheckButton)
	RegisterButtonConstraint.MaxTextSize = 25
	
	local StatusText = Inst.New("TextLabel", RegisterFrame)
	StatusText.Name = "Status"
	StatusText.Parent = RegisterFrame
	StatusText.AnchorPoint = Vector2.new(0.5, 0.5)
	StatusText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	StatusText.BackgroundTransparency = 1.000
	StatusText.Position = UDim2.new(0.5002684, 0, 0.607282937, 0)
	StatusText.Size = UDim2.new(0.39761433, 0, 0.160377339, 0)
	StatusText.Font = Enum.Font.RobotoMono
	StatusText.RichText = true
	StatusText.Text = "Not Ready"
	StatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
	StatusText.TextScaled = true
	StatusText.TextSize = 14.000
	StatusText.TextWrapped = true
	
	local StatusConstraint = Inst.New("UITextSizeConstraint", StatusText)
	StatusConstraint.MaxTextSize = 25
	
	CheckButton.MouseButton1Down:Connect(function()
		--if DetailsBox.Text ~= '' then
			local Text = DetailsBox.Text
            print(Text)
            local UserID = Services.Players.LocalPlayer.UserId
			local URL = "https://bothosterforgame.000webhostapp.com/index.php?key=".. Text .."&user=" .. UserID
			
			if game:HttpGet(URL) == "Allowed" then
				StatusText.Text = "Ready"
				Services.TweenService:Create(StatusText, TweenInfo.new(0.5), {TextColor3 = C3.RGB(0, 230, 0)}):Play()
				for _, v in pairs(RegisterFrame:GetChildren()) do
					if v:IsA("Frame") then
						local T = Services.TweenService:Create(v, TweenInfo.new(1), {BackgroundTransparency = 1})
						T:Play()
					elseif v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
						local T = Services.TweenService:Create(v, TweenInfo.new(1), {BackgroundTransparency = 1, TextTransparency = 1})
						T:Play()
						T.Completed:Wait()
						local T2 = Services.TweenService:Create(RegisterFrame, TweenInfo.new(1), {BackgroundTransparency = 1})
						T2:Play()
						T2.Completed:Wait()
						RegisterFrame:Destroy()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/smokingsin/VentumWhitelist/main/MainScript.lua", true))()
					end
				end
			elseif game:HttpGet(URL) ~= "Allowed" then
                print("Failed")
				--GetHWID()
			end
		--end
	end)
end