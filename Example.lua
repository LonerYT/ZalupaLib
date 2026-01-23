local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LonerYT/ZalupaLib/main/Library.lua"))()

-- Create Window
local Window = Library:CreateWindow({
    Title = "ZalupaLib Example",
    Subtitle = "v1.0",
    Theme = "Dark"
})

-- ============================================
-- TAB 1: Main
-- ============================================
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = ""
})

-- Section
MainTab:CreateSection("Toggles")

-- Toggle
local myToggle = MainTab:CreateToggle({
    Name = "Enable Feature",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

-- Toggle with methods
local anotherToggle = MainTab:CreateToggle({
    Name = "Auto Farm",
    Default = true,
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

-- Section
MainTab:CreateSection("Sliders")

-- Slider
local speedSlider = MainTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Another Slider
local jumpSlider = MainTab:CreateSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

-- Section
MainTab:CreateSection("Buttons")

-- Button
MainTab:CreateButton({
    Name = "Print Hello",
    Callback = function()
        print("Hello World!")
    end
})

-- Another Button
MainTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})

-- ============================================
-- TAB 2: Combat
-- ============================================
local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = ""
})

CombatTab:CreateSection("Aimbot")

-- Toggle
CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(value)
        print("Aimbot:", value)
    end
})

-- Slider
CombatTab:CreateSlider({
    Name = "FOV Size",
    Min = 50,
    Max = 500,
    Default = 120,
    Callback = function(value)
        print("FOV:", value)
    end
})

-- Dropdown
local targetDropdown = CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    Default = "Head",
    Callback = function(value)
        print("Target Part:", value)
    end
})

CombatTab:CreateSection("Settings")

-- Toggle
CombatTab:CreateToggle({
    Name = "Team Check",
    Default = true,
    Callback = function(value)
        print("Team Check:", value)
    end
})

-- Toggle
CombatTab:CreateToggle({
    Name = "Visible Check",
    Default = false,
    Callback = function(value)
        print("Visible Check:", value)
    end
})

-- ============================================
-- TAB 3: Visuals
-- ============================================
local VisualsTab = Window:CreateTab({
    Name = "Visuals",
    Icon = ""
})

VisualsTab:CreateSection("ESP")

-- Toggle
VisualsTab:CreateToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(value)
        print("ESP:", value)
    end
})

-- Toggle
VisualsTab:CreateToggle({
    Name = "Box ESP",
    Default = false,
    Callback = function(value)
        print("Box ESP:", value)
    end
})

-- Toggle
VisualsTab:CreateToggle({
    Name = "Name ESP",
    Default = false,
    Callback = function(value)
        print("Name ESP:", value)
    end
})

-- Slider
VisualsTab:CreateSlider({
    Name = "Max Distance",
    Min = 100,
    Max = 2000,
    Default = 500,
    Callback = function(value)
        print("Max Distance:", value)
    end
})

VisualsTab:CreateSection("Colors")

-- Color Picker
local espColor = VisualsTab:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("ESP Color:", color)
    end
})

-- Another Color Picker
local boxColor = VisualsTab:CreateColorPicker({
    Name = "Box Color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(color)
        print("Box Color:", color)
    end
})

-- ============================================
-- TAB 4: Misc
-- ============================================
local MiscTab = Window:CreateTab({
    Name = "Misc",
    Icon = ""
})

MiscTab:CreateSection("Keybinds")

-- Keybind
local flyKeybind = MiscTab:CreateKeybind({
    Name = "Toggle Fly",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Fly toggled!")
    end
})

-- Another Keybind
local noClipKeybind = MiscTab:CreateKeybind({
    Name = "Toggle NoClip",
    Default = Enum.KeyCode.N,
    Callback = function()
        print("NoClip toggled!")
    end
})

MiscTab:CreateSection("Input")

-- Input
local usernameInput = MiscTab:CreateInput({
    Name = "Target Player",
    Placeholder = "Enter username...",
    Callback = function(text)
        print("Target:", text)
    end
})

-- Another Input
local messageInput = MiscTab:CreateInput({
    Name = "Chat Message",
    Placeholder = "Enter message...",
    Callback = function(text)
        print("Message:", text)
    end
})

MiscTab:CreateSection("Teleport")

-- Dropdown
local teleportDropdown = MiscTab:CreateDropdown({
    Name = "Teleport To",
    Options = {"Spawn", "Shop", "Boss", "Secret Area"},
    Default = "Spawn",
    Callback = function(value)
        print("Teleport to:", value)
    end
})

-- Button
MiscTab:CreateButton({
    Name = "Teleport",
    Callback = function()
        print("Teleporting to:", teleportDropdown:Get())
    end
})

-- ============================================
-- TAB 5: Settings
-- ============================================
local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = ""
})

SettingsTab:CreateSection("UI Settings")

-- Color Picker for UI
local accentPicker = SettingsTab:CreateColorPicker({
    Name = "Accent Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        print("Accent:", color)
    end
})

SettingsTab:CreateSection("Methods Example")

-- Button to demonstrate methods
SettingsTab:CreateButton({
    Name = "Set Toggle to True",
    Callback = function()
        myToggle:Set(true)
    end
})

SettingsTab:CreateButton({
    Name = "Set Speed to 100",
    Callback = function()
        speedSlider:Set(100)
    end
})

SettingsTab:CreateButton({
    Name = "Set Target to Torso",
    Callback = function()
        targetDropdown:Set("Torso")
    end
})

SettingsTab:CreateButton({
    Name = "Refresh Dropdown",
    Callback = function()
        targetDropdown:Refresh({"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"})
    end
})

SettingsTab:CreateSection("Window")

-- Destroy Button
SettingsTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Window:Destroy()
    end
})

-- ============================================
-- NOTIFICATION
-- ============================================
Library:Notify({
    Title = "Welcome!",
    Text = "ZalupaLib loaded successfully. All features are ready to use!",
    Duration = 5
})

-- Example of getting values
print("Current Toggle Value:", myToggle:Get())
print("Current Dropdown Value:", targetDropdown:Get())
print("Current Keybind:", flyKeybind:Get())
print("Current Input:", usernameInput:Get())
print("Current Color:", espColor:Get())
