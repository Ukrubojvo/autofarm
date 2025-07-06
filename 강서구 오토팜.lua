if game.PlaceId ~= 105807454755941 then return warn("여긴 Gangseo-gu│강서구 가 아닌데요? (강서구 오토팜.lua)") end

local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local vim = game:GetService("VirtualInputManager")
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local player = players.LocalPlayer
local player_gui = player:WaitForChild("PlayerGui")

local is_running = false
local loop_thread = nil

local function wait_for(seconds)
	local t = tick()
	repeat run_service.Heartbeat:Wait() until tick() - t >= seconds
end

local function send_key_hold(keycode, duration)
	vim:SendKeyEvent(true, keycode, false, game)
	wait_for(duration)
	vim:SendKeyEvent(false, keycode, false, game)
end

local function teleport_to(position)
	local character = player.Character or player.CharacterAdded:Wait()
	local root_part = character:WaitForChild("HumanoidRootPart")
	root_part.CFrame = CFrame.new(position)
end

local function get_enabled_prompt_parts()
	local folder = workspace:WaitForChild("DeliveryMainFolder"):WaitForChild("arrivalPartFolder")
	local enabled_parts = {}

	for _, part in ipairs(folder:GetDescendants()) do
		if part:IsA("BasePart") then
			local prompt = part:FindFirstChildOfClass("ProximityPrompt")
			if prompt and prompt.Enabled then
				table.insert(enabled_parts, part)
			end
		end
	end

	return enabled_parts
end

local function start_loop()
	if loop_thread then return end

	is_running = true
	loop_thread = coroutine.create(function()
		while is_running do
			local current_position = camera.CFrame.Position
			local target_direction = Vector3.new(-0.17050354182720184, -0.9848077297210693, 0.03290054202079773)
			local target_position = current_position + target_direction

			camera.CFrame = CFrame.lookAt(current_position, target_position)
			teleport_to(Vector3.new(2215.6103515625, -37.727684020996094, -1192.7022705078125))
			send_key_hold(Enum.KeyCode.E, 3)

			local enabled_parts = get_enabled_prompt_parts()

			if #enabled_parts == 0 then
				wait_for(1)
			else
				for _, part in ipairs(enabled_parts) do
					if not is_running then break end
					teleport_to(part.Position + Vector3.new(0, 3, 0))
					wait_for(0.5)
					send_key_hold(Enum.KeyCode.E, 3)
				end
			end
		end
		loop_thread = nil
	end)
	coroutine.resume(loop_thread)
end

local function stop_loop()
	is_running = false
end

local screen_gui = Instance.new("ScreenGui", player_gui)
screen_gui.Name = "AutoDeliveryGui"
screen_gui.IgnoreGuiInset = true
screen_gui.ResetOnSpawn = false

local frame = Instance.new("Frame", screen_gui)
frame.Size = UDim2.new(0, 200, 0, 80)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 8)
local uistroke = Instance.new("UIStroke", frame)
uistroke.Thickness = 2
uistroke.Transparency = 0.8
uistroke.Color = Color3.fromRGB(0, 0, 0)

local start_button = Instance.new("TextButton", frame)
start_button.Size = UDim2.new(0, 80, 0, 40)
start_button.Position = UDim2.new(0, 10, 0, 20)
start_button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
start_button.Text = "시작"
start_button.TextColor3 = Color3.new(1, 1, 1)
start_button.Font = Enum.Font.SourceSansBold
start_button.TextScaled = true

local stop_button = Instance.new("TextButton", frame)
stop_button.Size = UDim2.new(0, 80, 0, 40)
stop_button.Position = UDim2.new(0, 110, 0, 20)
stop_button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stop_button.Text = "중지"
stop_button.TextColor3 = Color3.new(1, 1, 1)
stop_button.Font = Enum.Font.SourceSansBold
stop_button.TextScaled = true

start_button.MouseButton1Click:Connect(function()
	if not is_running then
		start_loop()
	end
end)

stop_button.MouseButton1Click:Connect(function()
	if is_running then
		stop_loop()
	end
end)
