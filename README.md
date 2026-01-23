# Zalupa script instructions

```Markdown
# ZalupaLib

Beautiful UI library for Roblox scripts

> 🤖 This library was fully created using AI

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
```Markdown
> **Dark** - Dark theme with white accent (default)

> **Light** - Light theme with dark accent

> **Purple** - Purple vibes 💜

> **Red** - Red accent ❤️

> **Blue** - Blue accent 💙
```
## 📑 Creating Tab
```lua
local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "" -- rbxassetid:// or empty
})
```
## 🧩 Elements

## Section
```lua
Tab:CreateSection("Section Name")
```
## Toggle
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
## Button
```lua
Tab:CreateButton({
    Name = "Button",
    Callback = function()
        print("Clicked!")
    end
})
```
## Slider
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
## Dropdown
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
## Keybind
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
## Input
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
## Color Picker
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
## 🔔 Notifications
```lua
Library:Notify({
    Title = "Title",
    Text = "Message",
    Duration = 3
})
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
