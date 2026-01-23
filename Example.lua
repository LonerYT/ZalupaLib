local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LonerYT/ZalupaLib/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Zalupa Scripts",
    Subtitle = "v1.0",
    Theme = "Dark"
})

local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = ""
})

MainTab:CreateSection("Combat")

MainTab:CreateToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(value)
        print("Aimbot:", value)
    end
})

MainTab:CreateSlider({
    Name = "FOV",
    Min = 50,
    Max = 500,
    Default = 120,
    Callback = function(value)
        print("FOV:", value)
    end
})

MainTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "Random"},
    Default = "Head",
    Callback = function(value)
        print("Target:", value)
    end
})

MainTab:CreateKeybind({
    Name = "Keybind",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Key pressed!")
    end
})

MainTab:CreateButton({
    Name = "Print Hello",
    Callback = function()
        print("Hello!")
    end
})

MainTab:CreateInput({
    Name = "Username",
    Placeholder = "Enter name...",
    Callback = function(text)
        print("Input:", text)
    end
})

MainTab:CreateColorPicker({
    Name = "Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        print("Color:", color)
    end
})

Library:Notify({
    Title = "Welcome!",
    Text = "Script loaded successfully",
    Duration = 3
})
