-- Korblox + Headless (VISUAL ONLY)
-- Delta Executor Compatible

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function apply()
    local char = player.Character or player.CharacterAdded:Wait()

    -- Headless (fake)
    if char:FindFirstChild("Head") then
        char.Head.Transparency = 1
        for _, v in pairs(char.Head:GetChildren()) do
            if v:IsA("Decal") then
                v:Destroy()
            end
        end
    end

    -- Korblox leg (fake)
    local leg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg")
    if leg then
        leg.Transparency = 1
    end
end

player.CharacterAdded:Connect(function()
    task.wait(1)
    apply()
end)

apply()
