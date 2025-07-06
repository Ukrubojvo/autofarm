if game.PlaceId ~= 15223594893 then return warn("여긴 고속도로 운전 한국 베타 가 아닌데요? (고속도로 겜 오토팜.lua)") end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Vim = game:GetService("VirtualInputManager")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local initialCFrame = CFrame.new(
    10271.0547, 4.09999275, 11605.165,
    0.00291144126, -4.99035266e-08, 0.999995768,
    1.02775218e-07, 1, 4.96045125e-08,
   -0.999995768, 1.02630359e-07, 0.00291144126
)

local function waitFor(seconds)
    local t = tick()
    repeat RunService.Heartbeat:Wait() until tick() - t >= seconds
end

local function sendKeyHold(keyCode, duration)
    Vim:SendKeyEvent(true, keyCode, false, game)
    waitFor(duration)
    Vim:SendKeyEvent(false, keyCode, false, game)
end
pcall(function()
	workspace["배달 의뢰"]["배달 의뢰 받는 발판"].ProximityPrompt.RequiresLineOfSight = false
end)
task.spawn(function()
    while true do
        for _, model in ipairs(workspace:GetChildren()) do
            if model:IsA("Model") then
                for _, descendant in ipairs(model:GetDescendants()) do
                    if descendant:IsA("VehicleSeat") then
                        model:Destroy()
                        break
                    end
                end
            end
        end
        wait(0.5)
    end
end)

while true do
    hrp.CFrame = initialCFrame
    waitFor(0.5)

    sendKeyHold(Enum.KeyCode.Q, 3)

    waitFor(18)

	for i=0, 10 do
		Vim:SendMouseButtonEvent(961,691, 0, true, game, 0)
		Vim:SendMouseButtonEvent(961,691, 0, false, game, 0)
		task.wait(0.1)
	end

	waitFor(1)
    sendKeyHold(Enum.KeyCode.One, 0.1)
    local folder = workspace:FindFirstChild("캐릭터 폴더")
    local moved = false

    if folder then
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and not CollectionService:HasTag(model, "TargetCharacter") then
                hrp.CFrame = model.HumanoidRootPart.CFrame
                moved = true

                CollectionService:AddTag(model, "TargetCharacter")

                task.delay(60, function()
                    if model and model.Parent then
                        CollectionService:RemoveTag(model, "TargetCharacter")
                    end
                end)

				waitFor(1)
            end
        end
    end

    waitFor(1)
	for i=0, 10 do
		Vim:SendMouseButtonEvent(961,691, 0, true, game, 0)
		Vim:SendMouseButtonEvent(961,691, 0, false, game, 0)
		task.wait(0.1)
	end
end
