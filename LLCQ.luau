local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({

    Title = "TX V2",

    SubTitle = "退休脚本",

    SaveFolder = "Redz"

})

print("TX")

local StartTime = tick()

local virtualUser = game:GetService("VirtualUser")

game:GetService("Players").LocalPlayer.Idled:Connect(function()

    virtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)

    wait(1)

    virtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)

end)

Window:AddMinimizeButton({

    Button = { Image = redzlib:GetIcon("rbxassetid://82031063194606"), BackgroundTransparency = 0, Size = UDim2.fromOffset(30, 30) },

    Corner = { CornerRadius = UDim.new(0, 10) }

})

local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")

local WorkoutTab = Window:MakeTab({"自动锻炼", "cool"})

local exerciseOptions = {"哑铃", "倒立", "仰卧起坐", "俯卧撑"}

local selectedExercise = ""

WorkoutTab:AddDropdown({

    Name = "锻炼方式",

    Options = exerciseOptions,

    Default = "...",

    Callback = function(Value)

        selectedExercise = Value

    end

})

_G.enableAutoWorkout = false

local lastWorkoutEquipTime = 0

local isWorkoutEquipped = false

spawn(function()

    while wait(1) do

        if _G.enableAutoWorkout then

            pcall(function()

                local player = Players.LocalPlayer

                local character = player.Character

                if character and character:FindFirstChild("Humanoid") then

                    player.muscleEvent:FireServer("rep")

                    local toolMap = {

                        ["哑铃"] = "Weight",

                       ["倒立"] = "Handstands",

                        ["仰卧起坐"] = "Situps",

                        ["俯卧撑"] = "Pushups"

                    }

                    local toolName = toolMap[selectedExercise]

                    if toolName and player.Backpack:FindFirstChild(toolName) then

                        local currentTime = tick()

                        if not isWorkoutEquipped and currentTime - lastWorkoutEquipTime >= 3 then

                            print("Attempting to equip: " .. toolName .. " at " .. currentTime)

                            character.Humanoid:EquipTool(player.Backpack[toolName])

                            isWorkoutEquipped = true

                            lastWorkoutEquipTime = currentTime

                        end

                    end

                end

            end)

        else

            pcall(function()

                local character = Players.LocalPlayer.Character

                if character and character:FindFirstChild("Humanoid") and isWorkoutEquipped then

                    character.Humanoid:UnequipTools()

                    isWorkoutEquipped = false

                    print("Unequipped workout tool")

                end

            end)

        end

    end

end)

WorkoutTab:AddToggle({ Name = "自动锻炼", Default = false, Callback = function(Value) _G.enableAutoWorkout = Value end })

local treadmillOptions = {"海滩", "冰霜", "神话", "永恒", "传说"}

local selectedTreadmill = ""

WorkoutTab:AddSection("跑步机")

WorkoutTab:AddDropdown({

    Name = "跑步机类型",

    Options = treadmillOptions,

    Default = "...",

    Callback = function(Value)

        selectedTreadmill = Value

    end

})

_G.enableAutoSpeed = false

spawn(function()

    while wait(1) do

        if _G.enableAutoSpeed then

            pcall(function()

                ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSpeed", 2)

            end)

        end

    end

end)

WorkoutTab:AddToggle({ Name = "自动设置速度", Default = false, Callback = function(Value) _G.enableAutoSpeed = Value end })

_G.enableAutoRun = false

local treadmillPositions = {

    ["海滩"] = { pos = CFrame.new(238.671112, 5.40315914, 387.713165), agility = 0 },

    ["冰霜"] = { pos = CFrame.new(-3005.37866, 14.3221855, -464.697876), agility = 2000 },

    ["神话"] = { pos = CFrame.new(2571.23706, 15.6896839, 898.650391), agility = 2000 },

    ["永恒"] = { pos = CFrame.new(-7077.79102, 29.6702118, -1457.59961), agility = 3500 },

    ["传说"] = { pos = CFrame.new(4370.82812, 999.358704, -3621.42773), agility = 3000 }

}

spawn(function()

    RunService:BindToRenderStep("autorun", Enum.RenderPriority.Character.Value + 1, function()

        if _G.enableAutoRun then

            pcall(function()

                local player = Players.LocalPlayer

                local character = player.Character

                if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then

                    local data = treadmillPositions[selectedTreadmill]

                    if data and player.Agility.Value >= data.agility then

                        character.Humanoid.WalkSpeed = 10

                        character.HumanoidRootPart.CFrame = data.pos

                        character.Humanoid:Move(Vector3.new(10000, 0, -1), true)

                    end

                end

            end)

        end

    end)

end)

WorkoutTab:AddToggle({ Name = "自动跑步", Default = false, Callback = function(Value) _G.enableAutoRun = Value end })

local RebirthTab = Window:MakeTab({"重生功能", "cool"})

_G.enableAutoRebirth = false

spawn(function()

    while wait(1) do

        if _G.enableAutoRebirth then

            pcall(function()

                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")

            end)

        end

    end

end)

RebirthTab:AddToggle({ Name = "自动重生", Default = false, Callback = function(Value) _G.enableAutoRebirth = Value end })

local PetHackTab = Window:MakeTab({"卡宠功能", "cool"})

PetHackTab:AddTextBox({

    Title = "挥拳速度",

    Default = "1",

    PlaceholderText = "输入",

    ClearText = false,

    Callback = function(Value)

        pcall(function()

            local punchTool = Players.LocalPlayer.Backpack:FindFirstChild("Punch")

            if punchTool then

                punchTool:FindFirstChildOfClass("NumberValue").Value = tonumber(Value) or 1

            end

        end)

    end

})

local rockOptions = {"小石头", "中石头", "大石头", "沙滩石头", "蓝石头", "紫石头", "橙石头", "白石头", "绿石头"}

local selectedRock = ""

local rockStrength = ""

PetHackTab:AddDropdown({

    Name = "选择石头",

    Options = rockOptions,

    Default = "...",

    Callback = function(Value)

        selectedRock = Value

        local strengthMap = {

            ["小石头"] = "0", ["中石头"] = "10", ["大石头"] = "100", ["沙滩石头"] = "5k",

            ["蓝石头"] = "150k", ["紫石头"] = "400k", ["橙石头"] = "750k", ["白石头"] = "1m", ["绿石头"] = "5m"

        }

        rockStrength = strengthMap[selectedRock] or ""

    end

})

PetHackTab:AddSection("传送打石头")

_G.enableRockPunch = false

local lastRockPunchTime = 0

local isRockPunchEquipped = false

spawn(function()

    while wait(1) do

        if _G.enableRockPunch then

            pcall(function()

                local player = Players.LocalPlayer

                local character = player.Character

                if character and character:FindFirstChild("Humanoid") then

                    local punchTool = player.Backpack:FindFirstChild("Punch")

                    if punchTool then

                        local currentTime = tick()

                        if not isRockPunchEquipped and currentTime - lastRockPunchTime >= 3 then

                            print("Attempting to equip Punch for rock: " .. selectedRock .. " at " .. currentTime)

                            character.Humanoid:EquipTool(punchTool)

                            punchTool:Activate()

                            isRockPunchEquipped = true

                            lastRockPunchTime = currentTime

                        end

                    end

                    local rockPositions = {

                        ["小石头"] = { pos = CFrame.new(7.60643005, 4.02632904, 2104.54004), durability = 0 },

                        ["中石头"] = { pos = CFrame.new(-157.680908, 3.72453046, 434.871185), durability = 10 },

                        ["大石头"] = { pos = CFrame.new(162.233673, 3.66615629, -164.686783), durability = 100 },

                        ["沙滩石头"] = { pos = CFrame.new(329.831482, 3.66450214, -618.48407), durability = 5000 },

                        ["蓝石头"] = { pos = CFrame.new(-2566.78076, 3.97019577, -277.503235), durability = 150000 },

                        ["紫石头"] = { pos = CFrame.new(2155.61743, 3.79830337, 1227.06482), durability = 400000 },

                        ["橙石头"] = { pos = CFrame.new(-7285.6499, 3.66624784, -1228.27417), durability = 750000 },

                        ["白石头"] = { pos = CFrame.new(4160.87109, 987.829102, -4136.64502), durability = 1000000 },

                        ["绿石头"] = { pos = CFrame.new(-8957.54395, 5.53625107, -6126.90186), durability = 5000000 }

                    }

                    local data = rockPositions[selectedRock]

                    if data and player.Durability.Value >= data.durability then

                        character.HumanoidRootPart.CFrame = data.pos

                    end

                end

            end)

        else

            pcall(function()

                local character = Players.LocalPlayer.Character

                if character and character:FindFirstChild("Humanoid") and isRockPunchEquipped then

                    character.Humanoid:UnequipTools()

                    isRockPunchEquipped = false

                    print("Unequipped rock punch tool")

                end

            end)

        end

    end

end)

PetHackTab:AddToggle({ Name = "自动打石头", Default = false, Callback = function(Value) _G.enableRockPunch = Value end })

PetHackTab:AddSection("隔空打石头")

PetHackTab:AddSection("隔空只有绿、白、橙、蓝石头有效")

_G.enableRemoteRockPunch = false

spawn(function()

    while wait(1) do

        if _G.enableRemoteRockPunch then

            pcall(function()

                local character = Players.LocalPlayer.Character

                if character and character:FindFirstChild("LeftHand") then

                    local leftHand = character.LeftHand

                    local rockMap = {

                        ["蓝石头"] = "Frozen Rock",

                        ["橙石头"] = "Inferno Rock",

                        ["白石头"] = "Rock Of Legends",

                        ["绿石头"] = "Muscle King Mountain"

                    }

                    local rockName = rockMap[selectedRock]

                    if rockName and workspace.machinesFolder:FindFirstChild(rockName) then

                        local rock = workspace.machinesFolder[rockName].Rock

                        firetouchinterest(rock, leftHand, 0)

                        wait(0.01)

                        firetouchinterest(rock, leftHand, 1)

                    end

                end

            end)

        end

    end

end)

PetHackTab:AddToggle({ Name = "打石头", Default = false, Callback = function(Value) _G.enableRemoteRockPunch = Value end })

_G.enableAutoPunch = false

local lastPunchTime = 0

local isPunchEquipped = false

spawn(function()

    while true do

        if _G.enableAutoPunch then

            pcall(function()

                local player = Players.LocalPlayer

                local character = player.Character

                if character and character:FindFirstChild("Humanoid") then

                    local currentTime = tick()

                    if currentTime - lastPunchTime >= 0.5 then

                        local punchTool = player.Backpack:FindFirstChild("Punch") or (character and character:FindFirstChild("Punch"))

                        if punchTool then

                            if not isPunchEquipped then

                                character.Humanoid:EquipTool(punchTool)

                                isPunchEquipped = true

                            end

                            player.muscleEvent:FireServer("punch", "leftHand")

                            punchTool:Activate()

                            lastPunchTime = currentTime

                        end

                    end

                end

            end)

        else

            pcall(function()

                local character = Players.LocalPlayer.Character

                if character and character:FindFirstChild("Humanoid") and isPunchEquipped then

                    local punchTool = character:FindFirstChild("Punch")

                    if punchTool then

                        character.Humanoid:UnequipTools()

                        wait(0.1)

                        character.Humanoid:EquipTool(player.Backpack:FindFirstChild("Punch"))

                    end

                    isPunchEquipped = false

                end

            end)

        end

        wait(0.05)

    end

end)

PetHackTab:AddToggle({ Name = "自动挥拳", Default = false, Callback = function(Value) _G.enableAutoPunch = Value end })

local KillTab = Window:MakeTab({"业报击杀", "cool"})

local killOptions = {"隔空打人", "全图吸人"}

local selectedKillMethod = ""

KillTab:AddDropdown({

    Name = "选择方式",

    Options = killOptions,

    Default = "...",

    Callback = function(Value)

        selectedKillMethod = Value

    end

})

local function touchHead(player)

    pcall(function()

        local character = player.Character

        if character and character:FindFirstChild("Head") then

            local head = character.Head

            local localPlayer = Players.LocalPlayer

            local leftHand = localPlayer.Character and localPlayer.Character:FindFirstChild("LeftHand")

            if head and leftHand then

                firetouchinterest(head, leftHand, 0)

                wait(0.01)

                firetouchinterest(head, leftHand, 1)

            end

        end

    end)

end

_G.enableMassPull = false

spawn(function()

    while wait(1) do

        if _G.enableMassPull then

            pcall(function()

                local localCharacter = Players.LocalPlayer.Character

                if localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") then

                    for _, player in ipairs(Players:GetChildren()) do

                        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then

                            player.Character.HumanoidRootPart.CFrame = localCharacter.HumanoidRootPart.CFrame + localCharacter.HumanoidRootPart.CFrame.lookVector * 1

                        end

                    end

                end

            end)

        end

    end

end)

_G.enableAutoKill = false

spawn(function()

    while wait(0.1) do

        if _G.enableAutoKill and selectedKillMethod == "隔空打人" then

            pcall(function()

                for _, player in ipairs(Players:GetPlayers()) do

                    if player ~= Players.LocalPlayer then

                        touchHead(player)

                    end

                end

            end)

        end

    end

end)

KillTab:AddToggle({

    Name = "自动击杀",

    Default = false,

    Callback = function(Value)

        if selectedKillMethod == "隔空打人" then

            _G.enableAutoKill = Value

        elseif selectedKillMethod == "全图吸人" then

            _G.enableMassPull = Value

        end

    end

})

KillTab:AddSection("锁杀")

local lockedPlayers = {}

local function updatePlayerList()

    local playerNames = {"..."}

    for _, player in ipairs(Players:GetPlayers()) do

        if player ~= Players.LocalPlayer then

            table.insert(playerNames, player.Name)

        end

    end

    return playerNames

end

local lockedDropdown = KillTab:AddDropdown({

    Name = "锁定玩家",

    Description = "选择要锁定的玩家",

    Options = updatePlayerList(),

    Default = "...",

    Callback = function(Value)

        lockedPlayers = {}

        if Value ~= "..." then

            table.insert(lockedPlayers, Value)

        end

    end

})

local function refreshDropdown()

    pcall(function()

        lockedDropdown:ClearOptions()

        local newOptions = updatePlayerList()

        for _, option in ipairs(newOptions) do

            lockedDropdown:AddOption(option)

        end

    end)

end

KillTab:AddButton({

    Name = "刷新玩家列表",

    Callback = refreshDropdown

})

Players.PlayerAdded:Connect(refreshDropdown)

Players.PlayerRemoving:Connect(refreshDropdown)

local function isLocked(player)

    return table.find(lockedPlayers, player.Name) ~= nil

end

local function touchLockedHead(player)

    pcall(function()

        local character = player.Character

        if character and isLocked(player) and character:FindFirstChild("Head") then

            local head = character.Head

            local localPlayer = Players.LocalPlayer

            local leftHand = localPlayer.Character and localPlayer.Character:FindFirstChild("LeftHand")

            if head and leftHand then

                firetouchinterest(head, leftHand, 0)

                wait(0.01)

                firetouchinterest(head, leftHand, 1)

            end

        end

    end)

end

local PetShopTab = Window:MakeTab({"宠物商店", "cool"})

local petOptions = {"暗星", "赛博龙", "肌肉之王", "守护者", "力量师傅", "熵爆"}

local selectedPet = ""

local petCode = ""

PetShopTab:AddDropdown({

    Name = "光环与宠物",

    Description = "容量满了会导致无法购买",

    Options = petOptions,

    Default = "",

    Callback = function(Value)

        selectedPet = Value

        local petMap = {

            ["暗星"] = "Darkstar Hunter", ["赛博龙"] = "Cybernetic Showdown Dragon", ["肌肉之王"] = "Muscle King",

            ["守护者"] = "Neon Guardian", ["力量师傅"] = "Muscle Sensei", ["熵爆"] = "Entropic Blast"

        }

        petCode = petMap[selectedPet] or ""

    end

})

_G.enableAutoBuyPet = false

spawn(function()

    while wait(1) do

        if _G.enableAutoBuyPet and petCode ~= "" then

            pcall(function()

                ReplicatedStorage.cPetShopRemote:InvokeServer(ReplicatedStorage.cPetShopFolder:FindFirstChild(petCode))

            end)

        end

    end

end)

PetShopTab:AddToggle({ Name = "自动购买", Default = false, Callback = function(Value) _G.enableAutoBuyPet = Value end })
