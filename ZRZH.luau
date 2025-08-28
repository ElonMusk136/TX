local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({

    Title = "TX V2-自然灾害",

    SubTitle = "by 退休",

    SaveFolder = "TX.lua"

})

Window:AddMinimizeButton({

    Button = { Image = "rbxassetid://82031063194606", BackgroundTransparency = 0 },

    Corner = { CornerRadius = UDim.new(35, 1) },

})

local Tab1 = Window:MakeTab({"功能", "cherry"})

Window:SelectTab(Tab1)

local Section = Tab1:AddSection({"功能"})

local Paragraph = Tab1:AddParagraph({"温馨提示:浮木怎么办？"})

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local config = {

    radius = 50,

    height = 100,

    rotationSpeed = 10,

    attractionStrength = 1000

}

local ringPartsEnabled = false

local parts = {}

local function RetainPart(Part)

    if Part:IsA("BasePart") and not Part.Anchored and Part:IsDescendantOf(Workspace) then

        if Part.Parent == LocalPlayer.Character or Part:IsDescendantOf(LocalPlayer.Character) then

            return false

        end

        Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)

        Part.CanCollide = false

        return true

    end

    return false

end

local function addPart(part)

    if RetainPart(part) then

        if not table.find(parts, part) then

            table.insert(parts, part)

        end

    end

end

local function removePart(part)

    local index = table.find(parts, part)

    if index then

        table.remove(parts, index)

    end

end

for _, part in pairs(Workspace:GetDescendants()) do

    addPart(part)

end

Workspace.DescendantAdded:Connect(addPart)

Workspace.DescendantRemoving:Connect(removePart)

RunService.Heartbeat:Connect(function()

    if not ringPartsEnabled then return end

    

    local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if humanoidRootPart then

        local tornadoCenter = humanoidRootPart.Position

        for _, part in pairs(parts) do

            if part.Parent and not part.Anchored then

                local pos = part.Position

                local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude

                local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)

                local newAngle = angle + math.rad(config.rotationSpeed)

                local targetPos = Vector3.new(

                    tornadoCenter.X + math.cos(newAngle) * math.min(config.radius, distance),

                    tornadoCenter.Y + (config.height * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / config.height)))),

                    tornadoCenter.Z + math.sin(newAngle) * math.min(config.radius, distance)

                )

                local directionToTarget = (targetPos - part.Position).unit

                part.Velocity = directionToTarget * config.attractionStrength

            end

        end

    end

end)

local Noclip = nil

local Clip = nil

function noclip()

    Clip = false

    local function Nocl()

        if Clip == false and LocalPlayer.Character ~= nil then

            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do

                if v:IsA('BasePart') and v.CanCollide then

                    v.CanCollide = false

                end

            end

        end

        wait(0.21)

    end

    Noclip = RunService.Stepped:Connect(Nocl)

end

function clip()

    if Noclip then Noclip:Disconnect() end

    Clip = true

end

local function nofalldamage(chr)

    local root = chr:WaitForChild("HumanoidRootPart")

    

    if root then

        local con

        con = RunService.Heartbeat:Connect(function()

            if not root.Parent then

                con:Disconnect()

            end

            

            local oldvel = root.AssemblyLinearVelocity

            root.AssemblyLinearVelocity = Vector3.zero

            

            RunService.RenderStepped:Wait()

            root.AssemblyLinearVelocity = oldvel

        end)

    end

end

nofalldamage(LocalPlayer.Character)

LocalPlayer.CharacterAdded:Connect(nofalldamage)

Tab1:AddToggle({

    Name = "黑洞",

    Description = "温馨提示:浮木怎么办？",

    Default = false,

    Callback = function(Value)

        ringPartsEnabled = Value

    end

})

Tab1:AddSlider({

    Name = "半径",

    Description = "",

    Min = 10,

    Max = 500,

    Increase = 10,

    Default = config.radius,

    Callback = function(Value)

        config.radius = Value

    end

})

Tab1:AddSlider({

    Name = "高度",

    Description = "",

    Min = 10,

    Max = 500,

    Increase = 10,

    Default = config.height,

    Callback = function(Value)

        config.height = Value

    end

})

Tab1:AddSlider({

    Name = "旋转速度",

    Description = "",

    Min = 1,

    Max = 50,

    Increase = 1,

    Default = config.rotationSpeed,

    Callback = function(Value)

        config.rotationSpeed = Value

    end

})

Tab1:AddSlider({

    Name = "吸引力强度",

    Description = "调太高会有bug",

    Min = 100,

    Max = 5000,

    Increase = 100,

    Default = config.attractionStrength,

    Callback = function(Value)

        config.attractionStrength = Value

    end

})

Tab1:AddToggle({

    Name = "穿墙",

    Description = "",

    Default = false,

    Callback = function(Value)

        if Value then

            noclip()

        else

            clip()

        end

    end

})

Tab1:AddToggle({

    Name = "无摔落伤害",

    Description = "",

    Default = true,

    Callback = function(Value)

        if Value then

            nofalldamage(LocalPlayer.Character)

        end

    end

})

local Dialog = Window:Dialog({

    Title = "提示",

    Text = "欢迎使用TX V2",

    Options = {

        {"确认", function()

        end},

        {"稍后", function()

        end},

        {"取消", function()

        end}

    }

})
