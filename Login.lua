--[[
To any skid looking to copy or modify, credit me. Literally its not that hard. Im not even a good scripter and ur skidding off me?
Looking like a whole clown to skid and copy off ME LOL

Anyways, Copyright @smokinsins, 11/5/2021
--]]


local _VERSION = 1
_G.LoadedVentum = false

if not _G.LoadedVentum then
	_G.LoadedVentum = true

	

	--/ Local Functions
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
			game.Players.LocalPlayer:Kick("Copied HWID to Clipboard | Send to zer")
		else
			game.Players.LocalPlayer:Kick("Cannot find / copy HWID | Exploit potentially unsupported!")
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

		game:GetService("UserInputService").InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				Update(Input)
			end
		end)
	end


	--/ Create UI
	local VentumUI = Instance.new("ScreenGui")
	VentumUI.Name = "Ventum"
	syn.protect_gui(VentumUI)
	VentumUI.Parent = game:GetService("CoreGui")
	VentumUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	VentumUI.ResetOnSpawn = false

	local RegisterFrame = Instance.new("Frame", VentumUI)
	RegisterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	RegisterFrame.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
	RegisterFrame.BackgroundTransparency = 0.300
	RegisterFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	RegisterFrame.Size = UDim2.new(0.276692718, 0, 0.236802489, 0)
	DragUI(RegisterFrame)

	local RegisterFrameRatio = Instance.new("UIAspectRatioConstraint", RegisterFrame)
	RegisterFrameRatio.AspectRatio = 2.707

	local RegisterFrameCorner = Instance.new("UICorner", RegisterFrame)
	RegisterFrameCorner.CornerRadius = UDim.new(1, 0)
	RegisterFrameCorner.Parent = RegisterFrame

	local RegisterFrameStroke = Instance.new("UIStroke", RegisterFrame)
	RegisterFrameStroke.Color = Color3.fromRGB(255, 218, 105)
	RegisterFrameStroke.Thickness = 1.5

	local StrokeGradient = Instance.new("UIGradient", RegisterFrameStroke)
	StrokeGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	};

	local Title = Instance.new("TextLabel", RegisterFrame)
	Title.Name = "Title"
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.498280317, 0, 0.0719056651, 0)
	Title.Size = UDim2.new(0.39761433, 0, 0.146226391, 0)
	Title.Font = Enum.Font.Nunito
	Title.Text = "Ventum: Register"
	Title.TextColor3 = Color3.fromRGB(255, 218, 105)
	Title.TextScaled = true
	Title.TextSize = 14.000
	Title.TextWrapped = true

	local TitleConstraint = Instance.new("UITextSizeConstraint", Title)
	TitleConstraint.MaxTextSize = 22

	local DetailsBox = Instance.new("TextBox", RegisterFrame)
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

	local DetailsBoxCorner = Instance.new("UICorner", DetailsBox)
	DetailsBoxCorner.Parent = DetailsBox

	local DetailsBoxConstraint = Instance.new("UITextSizeConstraint", DetailsBox)
	DetailsBoxConstraint.MaxTextSize = 39

	local CheckButton = Instance.new("TextButton", RegisterFrame)
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

	local RegisterButtonCorner = Instance.new("UICorner", CheckButton)
	RegisterButtonCorner.CornerRadius = UDim.new(1, 0)

	local RegisterButtonConstraint = Instance.new("UITextSizeConstraint", CheckButton)
	RegisterButtonConstraint.MaxTextSize = 25

	local StatusText = Instance.new("TextLabel", RegisterFrame)
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

	local StatusConstraint = Instance.new("UITextSizeConstraint", StatusText)
	StatusConstraint.MaxTextSize = 25

	CheckButton.MouseButton1Down:Connect(function()
		if DetailsBox.Text ~= '' then
			local Text = DetailsBox.Text
			local UserID = game:GetService("Players").LocalPlayer.UserId
			local URL = "https://bothosterforgame.000webhostapp.com/index.php?key=".. Text .."&user=" .. UserID

			if game:HttpGet(URL) == "Allowed" then
				StatusText.Text = "Ready"
				game:GetService("TweenService"):Create(StatusText, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(0, 230, 0)}):Play()
				for _, v in pairs(RegisterFrame:GetChildren()) do
					if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
                        local T = game:GetService("TweenService"):Create(v, TweenInfo.new(1), {BackgroundTransparency = 1, TextTransparency = 1})
						T:Play()
						T.Completed:Wait()
					elseif v:IsA("Frame") then
						local T = game:GetService("TweenService"):Create(v, TweenInfo.new(1), {BackgroundTransparency = 1})
						T:Play()
                        T.Completed:Wait()
					end
				end
				wait(1.01)
                local T2 = game:GetService("TweenService"):Create(RegisterFrame, TweenInfo.new(1), {BackgroundTransparency = 1})
				T2:Play()
				T2.Completed:Wait()
                RegisterFrame:Destroy()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/smokingsin/VentumWhitelist/main/MainScript.lua", true))()
			elseif game:HttpGet(URL) ~= "Allowed" then
				GetHWID()
			end
		end
	end)
end