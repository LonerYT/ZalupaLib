local Library = {}
Library.__index = Library

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Themes = {
	Dark = {
		Background = Color3.fromRGB(12, 12, 14),
		Secondary = Color3.fromRGB(18, 18, 20),
		Tertiary = Color3.fromRGB(25, 25, 28),
		Text = Color3.fromRGB(255, 255, 255),
		TextDark = Color3.fromRGB(150, 150, 155),
		Accent = Color3.fromRGB(255, 255, 255),
		Stroke = Color3.fromRGB(45, 45, 50)
	},
	Light = {
		Background = Color3.fromRGB(240, 240, 245),
		Secondary = Color3.fromRGB(255, 255, 255),
		Tertiary = Color3.fromRGB(230, 230, 235),
		Text = Color3.fromRGB(20, 20, 25),
		TextDark = Color3.fromRGB(100, 100, 105),
		Accent = Color3.fromRGB(50, 50, 55),
		Stroke = Color3.fromRGB(200, 200, 205)
	},
	Purple = {
		Background = Color3.fromRGB(15, 12, 20),
		Secondary = Color3.fromRGB(22, 18, 30),
		Tertiary = Color3.fromRGB(30, 25, 40),
		Text = Color3.fromRGB(255, 255, 255),
		TextDark = Color3.fromRGB(150, 140, 170),
		Accent = Color3.fromRGB(150, 100, 255),
		Stroke = Color3.fromRGB(60, 50, 80)
	},
	Red = {
		Background = Color3.fromRGB(18, 12, 12),
		Secondary = Color3.fromRGB(25, 18, 18),
		Tertiary = Color3.fromRGB(35, 25, 25),
		Text = Color3.fromRGB(255, 255, 255),
		TextDark = Color3.fromRGB(170, 140, 140),
		Accent = Color3.fromRGB(255, 80, 80),
		Stroke = Color3.fromRGB(80, 50, 50)
	},
	Blue = {
		Background = Color3.fromRGB(10, 12, 18),
		Secondary = Color3.fromRGB(15, 20, 28),
		Tertiary = Color3.fromRGB(22, 28, 38),
		Text = Color3.fromRGB(255, 255, 255),
		TextDark = Color3.fromRGB(130, 150, 180),
		Accent = Color3.fromRGB(80, 150, 255),
		Stroke = Color3.fromRGB(40, 55, 80)
	}
}

local function Create(class, properties)
	local instance = Instance.new(class)
	for prop, value in pairs(properties) do
		if prop ~= "Parent" then
			instance[prop] = value
		end
	end
	if properties.Parent then
		instance.Parent = properties.Parent
	end
	return instance
end

local function Tween(instance, duration, properties, style, direction)
	local tween = TweenService:Create(
		instance,
		TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
		properties
	)
	tween:Play()
	return tween
end

local function Ripple(button, x, y)
	local ripple = Create("Frame", {
		Name = "Ripple",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.7,
		Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
		Size = UDim2.new(0, 0, 0, 0),
		Parent = button
	})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ripple})

	local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
	Tween(ripple, 0.5, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1})
	task.delay(0.5, function()
		ripple:Destroy()
	end)
end

function Library:CreateWindow(config)
	config = config or {}
	local title = config.Title or "Zalupa Scripts"
	local subtitle = config.Subtitle or ""
	local themeName = config.Theme or "Dark"
	local accentColor = config.AccentColor

	local Theme = Themes[themeName] or Themes.Dark
	if accentColor then
		Theme.Accent = accentColor
	end

	local Window = {}
	Window.Tabs = {}
	Window.CurrentTab = nil
	Window.Theme = Theme
	Window.Minimized = false

	if CoreGui:FindFirstChild("ZalupaUI") then
		CoreGui:FindFirstChild("ZalupaUI"):Destroy()
	end

	local ScreenGui = Create("ScreenGui", {
		Name = "ZalupaUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = CoreGui
	})

	Window.ScreenGui = ScreenGui

	local NotifContainer = Create("Frame", {
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -20, 1, -20),
		Size = UDim2.new(0, 300, 1, -40),
		Parent = ScreenGui
	})

	Create("UIListLayout", {
		Padding = UDim.new(0, 10),
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = NotifContainer
	})

	local Shadow = Create("ImageLabel", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 600, 0, 430),
		Image = "rbxassetid://5554236805",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23, 23, 277, 277),
		Parent = ScreenGui
	})

	local Main = Create("Frame", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Theme.Background,
		ClipsDescendants = true,
		Parent = ScreenGui
	})

	Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = Main})

	local MainStroke = Create("UIStroke", {
		Color = Theme.Accent,
		Thickness = 1.5,
		Transparency = 0.8,
		Parent = Main
	})

	local GradientFrame = Create("Frame", {
		Name = "Gradient",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Theme.Background,
		Parent = Main
	})

	Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = GradientFrame})

	local BGGradient = Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.Secondary),
			ColorSequenceKeypoint.new(0.5, Theme.Background),
			ColorSequenceKeypoint.new(1, Theme.Secondary)
		}),
		Rotation = 45,
		Parent = GradientFrame
	})

	task.spawn(function()
		local rotation = 0
		while ScreenGui.Parent do
			rotation = (rotation + 0.5) % 360
			BGGradient.Rotation = rotation
			task.wait(0.05)
		end
	end)

	task.spawn(function()
		while ScreenGui.Parent do
			Tween(MainStroke, 2, {Transparency = 0.6}, Enum.EasingStyle.Sine)
			task.wait(2)
			Tween(MainStroke, 2, {Transparency = 0.9}, Enum.EasingStyle.Sine)
			task.wait(2)
		end
	end)

	local ParticlesFrame = Create("Frame", {
		Name = "Particles",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = Main
	})

	Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = ParticlesFrame})

	task.spawn(function()
		while ScreenGui.Parent do
			local particle = Create("Frame", {
				Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4)),
				Position = UDim2.new(math.random(), 0, 1.1, 0),
				BackgroundColor3 = Theme.Accent,
				BackgroundTransparency = math.random(70, 90) / 100,
				Parent = ParticlesFrame
			})
			Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = particle})

			local duration = math.random(3, 6)
			Tween(particle, duration, {
				Position = UDim2.new(math.random(), 0, -0.1, 0),
				BackgroundTransparency = 1
			}, Enum.EasingStyle.Linear)

			task.delay(duration, function()
				particle:Destroy()
			end)

			task.wait(math.random(2, 5) / 10)
		end
	end)

	local TitleBar = Create("Frame", {
		Name = "TitleBar",
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = Theme.Secondary,
		ClipsDescendants = true,
		Parent = Main
	})

	Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = TitleBar})

	Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.Tertiary),
			ColorSequenceKeypoint.new(0.5, Theme.Secondary),
			ColorSequenceKeypoint.new(1, Theme.Background)
		}),
		Rotation = 90,
		Parent = TitleBar
	})

	local TitleText = Create("TextLabel", {
		Size = UDim2.new(0, 300, 0, 25),
		Position = UDim2.new(0, 16, 0, 8),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 18,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TitleBar
	})

	local TitleShimmer = Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.Text),
			ColorSequenceKeypoint.new(0.4, Theme.TextDark),
			ColorSequenceKeypoint.new(0.5, Theme.Accent),
			ColorSequenceKeypoint.new(0.6, Theme.TextDark),
			ColorSequenceKeypoint.new(1, Theme.Text)
		}),
		Parent = TitleText
	})

	task.spawn(function()
		while ScreenGui.Parent do
			TitleShimmer.Offset = Vector2.new(-1, 0)
			Tween(TitleShimmer, 2, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear)
			task.wait(2)
		end
	end)

	if subtitle ~= "" then
		Create("TextLabel", {
			Size = UDim2.new(0, 200, 0, 15),
			Position = UDim2.new(0, 16, 0, 30),
			BackgroundTransparency = 1,
			Text = subtitle,
			TextColor3 = Theme.TextDark,
			TextSize = 11,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = TitleBar
		})
	end

	local MinBtn = Create("TextButton", {
		Name = "Minimize",
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(1, -50, 0.5, -7),
		BackgroundColor3 = Color3.fromRGB(255, 189, 46),
		Text = "",
		AutoButtonColor = false,
		Parent = TitleBar
	})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = MinBtn})

	local MinIcon = Create("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "−",
		TextColor3 = Color3.fromRGB(120, 80, 0),
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextTransparency = 1,
		Parent = MinBtn
	})

	local CloseBtn = Create("TextButton", {
		Name = "Close",
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(1, -28, 0.5, -7),
		BackgroundColor3 = Color3.fromRGB(255, 95, 87),
		Text = "",
		AutoButtonColor = false,
		Parent = TitleBar
	})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = CloseBtn})

	local CloseIcon = Create("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "×",
		TextColor3 = Color3.fromRGB(80, 0, 0),
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextTransparency = 1,
		Parent = CloseBtn
	})

	local Footer = Create("Frame", {
		Name = "Footer",
		Size = UDim2.new(1, 0, 0, 25),
		Position = UDim2.new(0, 0, 1, -25),
		BackgroundColor3 = Theme.Secondary,
		Parent = Main
	})

	Create("UICorner", {CornerRadius = UDim.new(0, 16), Parent = Footer})

	local FPSLabel = Create("TextLabel", {
		Size = UDim2.new(0, 80, 1, 0),
		Position = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text = "FPS: --",
		TextColor3 = Theme.TextDark,
		TextSize = 10,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Footer
	})

	local PingLabel = Create("TextLabel", {
		Size = UDim2.new(0, 80, 1, 0),
		Position = UDim2.new(0, 90, 0, 0),
		BackgroundTransparency = 1,
		Text = "Ping: --",
		TextColor3 = Theme.TextDark,
		TextSize = 10,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Footer
	})

	Create("TextLabel", {
		Size = UDim2.new(0, 100, 1, 0),
		Position = UDim2.new(1, -110, 0, 0),
		BackgroundTransparency = 1,
		Text = "v1.0",
		TextColor3 = Theme.TextDark,
		TextSize = 10,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = Footer
	})

	task.spawn(function()
		while ScreenGui.Parent do
			FPSLabel.Text = "FPS: " .. math.floor(1 / RunService.RenderStepped:Wait())
			local ping = LocalPlayer:GetNetworkPing() * 1000
			PingLabel.Text = "Ping: " .. math.floor(ping) .. "ms"
		end
	end)

	local Content = Create("Frame", {
		Name = "Content",
		Size = UDim2.new(1, -24, 1, -87),
		Position = UDim2.new(0, 12, 0, 55),
		BackgroundTransparency = 1,
		Parent = Main
	})

	local Sidebar = Create("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, 140, 1, 0),
		BackgroundColor3 = Theme.Secondary,
		Parent = Content
	})

	Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Sidebar})
	Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = 0.5, Parent = Sidebar})

	Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.Tertiary),
			ColorSequenceKeypoint.new(1, Theme.Secondary)
		}),
		Rotation = 180,
		Parent = Sidebar
	})

	local SearchBox = Create("Frame", {
		Size = UDim2.new(1, -16, 0, 32),
		Position = UDim2.new(0, 8, 0, 8),
		BackgroundColor3 = Theme.Tertiary,
		Parent = Sidebar
	})

	Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SearchBox})
	Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = 0.6, Parent = SearchBox})

	Create("TextLabel", {
		Size = UDim2.new(0, 30, 1, 0),
		BackgroundTransparency = 1,
		Text = "🔍",
		TextSize = 14,
		Parent = SearchBox
	})

	local SearchInput = Create("TextBox", {
		Size = UDim2.new(1, -35, 1, 0),
		Position = UDim2.new(0, 30, 0, 0),
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = "Search...",
		PlaceholderColor3 = Theme.TextDark,
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Parent = SearchBox
	})

	local TabContainer = Create("ScrollingFrame", {
		Size = UDim2.new(1, -8, 1, -52),
		Position = UDim2.new(0, 4, 0, 48),
		BackgroundTransparency = 1,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = Sidebar
	})

	Create("UIListLayout", {
		Padding = UDim.new(0, 6),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = TabContainer
	})

	Create("UIPadding", {PaddingTop = UDim.new(0, 4), Parent = TabContainer})

	local Pages = Create("Frame", {
		Name = "Pages",
		Size = UDim2.new(1, -152, 1, 0),
		Position = UDim2.new(0, 152, 0, 0),
		BackgroundColor3 = Theme.Secondary,
		ClipsDescendants = true,
		Parent = Content
	})

	Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Pages})
	Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = 0.5, Parent = Pages})

	Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.Tertiary),
			ColorSequenceKeypoint.new(1, Theme.Background)
		}),
		Rotation = 135,
		Parent = Pages
	})

	local PageLayout = Create("UIPageLayout", {
		EasingStyle = Enum.EasingStyle.Quint,
		EasingDirection = Enum.EasingDirection.Out,
		TweenTime = 0.4,
		ScrollWheelInputEnabled = false,
		Animated = true,
		Parent = Pages
	})

	Shadow.ImageTransparency = 1
	Tween(Shadow, 0.4, {ImageTransparency = 0.5})
	Tween(Main, 0.5, {Size = UDim2.new(0, 550, 0, 380)}, Enum.EasingStyle.Back)

	local dragging = false
	local dragStart = nil
	local startPos = nil

	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
		end
	end)

	TitleBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			Main.Position = newPos
			Shadow.Position = newPos
		end
	end)

	MinBtn.MouseEnter:Connect(function()
		Tween(MinBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(255, 170, 30)})
		Tween(MinIcon, 0.15, {TextTransparency = 0})
	end)
	MinBtn.MouseLeave:Connect(function()
		Tween(MinBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(255, 189, 46)})
		Tween(MinIcon, 0.15, {TextTransparency = 1})
	end)

	CloseBtn.MouseEnter:Connect(function()
		Tween(CloseBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(255, 70, 60)})
		Tween(CloseIcon, 0.15, {TextTransparency = 0})
	end)
	CloseBtn.MouseLeave:Connect(function()
		Tween(CloseBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(255, 95, 87)})
		Tween(CloseIcon, 0.15, {TextTransparency = 1})
	end)

	local originalSize = UDim2.new(0, 550, 0, 380)

	MinBtn.MouseButton1Click:Connect(function()
		Window.Minimized = not Window.Minimized
		if Window.Minimized then
			Tween(Main, 0.3, {Size = UDim2.new(0, 550, 0, 50)})
			Tween(Shadow, 0.3, {Size = UDim2.new(0, 600, 0, 100)})
			Content.Visible = false
			Footer.Visible = false
		else
			Content.Visible = true
			Footer.Visible = true
			Tween(Main, 0.3, {Size = originalSize})
			Tween(Shadow, 0.3, {Size = UDim2.new(0, 600, 0, 430)})
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		Tween(Main, 0.3, {Size = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		Tween(Shadow, 0.3, {ImageTransparency = 1})
		task.wait(0.35)
		ScreenGui:Destroy()
	end)

	SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
		local searchText = SearchInput.Text:lower()
		for _, tab in pairs(Window.Tabs) do
			for _, element in pairs(tab.Elements) do
				if element.Container then
					local visible = searchText == "" or element.Name:lower():find(searchText)
					element.Container.Visible = visible
				end
			end
		end
	end)

	function Window:CreateTab(config)
		config = config or {}
		local name = config.Name or "Tab"
		local icon = config.Icon or ""

		local Tab = {}
		Tab.Name = name
		Tab.Elements = {}

		local TabBtn = Create("TextButton", {
			Name = name,
			Size = UDim2.new(1, -8, 0, 40),
			BackgroundColor3 = Theme.Tertiary,
			Text = "",
			AutoButtonColor = false,
			Parent = TabContainer
		})

		Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TabBtn})

		local TabStroke = Create("UIStroke", {
			Color = Theme.Stroke,
			Thickness = 1,
			Transparency = 0.7,
			Parent = TabBtn
		})

		if icon ~= "" then
			Create("ImageLabel", {
				Size = UDim2.new(0, 20, 0, 20),
				Position = UDim2.new(0, 10, 0.5, -10),
				BackgroundTransparency = 1,
				Image = icon,
				ImageColor3 = Theme.TextDark,
				Parent = TabBtn
			})
		end

		local TabLabel = Create("TextLabel", {
			Size = UDim2.new(1, -45, 1, 0),
			Position = UDim2.new(0, icon ~= "" and 38 or 12, 0, 0),
			BackgroundTransparency = 1,
			Text = name,
			TextColor3 = Theme.TextDark,
			TextSize = 13,
			Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = TabBtn
		})

		local Indicator = Create("Frame", {
			Size = UDim2.new(0, 3, 0.5, 0),
			Position = UDim2.new(0, 0, 0.25, 0),
			BackgroundColor3 = Theme.Accent,
			Visible = false,
			Parent = TabBtn
		})
		Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = Indicator})

		local Page = Create("ScrollingFrame", {
			Name = name,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.Accent,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Parent = Pages
		})

		Create("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = Page
		})

		Create("UIPadding", {
			PaddingLeft = UDim.new(0, 14),
			PaddingTop = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
			PaddingBottom = UDim.new(0, 14),
			Parent = Page
		})

		Tab.Button = TabBtn
		Tab.Page = Page
		Tab.Indicator = Indicator
		Tab.Stroke = TabStroke
		Tab.Label = TabLabel

		local function SelectTab()
			if Window.CurrentTab then
				Window.CurrentTab.Indicator.Visible = false
				Tween(Window.CurrentTab.Button, 0.25, {BackgroundColor3 = Theme.Tertiary})
				Tween(Window.CurrentTab.Stroke, 0.25, {Transparency = 0.7})
				Tween(Window.CurrentTab.Label, 0.25, {TextColor3 = Theme.TextDark})
			end

			Window.CurrentTab = Tab
			Indicator.Visible = true
			Tween(TabBtn, 0.25, {BackgroundColor3 = Theme.Secondary})
			Tween(TabStroke, 0.25, {Transparency = 0.4, Color = Theme.Accent})
			Tween(TabLabel, 0.25, {TextColor3 = Theme.Text})
			PageLayout:JumpTo(Page)
		end

		TabBtn.MouseButton1Click:Connect(function()
			Ripple(TabBtn, TabBtn.AbsolutePosition.X + TabBtn.AbsoluteSize.X / 2, TabBtn.AbsolutePosition.Y + TabBtn.AbsoluteSize.Y / 2)
			SelectTab()
		end)

		TabBtn.MouseEnter:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabBtn, 0.2, {BackgroundColor3 = Theme.Secondary})
			end
		end)

		TabBtn.MouseLeave:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabBtn, 0.2, {BackgroundColor3 = Theme.Tertiary})
			end
		end)

		if #Window.Tabs == 0 then
			SelectTab()
		end

		table.insert(Window.Tabs, Tab)

		function Tab:CreateSection(sectionTitle)
			local Section = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundTransparency = 1,
				Parent = Page
			})

			Create("Frame", {
				Size = UDim2.new(0.25, 0, 0, 1),
				Position = UDim2.new(0, 0, 0.5, 0),
				BackgroundColor3 = Theme.Stroke,
				Parent = Section
			})

			Create("TextLabel", {
				Size = UDim2.new(0.5, 0, 1, 0),
				Position = UDim2.new(0.25, 0, 0, 0),
				BackgroundTransparency = 1,
				Text = sectionTitle,
				TextColor3 = Theme.TextDark,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				Parent = Section
			})

			Create("Frame", {
				Size = UDim2.new(0.25, 0, 0, 1),
				Position = UDim2.new(0.75, 0, 0.5, 0),
				BackgroundColor3 = Theme.Stroke,
				Parent = Section
			})

			return Section
		end

		function Tab:CreateToggle(config)
			config = config or {}
			local toggleName = config.Name or "Toggle"
			local default = config.Default or false
			local callback = config.Callback or function() end

			local enabled = default

			local Container = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundColor3 = Theme.Tertiary,
				Parent = Page
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Container})

			local Stroke = Create("UIStroke", {
				Color = Theme.Stroke,
				Thickness = 1,
				Transparency = 0.6,
				Parent = Container
			})

			Create("TextLabel", {
				Size = UDim2.new(1, -70, 1, 0),
				Position = UDim2.new(0, 16, 0, 0),
				BackgroundTransparency = 1,
				Text = toggleName,
				TextColor3 = Theme.Text,
				TextSize = 13,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Container
			})

			local ToggleBg = Create("Frame", {
				Size = UDim2.new(0, 46, 0, 24),
				Position = UDim2.new(1, -58, 0.5, -12),
				BackgroundColor3 = enabled and Theme.Accent or Theme.Stroke,
				Parent = Container
			})

			Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleBg})

			local Circle = Create("Frame", {
				Size = UDim2.new(0, 18, 0, 18),
				Position = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
				BackgroundColor3 = Theme.Text,
				Parent = ToggleBg
			})

			Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Circle})

			local Btn = Create("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				Parent = Container
			})

			Btn.MouseButton1Click:Connect(function()
				enabled = not enabled

				if enabled then
					Tween(Circle, 0.25, {Position = UDim2.new(1, -21, 0.5, -9)})
					Tween(ToggleBg, 0.25, {BackgroundColor3 = Theme.Accent})
					Tween(Stroke, 0.25, {Color = Theme.Accent, Transparency = 0.3})
				else
					Tween(Circle, 0.25, {Position = UDim2.new(0, 3, 0.5, -9)})
					Tween(ToggleBg, 0.25, {BackgroundColor3 = Theme.Stroke})
					Tween(Stroke, 0.25, {Color = Theme.Stroke, Transparency = 0.6})
				end

				callback(enabled)
			end)

			Container.MouseEnter:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Secondary})
			end)

			Container.MouseLeave:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Tertiary})
			end)

			local element = {Name = toggleName, Container = Container, Type = "Toggle"}
			table.insert(Tab.Elements, element)

			if default then
				callback(true)
			end

			return {
				Set = function(value)
					enabled = value
					if enabled then
						Tween(Circle, 0.25, {Position = UDim2.new(1, -21, 0.5, -9)})
						Tween(ToggleBg, 0.25, {BackgroundColor3 = Theme.Accent})
					else
						Tween(Circle, 0.25, {Position = UDim2.new(0, 3, 0.5, -9)})
						Tween(ToggleBg, 0.25, {BackgroundColor3 = Theme.Stroke})
					end
					callback(enabled)
				end,
				Get = function()
					return enabled
				end
			}
		end

		function Tab:CreateButton(config)
			config = config or {}
			local buttonName = config.Name or "Button"
			local callback = config.Callback or function() end

			local Btn = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundColor3 = Theme.Tertiary,
				Text = buttonName,
				TextColor3 = Theme.Text,
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				AutoButtonColor = false,
				ClipsDescendants = true,
				Parent = Page
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Btn})

			local Stroke = Create("UIStroke", {
				Color = Theme.Stroke,
				Thickness = 1,
				Transparency = 0.5,
				Parent = Btn
			})

			Btn.MouseButton1Click:Connect(function()
				Ripple(Btn, Btn.AbsolutePosition.X + Btn.AbsoluteSize.X / 2, Btn.AbsolutePosition.Y + Btn.AbsoluteSize.Y / 2)
				Tween(Btn, 0.1, {BackgroundColor3 = Theme.Accent})
				task.wait(0.1)
				Tween(Btn, 0.1, {BackgroundColor3 = Theme.Secondary})
				callback()
			end)

			Btn.MouseEnter:Connect(function()
				Tween(Btn, 0.2, {BackgroundColor3 = Theme.Secondary})
				Tween(Stroke, 0.2, {Transparency = 0.3})
			end)

			Btn.MouseLeave:Connect(function()
				Tween(Btn, 0.2, {BackgroundColor3 = Theme.Tertiary})
				Tween(Stroke, 0.2, {Transparency = 0.5})
			end)

			local element = {Name = buttonName, Container = Btn, Type = "Button"}
			table.insert(Tab.Elements, element)

			return Btn
		end

		function Tab:CreateSlider(config)
			config = config or {}
			local sliderName = config.Name or "Slider"
			local min = config.Min or 0
			local max = config.Max or 100
			local default = config.Default or min
			local callback = config.Callback or function() end

			local Container = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 60),
				BackgroundColor3 = Theme.Tertiary,
				Parent = Page
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Container})
			Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = 0.6, Parent = Container})

			Create("TextLabel", {
				Size = UDim2.new(1, -70, 0, 22),
				Position = UDim2.new(0, 16, 0, 8),
				BackgroundTransparency = 1,
				Text = sliderName,
				TextColor3 = Theme.Text,
				TextSize = 13,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Container
			})

			local ValueLabel = Create("TextLabel", {
				Size = UDim2.new(0, 50, 0, 22),
				Position = UDim2.new(1, -66, 0, 8),
				BackgroundTransparency = 1,
				Text = tostring(default),
				TextColor3 = Theme.Accent,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Right,
				Parent = Container
			})

			local SliderBg = Create("Frame", {
				Size = UDim2.new(1, -32, 0, 6),
				Position = UDim2.new(0, 16, 0, 42),
				BackgroundColor3 = Theme.Stroke,
				Parent = Container
			})

			Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderBg})

			local defaultPercent = (default - min) / (max - min)

			local Fill = Create("Frame", {
				Size = UDim2.new(math.clamp(defaultPercent, 0, 1), 0, 1, 0),
				BackgroundColor3 = Theme.Accent,
				Parent = SliderBg
			})

			Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})

			local Knob = Create("Frame", {
				Size = UDim2.new(0, 16, 0, 16),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				BackgroundColor3 = Theme.Text,
				ZIndex = 2,
				Parent = Fill
			})

			Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})
			Create("UIStroke", {Color = Theme.Accent, Thickness = 2, Parent = Knob})

			local isDragging = false

			local function update(inputX)
				local rel = math.clamp((inputX - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
				local val = math.floor(min + (max - min) * rel)
				ValueLabel.Text = tostring(val)
				Tween(Fill, 0.05, {Size = UDim2.new(rel, 0, 1, 0)})
				callback(val)
			end

			SliderBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isDragging = true
					update(input.Position.X)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					update(input.Position.X)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isDragging = false
				end
			end)

			Container.MouseEnter:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Secondary})
			end)

			Container.MouseLeave:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Tertiary})
			end)

			local element = {Name = sliderName, Container = Container, Type = "Slider"}
			table.insert(Tab.Elements, element)

			return {
				Set = function(value)
					local rel = (value - min) / (max - min)
					ValueLabel.Text = tostring(value)
					Tween(Fill, 0.25, {Size = UDim2.new(rel, 0, 1, 0)})
					callback(value)
				end
			}
		end

		function Tab:CreateDropdown(config)
			config = config or {}
			local dropdownName = config.Name or "Dropdown"
			local options = config.Options or {}
			local default = config.Default or options[1] or ""
			local callback = config.Callback or function() end

			local isOpen = false
			local selected = default

			local Container = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundColor3 = Theme.Tertiary,
				ClipsDescendants = true,
				Parent = Page
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Container})
			Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = 0.6, Parent = Container})

			Create("TextLabel", {
				Size = UDim2.new(0.5, 0, 0, 45),
				Position = UDim2.new(0, 16, 0, 0),
				BackgroundTransparency = 1,
				Text = dropdownName,
				TextColor3 = Theme.Text,
				TextSize = 13,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Container
			})

			local SelectedLabel = Create("TextLabel", {
				Size = UDim2.new(0.4, 0, 0, 45),
				Position = UDim2.new(0.5, 0, 0, 0),
				BackgroundTransparency = 1,
				Text = selected,
				TextColor3 = Theme.Accent,
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				TextXAlignment = Enum.TextXAlignment.Right,
				Parent = Container
			})

			local Arrow = Create("TextLabel", {
				Size = UDim2.new(0, 30, 0, 45),
				Position = UDim2.new(1, -35, 0, 0),
				BackgroundTransparency = 1,
				Text = "▼",
				TextColor3 = Theme.TextDark,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Parent = Container
			})

			local OptionsContainer = Create("Frame", {
				Size = UDim2.new(1, -20, 0, 0),
				Position = UDim2.new(0, 10, 0, 50),
				BackgroundTransparency = 1,
				Parent = Container
			})

			Create("UIListLayout", {Padding = UDim.new(0, 5), Parent = OptionsContainer})

			local function getOptionsHeight()
				return #options * 35 + math.max(0, #options - 1) * 5
			end

			local function closeDropdown()
				isOpen = false
				Tween(Container, 0.3, {Size = UDim2.new(1, 0, 0, 45)})
				Tween(Arrow, 0.3, {Rotation = 0})
			end

			local function buildOptions()
				for _, child in pairs(OptionsContainer:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end

				for _, option in ipairs(options) do
					local OptionBtn = Create("TextButton", {
						Size = UDim2.new(1, 0, 0, 30),
						BackgroundColor3 = Theme.Secondary,
						Text = option,
						TextColor3 = option == selected and Theme.Accent or Theme.Text,
						TextSize = 12,
						Font = Enum.Font.Gotham,
						AutoButtonColor = false,
						Parent = OptionsContainer
					})

					Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = OptionBtn})

					OptionBtn.MouseButton1Click:Connect(function()
						selected = option
						SelectedLabel.Text = option
						for _, btn in pairs(OptionsContainer:GetChildren()) do
							if btn:IsA("TextButton") then
								Tween(btn, 0.15, {TextColor3 = Theme.Text})
							end
						end
						Tween(OptionBtn, 0.15, {TextColor3 = Theme.Accent})
						closeDropdown()
						callback(option)
					end)

					OptionBtn.MouseEnter:Connect(function()
						Tween(OptionBtn, 0.15, {BackgroundColor3 = Theme.Accent})
					end)

					OptionBtn.MouseLeave:Connect(function()
						Tween(OptionBtn, 0.15, {BackgroundColor3 = Theme.Secondary})
					end)
				end

				OptionsContainer.Size = UDim2.new(1, -20, 0, getOptionsHeight())
			end

			buildOptions()

			local HeaderBtn = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundTransparency = 1,
				Text = "",
				Parent = Container
			})

			HeaderBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				if isOpen then
					OptionsContainer.Size = UDim2.new(1, -20, 0, getOptionsHeight())
					Tween(Container, 0.3, {Size = UDim2.new(1, 0, 0, 55 + getOptionsHeight())})
					Tween(Arrow, 0.3, {Rotation = 180})
				else
					closeDropdown()
				end
			end)

			Container.MouseEnter:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Secondary})
			end)

			Container.MouseLeave:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Tertiary})
			end)

			local element = {Name = dropdownName, Container = Container, Type = "Dropdown"}
			table.insert(Tab.Elements, element)

			return {
				Set = function(value)
					selected = value
					SelectedLabel.Text = value
					callback(value)
				end,
				Get = function()
					return selected
				end,
Refresh = function(newOptions)
    options = newOptions
    selected = newOptions[1] or ""
    if isOpen then closeDropdown() end
    buildOptions()
    SelectedLabel.Text = selected
end
			}
		end

		function Tab:CreateMultiDropdown(config)
			config = config or {}
			local dropdownName = config.Name or "Dropdown"
			local options = config.Options or {}
			local default = config.Default or {}
			local callback = config.Callback or function() end

			local isOpen = false
			local selected = {}
			for _, v in pairs(default) do
				selected[v] = true
			end

			local Container = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundColor3 = Theme.Tertiary,
				ClipsDescendants = true,
				Parent = Page
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Container})
			Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = 0.6, Parent = Container})

			Create("TextLabel", {
				Size = UDim2.new(0.45, 0, 0, 45),
				Position = UDim2.new(0, 16, 0, 0),
				BackgroundTransparency = 1,
				Text = dropdownName,
				TextColor3 = Theme.Text,
				TextSize = 13,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Container
			})

			local SelectedLabel = Create("TextLabel", {
				Size = UDim2.new(0.45, 0, 0, 45),
				Position = UDim2.new(0.45, 0, 0, 0),
				BackgroundTransparency = 1,
				Text = "None",
				TextColor3 = Theme.Accent,
				TextSize = 11,
				Font = Enum.Font.GothamSemibold,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = Container
			})

			local Arrow = Create("TextLabel", {
				Size = UDim2.new(0, 30, 0, 45),
				Position = UDim2.new(1, -35, 0, 0),
				BackgroundTransparency = 1,
				Text = "▼",
				TextColor3 = Theme.TextDark,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Parent = Container
			})

			local OptionsContainer = Create("Frame", {
				Size = UDim2.new(1, -20, 0, 0),
				Position = UDim2.new(0, 10, 0, 50),
				BackgroundTransparency = 1,
				Parent = Container
			})

			Create("UIListLayout", {Padding = UDim.new(0, 5), Parent = OptionsContainer})

			local function getSelectedText()
				local list = {}
				for k, v in pairs(selected) do
					if v then table.insert(list, k) end
				end
				if #list == 0 then return "None" end
				return table.concat(list, ", ")
			end

			local function getOptionsHeight()
				return #options * 35 + math.max(0, #options - 1) * 5
			end

			local function closeDropdown()
				isOpen = false
				Tween(Container, 0.3, {Size = UDim2.new(1, 0, 0, 45)})
				Tween(Arrow, 0.3, {Rotation = 0})
			end

			local function buildOptions()
				for _, child in pairs(OptionsContainer:GetChildren()) do
					if child:IsA("Frame") then child:Destroy() end
				end

				for _, option in ipairs(options) do
					local isSelected = selected[option] == true

					local OptionFrame = Create("Frame", {
						Size = UDim2.new(1, 0, 0, 30),
						BackgroundColor3 = isSelected and Theme.Accent or Theme.Secondary,
						Parent = OptionsContainer
					})

					Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = OptionFrame})

					local CheckMark = Create("TextLabel", {
						Size = UDim2.new(0, 20, 1, 0),
						Position = UDim2.new(0, 8, 0, 0),
						BackgroundTransparency = 1,
						Text = isSelected and "✓" or "",
						TextColor3 = Theme.Background,
						TextSize = 14,
						Font = Enum.Font.GothamBold,
						Parent = OptionFrame
					})

					local OptionLabel = Create("TextLabel", {
						Size = UDim2.new(1, -35, 1, 0),
						Position = UDim2.new(0, 30, 0, 0),
						BackgroundTransparency = 1,
						Text = option,
						TextColor3 = isSelected and Theme.Background or Theme.Text,
						TextSize = 12,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = OptionFrame
					})

					local OptionBtn = Create("TextButton", {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Text = "",
						Parent = OptionFrame
					})

					OptionBtn.MouseButton1Click:Connect(function()
						selected[option] = not selected[option]
						local sel = selected[option]

						Tween(OptionFrame, 0.15, {BackgroundColor3 = sel and Theme.Accent or Theme.Secondary})
						CheckMark.Text = sel and "✓" or ""
						Tween(OptionLabel, 0.15, {TextColor3 = sel and Theme.Background or Theme.Text})

						SelectedLabel.Text = getSelectedText()

						local result = {}
						for k, v in pairs(selected) do
							if v then table.insert(result, k) end
						end
						callback(result)
					end)

					OptionFrame.MouseEnter:Connect(function()
						if not selected[option] then
							Tween(OptionFrame, 0.15, {BackgroundColor3 = Theme.Tertiary})
						end
					end)

					OptionFrame.MouseLeave:Connect(function()
						if not selected[option] then
							Tween(OptionFrame, 0.15, {BackgroundColor3 = Theme.Secondary})
						end
					end)
				end

				OptionsContainer.Size = UDim2.new(1, -20, 0, getOptionsHeight())
				SelectedLabel.Text = getSelectedText()
			end

			buildOptions()

			local HeaderBtn = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundTransparency = 1,
				Text = "",
				Parent = Container
			})

			HeaderBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				if isOpen then
					OptionsContainer.Size = UDim2.new(1, -20, 0, getOptionsHeight())
					Tween(Container, 0.3, {Size = UDim2.new(1, 0, 0, 55 + getOptionsHeight())})
					Tween(Arrow, 0.3, {Rotation = 180})
				else
					closeDropdown()
				end
			end)

			Container.MouseEnter:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Secondary})
			end)

			Container.MouseLeave:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Tertiary})
			end)

			local element = {Name = dropdownName, Container = Container, Type = "MultiDropdown"}
			table.insert(Tab.Elements, element)

			return {
				Set = function(values)
					selected = {}
					for _, v in pairs(values) do
						selected[v] = true
					end
					buildOptions()
					SelectedLabel.Text = getSelectedText()
				end,
				Get = function()
					local result = {}
					for k, v in pairs(selected) do
						if v then table.insert(result, k) end
					end
					return result
				end,
				Refresh = function(newOptions)
					options = newOptions
					if isOpen then closeDropdown() end
					buildOptions()
				end
			}
		end

		function Tab:CreateKeybind(config)
			config = config or {}
			local keybindName = config.Name or "Keybind"
			local default = config.Default or Enum.KeyCode.E
			local callback = config.Callback or function() end

			local currentKey = default
			local isListening = false

			local Container = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundColor3 = Theme.Tertiary,
				Parent = Page
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Container})
			Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = 0.6, Parent = Container})

			Create("TextLabel", {
				Size = UDim2.new(1, -100, 1, 0),
				Position = UDim2.new(0, 16, 0, 0),
				BackgroundTransparency = 1,
				Text = keybindName,
				TextColor3 = Theme.Text,
				TextSize = 13,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Container
			})

			local KeyBtn = Create("TextButton", {
				Size = UDim2.new(0, 70, 0, 28),
				Position = UDim2.new(1, -82, 0.5, -14),
				BackgroundColor3 = Theme.Secondary,
				Text = currentKey.Name,
				TextColor3 = Theme.Accent,
				TextSize = 12,
				Font = Enum.Font.GothamBold,
				AutoButtonColor = false,
				Parent = Container
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = KeyBtn})
			Create("UIStroke", {Color = Theme.Accent, Thickness = 1, Transparency = 0.5, Parent = KeyBtn})

			KeyBtn.MouseButton1Click:Connect(function()
				isListening = true
				KeyBtn.Text = "..."
				Tween(KeyBtn, 0.2, {BackgroundColor3 = Theme.Accent})
				Tween(KeyBtn, 0.2, {TextColor3 = Theme.Background})
			end)

			UserInputService.InputBegan:Connect(function(input, processed)
				if isListening and input.UserInputType == Enum.UserInputType.Keyboard then
					currentKey = input.KeyCode
					KeyBtn.Text = currentKey.Name
					isListening = false
					Tween(KeyBtn, 0.2, {BackgroundColor3 = Theme.Secondary})
					Tween(KeyBtn, 0.2, {TextColor3 = Theme.Accent})
				elseif not isListening and input.KeyCode == currentKey and not processed then
					callback()
				end
			end)

			Container.MouseEnter:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Secondary})
			end)

			Container.MouseLeave:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Tertiary})
			end)

			local element = {Name = keybindName, Container = Container, Type = "Keybind"}
			table.insert(Tab.Elements, element)

			return {
				Set = function(key)
					currentKey = key
					KeyBtn.Text = key.Name
				end,
				Get = function()
					return currentKey
				end
			}
		end

		function Tab:CreateInput(config)
			config = config or {}
			local inputName = config.Name or "Input"
			local placeholder = config.Placeholder or "Enter text..."
			local callback = config.Callback or function() end

			local Container = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundColor3 = Theme.Tertiary,
				Parent = Page
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Container})
			Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = 0.6, Parent = Container})

			Create("TextLabel", {
				Size = UDim2.new(0.4, 0, 1, 0),
				Position = UDim2.new(0, 16, 0, 0),
				BackgroundTransparency = 1,
				Text = inputName,
				TextColor3 = Theme.Text,
				TextSize = 13,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Container
			})

			local InputBox = Create("TextBox", {
				Size = UDim2.new(0.5, -20, 0, 28),
				Position = UDim2.new(0.5, 0, 0.5, -14),
				BackgroundColor3 = Theme.Secondary,
				Text = "",
				PlaceholderText = placeholder,
				PlaceholderColor3 = Theme.TextDark,
				TextColor3 = Theme.Text,
				TextSize = 12,
				Font = Enum.Font.Gotham,
				ClearTextOnFocus = false,
				Parent = Container
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = InputBox})
			Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = InputBox})

			InputBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					callback(InputBox.Text)
				end
			end)

			Container.MouseEnter:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Secondary})
			end)

			Container.MouseLeave:Connect(function()
				Tween(Container, 0.2, {BackgroundColor3 = Theme.Tertiary})
			end)

			local element = {Name = inputName, Container = Container, Type = "Input"}
			table.insert(Tab.Elements, element)

			return {
				Set = function(text)
					InputBox.Text = text
				end,
				Get = function()
					return InputBox.Text
				end
			}
		end

		function Tab:CreateColorPicker(config)
			config = config or {}
			local colorName = config.Name or "Color"
			local default = config.Default or Color3.fromRGB(255, 255, 255)
			local callback = config.Callback or function() end

			local currentColor = default
			local isOpen = false

			local Container = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundColor3 = Theme.Tertiary,
				ClipsDescendants = true,
				Parent = Page
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Container})
			Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = 0.6, Parent = Container})

			Create("TextLabel", {
				Size = UDim2.new(1, -80, 0, 45),
				Position = UDim2.new(0, 16, 0, 0),
				BackgroundTransparency = 1,
				Text = colorName,
				TextColor3 = Theme.Text,
				TextSize = 13,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Container
			})

			local ColorPreview = Create("Frame", {
				Size = UDim2.new(0, 50, 0, 25),
				Position = UDim2.new(1, -65, 0, 10),
				BackgroundColor3 = currentColor,
				Parent = Container
			})

			Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ColorPreview})
			Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = ColorPreview})

			local PickerContainer = Create("Frame", {
				Size = UDim2.new(1, -20, 0, 120),
				Position = UDim2.new(0, 10, 0, 50),
				BackgroundTransparency = 1,
				Visible = false,
				Parent = Container
			})

			local RGBContainer = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 30),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				Parent = PickerContainer
			})

			local function createRGBInput(label, posX, defaultVal)
				Create("TextLabel", {
					Size = UDim2.new(0, 15, 1, 0),
					Position = UDim2.new(0, posX, 0, 0),
					BackgroundTransparency = 1,
					Text = label,
					TextColor3 = Theme.TextDark,
					TextSize = 11,
					Font = Enum.Font.GothamBold,
					Parent = RGBContainer
				})

				local input = Create("TextBox", {
					Size = UDim2.new(0, 50, 0, 25),
					Position = UDim2.new(0, posX + 18, 0, 2),
					BackgroundColor3 = Theme.Secondary,
					Text = tostring(defaultVal),
					TextColor3 = Theme.Text,
					TextSize = 11,
					Font = Enum.Font.Gotham,
					Parent = RGBContainer
				})
				Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = input})

				return input
			end

			local RInput = createRGBInput("R", 0, math.floor(currentColor.R * 255))
			local GInput = createRGBInput("G", 80, math.floor(currentColor.G * 255))
			local BInput = createRGBInput("B", 160, math.floor(currentColor.B * 255))

			local function updateColor()
				local r = math.clamp(tonumber(RInput.Text) or 255, 0, 255)
				local g = math.clamp(tonumber(GInput.Text) or 255, 0, 255)
				local b = math.clamp(tonumber(BInput.Text) or 255, 0, 255)
				currentColor = Color3.fromRGB(r, g, b)
				ColorPreview.BackgroundColor3 = currentColor
				callback(currentColor)
			end

			RInput.FocusLost:Connect(updateColor)
			GInput.FocusLost:Connect(updateColor)
			BInput.FocusLost:Connect(updateColor)

			local HeaderBtn = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundTransparency = 1,
				Text = "",
				Parent = Container
			})

			HeaderBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				PickerContainer.Visible = isOpen

				if isOpen then
					Tween(Container, 0.3, {Size = UDim2.new(1, 0, 0, 100)})
				else
					Tween(Container, 0.3, {Size = UDim2.new(1, 0, 0, 45)})
				end
			end)

			local element = {Name = colorName, Container = Container, Type = "ColorPicker"}
			table.insert(Tab.Elements, element)

			return {
				Set = function(color)
					currentColor = color
					ColorPreview.BackgroundColor3 = color
					RInput.Text = tostring(math.floor(color.R * 255))
					GInput.Text = tostring(math.floor(color.G * 255))
					BInput.Text = tostring(math.floor(color.B * 255))
					callback(color)
				end,
				Get = function()
					return currentColor
				end
			}
		end

		return Tab
	end

	function Library:Notify(config)
		config = config or {}
		local notifTitle = config.Title or "Notification"
		local text = config.Text or ""
		local duration = config.Duration or 3

		local Notif = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundColor3 = Theme.Secondary,
			ClipsDescendants = true,
			Parent = NotifContainer
		})

		Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Notif})
		Create("UIStroke", {Color = Theme.Accent, Thickness = 1, Transparency = 0.5, Parent = Notif})

		Create("TextLabel", {
			Size = UDim2.new(1, -20, 0, 20),
			Position = UDim2.new(0, 10, 0, 8),
			BackgroundTransparency = 1,
			Text = notifTitle,
			TextColor3 = Theme.Accent,
			TextSize = 14,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Notif
		})

		Create("TextLabel", {
			Size = UDim2.new(1, -20, 0, 30),
			Position = UDim2.new(0, 10, 0, 28),
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 12,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Parent = Notif
		})

		local Progress = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 3),
			Position = UDim2.new(0, 0, 1, -3),
			BackgroundColor3 = Theme.Accent,
			Parent = Notif
		})

		Tween(Notif, 0.3, {Size = UDim2.new(1, 0, 0, 70)})
		Tween(Progress, duration, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)

		task.delay(duration, function()
			Tween(Notif, 0.3, {Size = UDim2.new(1, 0, 0, 0)})
			task.wait(0.35)
			Notif:Destroy()
		end)
	end

	function Window:Destroy()
		Tween(Main, 0.3, {Size = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		Tween(Shadow, 0.3, {ImageTransparency = 1})
		task.wait(0.35)
		ScreenGui:Destroy()
	end

	return Window
end

return Library
