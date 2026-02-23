-- Headless + Korblox GUI with Toggles
-- Delta Executor Compatible
-- Client-side only

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

------------------ STATE ------------------
local applied = false
local noclip = false
local noclipConn

------------------ FUNCTIONS ------------------
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function applyHK()
    local char = getChar()

    -- Headless
    if char:FindFirstChild("Head") then
        char.Head.Transparency = 1
        for _,v in pairs(char.Head:GetChildren()) do
            if v:IsA("Decal") then
                v.Transparency = 1
            end
        end
    end

    -- Korblox (Right Leg)
    local leg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg")
    if leg then
        leg.Transparency = 1
    end

    applied = true
end

local function removeHK()
    local char = getChar()

    -- Head restore
    if char:FindFirstChild("Head") then
        char.Head.Transparency = 0
        for _,v in pairs(char.Head:GetChildren()) do
            if v:IsA("Decal") then
                v.Transparency = 0
            end
        end
    end

    -- Leg restore
    local leg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg")
    if leg then
        leg.Transparency = 0
    end

    applied = false
end

local function toggleNoclip()
    noclip = not noclip

    if noclip then
        noclipConn = RunService.Stepped:Connect(function()
            local char = getChar()
            for _,v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end
end

------------------ GUI ------------------
local gui = Instance.new("ScreenGui")
gui.Name = "HK_GUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 210)
frame.Position = UDim2.new(0.5, -130, 0.5, -105)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local function makeButton(text, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
end

------------------ BUTTONS ------------------
makeButton("Spawn Toggle (Headless + Korblox)", 10, function()
    if applied then
        removeHK()
    else
        applyHK()
    end
end)

makeButton("Remove Toggle (Restore Normal)", 55, function()
    removeHK()
end)

makeButton("Noclip Toggle", 100, function()
    toggleNoclip()
end)

makeButton("Remove GUI", 145, function()
    if noclip then toggleNoclip() end
    gui:Destroy()
end)

------------------ RESPAWN FIX ------------------
player.CharacterAdded:Connect(function()
    if applied then
