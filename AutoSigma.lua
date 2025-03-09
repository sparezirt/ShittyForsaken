task.wait(5)
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMinisterq/Notification-Library/Main/Library.lua"))()

local function findGenerators()
    NotificationLibrary:SendNotification("Info", "i look for generators", 2)
    local folder = workspace:WaitForChild("Map") and workspace.Map:WaitForChild("Ingame")
    local map = folder and folder:WaitForChild("Map")
    local generators = {}
    if map then
        for _, g in ipairs(map:GetChildren()) do
            if g.Name == "Generator" and g.Progress.Value < 100 then
                table.insert(generators, g)
            end
        end
    end
    return generators
end

local function TpDoGenerator()
    NotificationLibrary:SendNotification("Info", "okay bbg il look for the generators when the game starts 🙄🙄", 3)
    local lastPosition = Players.LocalPlayer.Character and Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") and Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    while true do
        local generators = findGenerators()
        if #generators == 0 then
            NotificationLibrary:SendNotification("Info", "I think they done 🤔🤔", 3)
            task.wait(3)
            if #findGenerators() == 0 then
                NotificationLibrary:SendNotification("Success", "I double checked, they are done.", 3)
                return true
            end
        end

        for _, g in ipairs(generators) do
            local player = game.Players.LocalPlayer
            if player.Character.Parent.Name == "Spectating" or player.Character.Parent.Name == "Killers"  then return true end
            local generatorPosition = g.Instances.Generator.Progress.CFrame.Position
            local generatorDirection = (g.Instances.Generator.Cube.CFrame.Position - generatorPosition).Unit
            player.Character.HumanoidRootPart.CFrame = CFrame.new(generatorPosition + Vector3.new(0, 0.5, 0), generatorPosition + Vector3.new(generatorDirection.X, 0, generatorDirection.Z))
            task.wait(0.3)
            fireproximityprompt(g.Main:WaitForChild("Prompt", 1))
            task.wait((0.1))
            for _ = 1, 6 do
                task.wait(0.05)
                g.Remotes.RE:FireServer()
            end
            task.wait(0.1)
            g.Remotes.RF:InvokeServer("leave")
            NotificationLibrary:SendNotification("Success", "Generator done!!!", 2.5)
        end
    end
    if lastPosition then
        Players.LocalPlayer.Character.HumanoidRootPart.CFrame = lastPosition
    end
    return true
end

local function teleportToRandomServer()
    local Counter = 0
    local MaxRetry = 10
    local RetryingDelays = 10

    NotificationLibrary:SendNotification("Info", "I get servers", 2.5)
    local Request = http_request or syn.request or request
    if Request then
        local url = "https://games.roblox.com/v1/games/18687417158/servers/Public?sortOrder=Asc&limit=100"

        while Counter < MaxRetry do
            local success, response = pcall(function()
                return Request({
                    Url = url,
                    Method = "GET",
                    Headers = { ["Content-Type"] = "application/json" }
                })
            end)

            if success and response and response.Body then
                local data = HttpService:JSONDecode(response.Body)
                if data and data.data and #data.data > 0 then
                    local server = data.data[math.random(1, #data.data)]
                    if server.id then
                        NotificationLibrary:SendNotification("Info", "I go to new server 🥺", 5)
                        TeleportService:TeleportToPlaceInstance(18687417158, server.id, Players.LocalPlayer)
                        return
                    end
                end
            end

            Counter = Counter + 1
            NotificationLibrary:SendNotification("Error", "i retry (" .. Counter .. "/" .. MaxRetry .. ")...", 10)
            task.wait(RetryingDelays)
        end

        NotificationLibrary:SendNotification("Error", "i give up 😭😭😭", 120)
    end
end


local function Main()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local roundTimer = playerGui and playerGui:WaitForChild("RoundTimer")
    local main = roundTimer and roundTimer:WaitForChild("Main")
    local title = main and main:WaitForChild("Title")
    if title.Text == "Round ends in:" then
        NotificationLibrary:SendNotification("Error", "this server sucks", 5)
        local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
        if queueteleport then
                queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/ivannetta/ShitScripts/refs/heads/main/AutoSigma.lua', true))()")
        end
        task.wait(5)
        while task.wait(5) do
            teleportToRandomServer()
        end

    elseif title.Text == "Waiting for more players." then
        NotificationLibrary:SendNotification("Error", "RAHHHHHHHHHHHHHHHHHHHHHHHHHHHH WHERE ALL THE PLAYERS AT 😡😡😡", 10)
        local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
        if queueteleport then
                queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/ivannetta/ShitScripts/refs/heads/main/AutoSigma.lua', true))()")
        end
        task.wait(5)
        while task.wait(5) do
            teleportToRandomServer()
        end

    else
        local generatorsDone = TpDoGenerator()
        if generatorsDone then
            local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
            if queueteleport then
                    queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/ivannetta/ShitScripts/refs/heads/main/AutoSigma.lua', true))()")
            end
			teleportToRandomServer()
            while task.wait(5) do
                teleportToRandomServer()
            end
        end
    end
end

Main()
