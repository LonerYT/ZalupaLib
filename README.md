# Zalupa script instructions

```Markdown
# ZalupaLib

Beautiful UI library for Roblox scripts

> 🤖 This library was fully created using AI
> Telegram @Sad_Loner
## 📦 Installation

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LonerYT/ZalupaLib/main/Library.lua"))()
```
## 🪟 Creating Window
### Uncondensed:
```lua
local Window = Library:CreateWindow({
    Title = "Script Name",
    Subtitle = "v1.0",
    Theme = "Dark",
    AccentColor = Color3.fromRGB(255, 255, 255) -- optional
})
```
### Condensed:
```lua
local Window = Library:CreateWindow({Title = "Script Name", Subtitle = "v1.0", Theme = "Dark"})
```
## 🎨 Themes
- ⚫ Dark - Default dark theme
- ⚪ Light - Light theme
- 🟣 Purple - Purple theme
- 🔴 Red - Red theme
- 🔵 Blue - Blue theme
## 📑 Creating Tab
```lua
local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "" -- rbxassetid:// or empty
})
```
### Condensed:
```lua
local Tab = Window:CreateTab({Name = "Main", Icon = ""})
```
## 🧩 Elements
## Section
```lua
Tab:CreateSection("Section Name")
```
## Toggle
### Uncondensed:
```lua
local toggle = Tab:CreateToggle({
    Name = "Toggle",
    Default = false,
    Callback = function(value)
        print(value)
    end
})

-- Methods
toggle:Set(true)
toggle:Get()
```
### Condensed:
```lua
local toggle = Tab:CreateToggle({Name = "Toggle", Default = false, Callback = function(value) print(value) end})
```
## Button
### Uncondensed:
```lua
Tab:CreateButton({
    Name = "Button",
    Callback = function()
        print("Clicked!")
    end
})
```
### Condensed:
```lua
Tab:CreateButton({Name = "Button", Callback = function() print("Clicked!") end})
```
## Slider
### Uncondensed:
```lua
local slider = Tab:CreateSlider({
    Name = "Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print(value)
    end
})

-- Methods
slider:Set(75)
```
### Condensed:
```lua
local slider = Tab:CreateSlider({Name = "Slider", Min = 0, Max = 100, Default = 50, Callback = function(value) print(value) end})
```
## Dropdown
### Uncondensed:
```lua
local dropdown = Tab:CreateDropdown({
    Name = "Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(value)
        print(value)
    end
})

-- Methods
dropdown:Set("Option 2")
dropdown:Get()
dropdown:Refresh({"New 1", "New 2"})
```
### Condensed:
```lua
local dropdown = Tab:CreateDropdown({Name = "Dropdown", Options = {"Option 1", "Option 2"}, Default = "Option 1", Callback = function(value) print(value) end})
```
## Keybind
### Uncondensed:
```lua
local keybind = Tab:CreateKeybind({
    Name = "Keybind",
    Default = Enum.KeyCode.E,
    Callback = function()
        print("Key pressed!")
    end
})

-- Methods
keybind:Set(Enum.KeyCode.F)
keybind:Get()
```
### Condensed:
```lua
local keybind = Tab:CreateKeybind({Name = "Keybind", Default = Enum.KeyCode.E, Callback = function() print("Key pressed!") end})
```
## Input
### Uncondensed:
```lua
local input = Tab:CreateInput({
    Name = "Input",
    Placeholder = "Enter text...",
    Callback = function(text)
        print(text)
    end
})

-- Methods
input:Set("Hello")
input:Get()
```
### Condensed:
```lua
local input = Tab:CreateInput({Name = "Input", Placeholder = "Enter text...", Callback = function(text) print(text) end})
```
## Color Picker
### Uncondensed:
```lua
local picker = Tab:CreateColorPicker({
    Name = "Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        print(color)
    end
})

-- Methods
picker:Set(Color3.fromRGB(255, 0, 0))
picker:Get()
```
### Condensed:
```lua
local picker = Tab:CreateColorPicker({Name = "Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(color) print(color) end})
```
## 🔔 Notifications
### Uncondensed:
```lua
Library:Notify({
    Title = "Title",
    Text = "Message",
    Duration = 3
})
```
### Condensed:
```lua
Library:Notify({Title = "Title", Text = "Message", Duration = 3})
```
## ⚙️ Window Control
```lua
-- Destroy window
Window:Destroy()
```
### ✨ Features
- 🎨 5 built-in themes
- 🌊 Animated gradient background
- ✨ Floating particles
- 💫 Glowing border animation
- 🔍 Search through elements
- 📊 FPS and Ping in footer
- 🌀 Ripple effect on buttons
- 🎭 Smooth animations
## 🤖 Author
- Created with Claude AI
