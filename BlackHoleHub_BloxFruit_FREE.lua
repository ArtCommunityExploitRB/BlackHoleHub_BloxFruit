-- [[ 🌌 BLACK HOLE HUB | ArtSquadFive | THE ULTIMATE PROGRESSION 🌌 ]]
-- Версия 4.9 – Полный код с исправлениями

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Drawing = (getgenv and getgenv().Drawing) or Drawing

local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("BlackHoleHub") then CoreGui.BlackHoleHub:Destroy() end

-- ГЛОБАЛЬНЫЕ НАСТРОЙКИ
local _G = {
    AutoFarmLevel = false,
    KillAuraRadius = false,
    BossFarmTarget = nil,
    BossFarmEnabled = false,
    FarmDistance = 12,
    FarmSpeed = 250,
    AttackSide = "Сверху",
    SpamSkills = true,
    SelectedWeapon = nil,
    CurrentRunningNPC = nil,
    AutoHaki = true,
    AutoInstinct = true,
    InstinctCooldown = false,
    FruitESPEnabled = false,
    AutoChestSteal = false,
    Noclip = false,
    InfJump = false,
    WalkSpeedEnabled = false,
    WalkSpeed = 16,
    JumpPowerEnabled = false,
    JumpPower = 50,
    FlyEnabled = false,
    FlySpeed = 50,
    Collapsed = false,
    ClickInterval = 25,
    SeaBeastFarm = false,
    SeaBeastFlySpeed = 180,
    SeaBeastHoverHeight = 65,
    SeaBeastTarget = nil,
    LeviathanFarm = false,
    TerrorsharkFarm = false,
    HydraFarm = false,
    GhostShipFarm = false,
    PiranhaFarm = false,
    SeaEventFlySpeed = 220,
    SeaEventHoverHeight = 85,
    FullBrightEnabled = false,
    GUIOpen = false,
    AccentColor = Color3.fromRGB(255, 140, 0),
    Theme = "Оранжевая",
}

-- Таблица тем
local Themes = {
    ["Оранжевая"] = Color3.fromRGB(255, 140, 0),
    ["Красная"] = Color3.fromRGB(255, 50, 50),
    ["Синяя"] = Color3.fromRGB(50, 150, 255),
    ["Зеленая"] = Color3.fromRGB(50, 255, 100),
    ["Фиолетовая"] = Color3.fromRGB(180, 80, 255),
    ["Розовая"] = Color3.fromRGB(255, 100, 200),
    ["Желтая"] = Color3.fromRGB(255, 255, 50),
    ["Белая"] = Color3.fromRGB(255, 255, 255),
    ["Циан"] = Color3.fromRGB(0, 255, 255),
    ["Лайм"] = Color3.fromRGB(180, 255, 0),
}

local WeaponsList = {}
local collectedFruits = {}
local currentSkillIndex = 1
local lastSkillTime = 0
local skillKeys = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}
local currentTarget = nil
local clickCounter = 0

-- СПИСОК БОССОВ
local BossList = {
    "The Gorilla King", "Chef", "The Saw", "Yeti", "Mob Leader",
    "Vice Admiral", "Saber Expert", "Warden", "Chief Warden", "Swan",
    "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg",
    "Ice Admiral", "Greybeard", "Diamond", "Jeremy", "Orbitus",
    "Don Swan", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper",
    "Cursed Captain", "Darkbeard", "Order", "rip_indra", "Stone",
    "Hydra Leader", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate",
    "Longma", "Cursed Skeleton Boss", "Cake Queen", "Heaven's Guardian",
    "Dough King", "Cake Prince", "Soul Reaper", "Sea Beast",
    "Terrorshark", "Leviathan", "Tyrant of the Skies", "Core"
}

-- КООРДИНАТЫ СПАВНА БОССОВ
local BossSpawnLocations = {
    ["The Gorilla King"] = Vector3.new(-1613, 37, 149),
    ["Chef"] = Vector3.new(-1181, 5, 3804),
    ["The Saw"] = Vector3.new(-690, 15, 1582),
    ["Yeti"] = Vector3.new(1348, 105, -1320),
    ["Mob Leader"] = Vector3.new(-2566, 7, 2045),
    ["Vice Admiral"] = Vector3.new(-4915, 51, 4281),
    ["Saber Expert"] = Vector3.new(-4869, 733, -2667),
    ["Warden"] = Vector3.new(4875, 6, 735),
    ["Chief Warden"] = Vector3.new(4875, 6, 735),
    ["Swan"] = Vector3.new(4875, 6, 735),
    ["Magma Admiral"] = Vector3.new(-5248, 13, 8505),
    ["Fishman Lord"] = Vector3.new(61164, 12, 1820),
    ["Wysper"] = Vector3.new(-4869, 733, -2667),
    ["Thunder God"] = Vector3.new(-4869, 733, -2667),
    ["Cyborg"] = Vector3.new(5127, 60, 4105),
    ["Ice Admiral"] = Vector3.new(5455, 28, -6218),
    ["Greybeard"] = Vector3.new(-3054, 240, -10175),
    ["Diamond"] = Vector3.new(-1428, 7, -2793),
    ["Jeremy"] = Vector3.new(-3054, 240, -10175),
    ["Orbitus"] = Vector3.new(-3054, 240, -10175),
    ["Don Swan"] = Vector3.new(-3054, 240, -10175),
    ["Smoke Admiral"] = Vector3.new(-6024, 15, -4900),
    ["Awakened Ice Admiral"] = Vector3.new(5455, 28, -6218),
    ["Tide Keeper"] = Vector3.new(-3054, 240, -10175),
    ["Cursed Captain"] = Vector3.new(923, 126, 32852),
    ["Darkbeard"] = Vector3.new(-3054, 240, -10175),
    ["Order"] = Vector3.new(-5036, 315, -3179),
    ["rip_indra"] = Vector3.new(-12462, 375, -7552),
    ["Stone"] = Vector3.new(-290, 44, 5455),
    ["Hydra Leader"] = Vector3.new(5658, 1013, -335),
    ["Kilo Admiral"] = Vector3.new(5658, 1013, -335),
    ["Captain Elephant"] = Vector3.new(-16219, 9, 446),
    ["Beautiful Pirate"] = Vector3.new(-16219, 9, 446),
    ["Longma"] = Vector3.new(-16219, 9, 446),
    ["Cursed Skeleton Boss"] = Vector3.new(-9515, 164, 5786),
    ["Cake Queen"] = Vector3.new(-2080, 70, -12300),
    ["Heaven's Guardian"] = Vector3.new(-2080, 70, -12300),
    ["Dough King"] = Vector3.new(-2080, 70, -12300),
    ["Cake Prince"] = Vector3.new(-2080, 70, -12300),
    ["Soul Reaper"] = Vector3.new(-2080, 70, -12300),
    ["Sea Beast"] = Vector3.new(0, 0, 0),
    ["Terrorshark"] = Vector3.new(0, 0, 0),
    ["Leviathan"] = Vector3.new(0, 0, 0),
    ["Tyrant of the Skies"] = Vector3.new(0, 0, 0),
    ["Core"] = Vector3.new(0, 0, 0),
}

-- Таблица локаций (оставлена для возможного использования, но интерфейс телепортов удалён)
local TeleportLocations = {
    ["Sea 1"] = {
        {"Pirate Starter", -1057, 15, 1550},
        {"Marine Starter", -2566, 7, 2045},
        {"Middle Town", -690, 15, 1582},
        {"Jungle", -1613, 37, 149},
        {"Pirate Village", -1181, 5, 3804},
        {"Desert", 944, 21, 4373},
        {"Frozen Village", 1348, 105, -1320},
        {"Marine Fortress", -4915, 51, 4281},
        {"Skylands", -4869, 733, -2667},
        {"Prison", 4875, 6, 735},
        {"Colosseum", -1428, 7, -2793},
        {"Magma Village", -5248, 13, 8505},
        {"Underwater City", 61164, 12, 1820},
        {"Fountain City", 5127, 60, 4105}
    },
    ["Sea 2"] = {
        {"Kingdom of Rose", -394, 73, 296},
        {"Café", -382, 73, 297},
        {"Green Zone", -2448, 73, -3210},
        {"Graveyard", -5495, 48, -794},
        {"Snow Mountain", 562, 401, -5297},
        {"Hot & Cold", -6024, 15, -4900},
        {"Cursed Ship", 923, 126, 32852},
        {"Ice Castle", 5455, 28, -6218},
        {"Forgotten Island", -3054, 240, -10175}
    },
    ["Sea 3"] = {
        {"Port Town", -290, 44, 5455},
        {"Hydra Island", 5658, 1013, -335},
        {"Great Tree", 2680, 1682, -7190},
        {"Floating Turtle", -12462, 375, -7552},
        {"Castle on the Sea", -5036, 315, -3179},
        {"Haunted Castle", -9515, 164, 5786},
        {"Sea of Treats", -2080, 70, -12300},
        {"Tiki Outpost", -16219, 9, 446}
    }
}

------------------------------------------------------------------------
-- ТАБЛИЦА КВЕСТОВ (полная) – ГЛОБАЛЬНАЯ
------------------------------------------------------------------------
MainQuestTable = {
    BanditQuest1 = { { LevelReq = 0, Name = "Bandits", Task = { ["Bandit"] = 5 } } },
    MarineQuest = { { LevelReq = 0, Name = "Trainees", Task = { ["Trainee"] = 5 } } },
    JungleQuest = { { LevelReq = 10, Name = "Monkeys", Task = { ["Monkey"] = 6 } }, { LevelReq = 15, Name = "Gorillas", Task = { ["Gorilla"] = 8 } }, { LevelReq = 20, Name = "Gorilla King", Task = { ["The Gorilla King"] = 1 } } },
    BuggyQuest1 = { { LevelReq = 30, Name = "Pirates", Task = { ["Pirate"] = 8 } }, { LevelReq = 40, Name = "Brute", Task = { ["Brute"] = 8 } }, { LevelReq = 55, Name = "Chef", Task = { ["Chef"] = 1 } } },
    DesertQuest = { { LevelReq = 60, Name = "Desert Bandit", Task = { ["Desert Bandit"] = 8 } }, { LevelReq = 75, Name = "Desert Officer", Task = { ["Desert Officer"] = 6 } } },
    SnowQuest = { { LevelReq = 90, Name = "Snow Bandit", Task = { ["Snow Bandit"] = 7 } }, { LevelReq = 100, Name = "Snowman", Task = { ["Snowman"] = 8 } }, { LevelReq = 105, Name = "Yeti", Task = { ["Yeti"] = 1 } } },
    MarineQuest2 = { { LevelReq = 120, Name = "Chief Petty Officer", Task = { ["Chief Petty Officer"] = 8 } }, { LevelReq = 130, Name = "Vice Admiral", Task = { ["Vice Admiral"] = 1 } } },
    SkyQuest = { { LevelReq = 150, Name = "Sky Bandit", Task = { ["Sky Bandit"] = 7 } }, { LevelReq = 175, Name = "Dark Master", Task = { ["Dark Master"] = 8 } } },
    PrisonerQuest = { { LevelReq = 190, Name = "Prisoner", Task = { ["Prisoner"] = 8 } }, { LevelReq = 210, Name = "Dangerous Prisoner", Task = { ["Dangerous Prisoner"] = 8 } } },
    ImpelQuest = { { LevelReq = 220, Name = "Warden", Task = { ["Warden"] = 1 } }, { LevelReq = 230, Name = "Chief Warden", Task = { ["Chief Warden"] = 1 } }, { LevelReq = 240, Name = "Swan", Task = { ["Swan"] = 1 } } },
    ColosseumQuest = { { LevelReq = 250, Name = "Toga Warrior", Task = { ["Toga Warrior"] = 7 } }, { LevelReq = 275, Name = "Gladiator", Task = { ["Gladiator"] = 8 } } },
    MagmaQuest = { { LevelReq = 300, Name = "Mil. Soldier", Task = { ["Military Soldier"] = 7 } }, { LevelReq = 325, Name = "Mil. Spy", Task = { ["Military Spy"] = 8 } }, { LevelReq = 350, Name = "Magma Admiral", Task = { ["Magma Admiral"] = 1 } } },
    FishmanQuest = { { LevelReq = 375, Name = "Fishman Warrior", Task = { ["Fishman Warrior"] = 8 } }, { LevelReq = 400, Name = "Fishman Commando", Task = { ["Fishman Commando"] = 7 } }, { LevelReq = 425, Name = "Fishman Lord", Task = { ["Fishman Lord"] = 1 } } },
    SkyExp1Quest = { { LevelReq = 450, Name = "God's Guard", Task = { ["God's Guard"] = 7 } }, { LevelReq = 475, Name = "Shanda", Task = { ["Shanda"] = 9 } }, { LevelReq = 500, Name = "Wysper", Task = { ["Wysper"] = 1 } } },
    SkyExp2Quest = { { LevelReq = 525, Name = "Royal Squad", Task = { ["Royal Squad"] = 8 } }, { LevelReq = 550, Name = "Royal Soldier", Task = { ["Royal Soldier"] = 8 } }, { LevelReq = 575, Name = "Thunder God", Task = { ["Thunder God"] = 1 } } },
    FountainQuest = { { LevelReq = 625, Name = "Galley Pirate", Task = { ["Galley Pirate"] = 8 } }, { LevelReq = 650, Name = "Galley Captain", Task = { ["Galley Captain"] = 9 } }, { LevelReq = 675, Name = "Cyborg", Task = { ["Cyborg"] = 1 } } },
    Area1Quest = { { LevelReq = 700, Name = "Raider", Task = { ["Raider"] = 8 } }, { LevelReq = 725, Name = "Mercenary", Task = { ["Mercenary"] = 8 } }, { LevelReq = 750, Name = "Diamond", Task = { ["Diamond"] = 1 } } },
    Area2Quest = { { LevelReq = 775, Name = "Swan Pirate", Task = { ["Swan Pirate"] = 8 } }, { LevelReq = 800, Name = "Factory Staff", Task = { ["Factory Staff"] = 8 } }, { LevelReq = 850, Name = "Jeremy", Task = { ["Jeremy"] = 1 } } },
    MarineQuest3 = { { LevelReq = 875, Name = "Marine Lieutenant", Task = { ["Marine Lieutenant"] = 8 } }, { LevelReq = 900, Name = "Marine Captain", Task = { ["Marine Captain"] = 9 } }, { LevelReq = 925, Name = "Orbitus", Task = { ["Orbitus"] = 1 } } },
    ZombieQuest = { { LevelReq = 950, Name = "Zombie", Task = { ["Zombie"] = 8 } }, { LevelReq = 975, Name = "Vampire", Task = { ["Vampire"] = 8 } } },
    SnowMountainQuest = { { LevelReq = 1000, Name = "Snow Trooper", Task = { ["Snow Trooper"] = 8 } }, { LevelReq = 1050, Name = "Winter Warrior", Task = { ["Winter Warrior"] = 9 } } },
    IceSideQuest = { { LevelReq = 1100, Name = "Lab Subordinate", Task = { ["Lab Subordinate"] = 8 } }, { LevelReq = 1125, Name = "Horned Warrior", Task = { ["Horned Warrior"] = 9 } }, { LevelReq = 1150, Name = "Smoke Admiral", Task = { ["Smoke Admiral"] = 1 } } },
    FireSideQuest = { { LevelReq = 1175, Name = "Magma Ninja", Task = { ["Magma Ninja"] = 8 } }, { LevelReq = 1200, Name = "Lava Pirate", Task = { ["Lava Pirate"] = 8 } } },
    ShipQuest1 = { { LevelReq = 1250, Name = "Ship Deckhand", Task = { ["Ship Deckhand"] = 8 } }, { LevelReq = 1275, Name = "Ship Engineer", Task = { ["Ship Engineer"] = 8 } } },
    ShipQuest2 = { { LevelReq = 1300, Name = "Ship Steward", Task = { ["Ship Steward"] = 8 } }, { LevelReq = 1325, Name = "Ship Officer", Task = { ["Ship Officer"] = 8 } } },
    FrostQuest = { { LevelReq = 1350, Name = "Arctic Warrior", Task = { ["Arctic Warrior"] = 8 } }, { LevelReq = 1375, Name = "Snow Lurker", Task = { ["Snow Lurker"] = 8 } }, { LevelReq = 1400, Name = "Ice Admiral", Task = { ["Awakened Ice Admiral"] = 1 } } },
    ForgottenQuest = { { LevelReq = 1425, Name = "Sea Soldier", Task = { ["Sea Soldier"] = 8 } }, { LevelReq = 1450, Name = "Water Fighter", Task = { ["Water Fighter"] = 8 } }, { LevelReq = 1475, Name = "Tide Keeper", Task = { ["Tide Keeper"] = 1 } } },
    PiratePortQuest = { { LevelReq = 1500, Name = "Pirate Millionaire", Task = { ["Pirate Millionaire"] = 8 } }, { LevelReq = 1525, Name = "Pistol Billionaire", Task = { ["Pistol Billionaire"] = 8 } }, { LevelReq = 1550, Name = "Stone", Task = { ["Stone"] = 1 } } },
    DragonCrewQuest = { { LevelReq = 1575, Name = "Dragon Crew Warrior", Task = { ["Dragon Crew Warrior"] = 8 } }, { LevelReq = 1600, Name = "Dragon Crew Archer", Task = { ["Dragon Crew Archer"] = 8 } } },
    VenomCrewQuest = { { LevelReq = 1625, Name = "Hydra Enforcer", Task = { ["Hydra Enforcer"] = 8 } }, { LevelReq = 1650, Name = "Venomous Assailant", Task = { ["Venomous Assailant"] = 8 } }, { LevelReq = 1675, Name = "Hydra Leader", Task = { ["Hydra Leader"] = 1 } } },
    MarineTreeIsland = { { LevelReq = 1700, Name = "Marine Commodore", Task = { ["Marine Commodore"] = 8 } }, { LevelReq = 1725, Name = "Marine Rear Admiral", Task = { ["Marine Rear Admiral"] = 8 } }, { LevelReq = 1750, Name = "Kilo Admiral", Task = { ["Kilo Admiral"] = 1 } } },
    DeepForestIsland3 = { { LevelReq = 1775, Name = "Fishman Raider", Task = { ["Fishman Raider"] = 8 } }, { LevelReq = 1800, Name = "Fishman Captain", Task = { ["Fishman Captain"] = 8 } } },
    DeepForestIsland = { { LevelReq = 1825, Name = "Forest Pirate", Task = { ["Forest Pirate"] = 8 } }, { LevelReq = 1850, Name = "Mythological Pirate", Task = { ["Mythological Pirate"] = 8 } }, { LevelReq = 1875, Name = "Captain Elephant", Task = { ["Captain Elephant"] = 1 } } },
    DeepForestIsland2 = { { LevelReq = 1900, Name = "Jungle Pirate", Task = { ["Jungle Pirate"] = 8 } }, { LevelReq = 1925, Name = "Musketeer Pirate", Task = { ["Musketeer Pirate"] = 8 } }, { LevelReq = 1950, Name = "Beautiful Pirate", Task = { ["Beautiful Pirate"] = 1 } } },
    HauntedQuest1 = { { LevelReq = 1975, Name = "Reborn Skeleton", Task = { ["Reborn Skeleton"] = 8 } }, { LevelReq = 2000, Name = "Living Zombie", Task = { ["Living Zombie"] = 8 } } },
    HauntedQuest2 = { { LevelReq = 2025, Name = "Demonic Soul", Task = { ["Demonic Soul"] = 8 } }, { LevelReq = 2050, Name = "Posessed Mummy", Task = { ["Posessed Mummy"] = 8 } } },
    NutsIslandQuest = { { LevelReq = 2075, Name = "Peanut Scout", Task = { ["Peanut Scout"] = 8 } }, { LevelReq = 2100, Name = "Peanut President", Task = { ["Peanut President"] = 8 } } },
    IceCreamIslandQuest = { { LevelReq = 2125, Name = "Ice Cream Chef", Task = { ["Ice Cream Chef"] = 8 } }, { LevelReq = 2150, Name = "Ice Cream Commander", Task = { ["Ice Cream Commander"] = 8 } }, { LevelReq = 2175, Name = "Cake Queen", Task = { ["Cake Queen"] = 1 } } },
    CakeQuest1 = { { LevelReq = 2200, Name = "Cookie Crafter", Task = { ["Cookie Crafter"] = 8 } }, { LevelReq = 2225, Name = "Cake Guard", Task = { ["Cake Guard"] = 8 } } },
    CakeQuest2 = { { LevelReq = 2250, Name = "Baking Staff", Task = { ["Baking Staff"] = 8 } }, { LevelReq = 2275, Name = "Head Baker", Task = { ["Head Baker"] = 8 } } },
    ChocQuest1 = { { LevelReq = 2300, Name = "Cocoa Warrior", Task = { ["Cocoa Warrior"] = 8 } }, { LevelReq = 2325, Name = "Chocolate Bar Battler", Task = { ["Chocolate Bar Battler"] = 8 } } },
    ChocQuest2 = { { LevelReq = 2350, Name = "Sweet Thief", Task = { ["Sweet Thief"] = 8 } }, { LevelReq = 2375, Name = "Candy Rebel", Task = { ["Candy Rebel"] = 8 } } },
    CandyQuest1 = { { LevelReq = 2400, Name = "Candy Pirate", Task = { ["Candy Pirate"] = 8 } }, { LevelReq = 2425, Name = "Snow Demon", Task = { ["Snow Demon"] = 8 } } },
    TikiQuest1 = { { LevelReq = 2450, Name = "Isle Outlaw", Task = { ["Isle Outlaw"] = 8 } }, { LevelReq = 2475, Name = "Island Boy", Task = { ["Island Boy"] = 8 } } },
    TikiQuest2 = { { LevelReq = 2500, Name = "Sun-kissed Warrior", Task = { ["Sun-kissed Warrior"] = 8 } }, { LevelReq = 2525, Name = "Isle Champion", Task = { ["Isle Champion"] = 8 } } },
    TikiQuest3 = { { LevelReq = 2550, Name = "Serpent Hunter", Task = { ["Serpent Hunter"] = 8 } }, { LevelReq = 2575, Name = "Skull Slayer", Task = { ["Skull Slayer"] = 8 } } },
    SubmergedQuest1 = { { LevelReq = 2600, Name = "Reef Bandit", Task = { ["Reef Bandit"] = 8 } }, { LevelReq = 2625, Name = "Coral Pirate", Task = { ["Coral Pirate"] = 8 } } },
    SubmergedQuest2 = { { LevelReq = 2650, Name = "Sea Chanter", Task = { ["Sea Chanter"] = 8 } }, { LevelReq = 2675, Name = "Ocean Prophet", Task = { ["Ocean Prophet"] = 8 } } },
    SubmergedQuest3 = { { LevelReq = 2675, Name = "High Disciple", Task = { ["High Disciple"] = 8 } }, { LevelReq = 2700, Name = "Grand Devotee", Task = { ["Grand Devotee"] = 8 } } }
}
_G.MainQuestTable = MainQuestTable

------------------------------------------------------------------------
-- АВТОМАТИЧЕСКАЯ АДАПТАЦИЯ ПОД ЛЮБОЙ ЭКРАН
------------------------------------------------------------------------
local viewport = Workspace.CurrentCamera.ViewportSize
local screenW, screenH = viewport.X, viewport.Y
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local isConsole = GuiService:IsTenFootInterface()

local deviceType
if isConsole then
    deviceType = "console"
elseif isMobile then
    if screenW <= 480 then
        deviceType = "phone"
    else
        deviceType = "tablet"
    end
else
    deviceType = "pc"
end

local baseWidth, baseHeight
if deviceType == "console" then
    baseWidth, baseHeight = 900, 600
elseif deviceType == "phone" then
    -- Компактный режим телефона. Учитываем портрет/альбомную ориентацию.
    if screenW >= screenH then
        baseWidth = math.clamp(screenW * 0.78, 300, 390)
        baseHeight = math.clamp(screenH * 0.72, 210, 280)
    else
        baseWidth = math.clamp(screenW * 0.86, 270, 330)
        baseHeight = math.clamp(screenH * 0.50, 200, 245)
    end
elseif deviceType == "tablet" then
    baseWidth = math.min(screenW * 0.7, 500)
    baseHeight = math.min(screenH * 0.7, 420)
else
    baseWidth = math.min(screenW * 0.6, 700)
    baseHeight = math.min(screenH * 0.6, 500)
end

local sidebarWidth = 160
if deviceType == "phone" then
    sidebarWidth = screenW >= screenH and 82 or 78
elseif deviceType == "tablet" then
    sidebarWidth = 140
elseif deviceType == "console" then
    sidebarWidth = 180
end

local fontSizeSmall = 11
local fontSizeMedium = 13
local fontSizeLarge = 16
if deviceType == "phone" then
    fontSizeSmall = 8
    fontSizeMedium = 9
    fontSizeLarge = 11
elseif deviceType == "tablet" then
    fontSizeSmall = 12
    fontSizeMedium = 14
    fontSizeLarge = 16
elseif deviceType == "console" then
    fontSizeSmall = 14
    fontSizeMedium = 16
    fontSizeLarge = 18
end

------------------------------------------------------------------------
-- ИНТЕРФЕЙС
------------------------------------------------------------------------
local BlackHoleHub = Instance.new("ScreenGui")
BlackHoleHub.Name = "BlackHoleHub"
BlackHoleHub.Parent = CoreGui
BlackHoleHub.ResetOnSpawn = false
BlackHoleHub.IgnoreGuiInset = true
BlackHoleHub.DisplayOrder = 999

-- ИНТРО-АНИМАЦИЯ
local IntroFrame = Instance.new("Frame", BlackHoleHub)
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
IntroFrame.ZIndex = 500
local IntroImage = Instance.new("ImageLabel", IntroFrame)
IntroImage.Size = UDim2.new(1, 0, 1, 0)
IntroImage.BackgroundTransparency = 1
IntroImage.Image = "rbxassetid://89122563169047"
IntroImage.ImageTransparency = 1
IntroImage.ScaleType = Enum.ScaleType.Crop
IntroImage.ZIndex = 501
local IntroText = Instance.new("TextLabel", IntroFrame)
IntroText.Size = UDim2.new(1, 0, 0, 100)
IntroText.Position = UDim2.new(0, 0, 0.5, -50)
IntroText.BackgroundTransparency = 1
IntroText.Text = "BLACK HOLE HUB"
IntroText.TextColor3 = _G.AccentColor
IntroText.Font = Enum.Font.GothamBlack
IntroText.TextSize = 60
IntroText.TextTransparency = 1
IntroText.ZIndex = 502
local SubText = Instance.new("TextLabel", IntroFrame)
SubText.Size = UDim2.new(1, 0, 0, 50)
SubText.Position = UDim2.new(0, 0, 0.5, 40)
SubText.BackgroundTransparency = 1
SubText.Text = "by ArtSquadFive"
SubText.TextColor3 = Color3.fromRGB(255, 255, 255)
SubText.Font = Enum.Font.GothamBold
SubText.TextSize = 25
SubText.TextTransparency = 1
SubText.ZIndex = 502
TweenService:Create(IntroImage, TweenInfo.new(2, Enum.EasingStyle.Quad), {ImageTransparency = 0.4}):Play()
task.wait(1)
TweenService:Create(IntroText, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
TweenService:Create(SubText, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
task.wait(1.5)
TweenService:Create(IntroText, TweenInfo.new(1), {TextTransparency = 1}):Play()
TweenService:Create(SubText, TweenInfo.new(1), {TextTransparency = 1}):Play()
TweenService:Create(IntroImage, TweenInfo.new(1.5), {ImageTransparency = 1}):Play()
TweenService:Create(IntroFrame, TweenInfo.new(1.5), {BackgroundTransparency = 1}):Play()
task.wait(1)
IntroFrame:Destroy()

-- ОСНОВНОЙ ФРЕЙМ
local Main = Instance.new("Frame", BlackHoleHub)
Main.Name = "MainFrame"
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Size = UDim2.new(0, baseWidth, 0, baseHeight)
Main.Position = UDim2.new(0.5, -baseWidth/2, 0.5, -baseHeight/2)
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
local StrokeGradient = Instance.new("UIGradient", MainStroke)
StrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, _G.AccentColor), ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))}
StrokeGradient.Rotation = 45
local BgImage = Instance.new("ImageLabel", Main)
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = "rbxassetid://89122563169047"
BgImage.ImageTransparency = 0.85
BgImage.ScaleType = Enum.ScaleType.Crop

-- TopBar
local TopBar = Instance.new("Frame", Main)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 10, 5)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 0.5
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Text = "BLACK HOLE HUB | ArtSquadFive"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextColor3 = _G.AccentColor
TitleLabel.TextSize = fontSizeLarge
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка сворачивания
local CollapseBtn = Instance.new("TextButton", TopBar)
CollapseBtn.Size = UDim2.new(0, 30, 0, 30)
CollapseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CollapseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CollapseBtn.Text = "−"
CollapseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CollapseBtn.Font = Enum.Font.GothamBold
CollapseBtn.TextSize = 20
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(0, 6)
CollapseBtn.ZIndex = 10

local function CollapseToggle()
    _G.Collapsed = not _G.Collapsed
    if _G.Collapsed then
        Main.Size = UDim2.new(0, baseWidth, 0, 40)
        Sidebar.Visible = false
        Container.Visible = false
        CollapseBtn.Text = "+"
    else
        Main.Size = UDim2.new(0, baseWidth, 0, baseHeight)
        Sidebar.Visible = true
        Container.Visible = true
        CollapseBtn.Text = "−"
    end
end
CollapseBtn.MouseButton1Click:Connect(CollapseToggle)

-- Мобильная кнопка
local MobileToggleBtn = Instance.new("ImageButton", BlackHoleHub)
if isMobile then
    MobileToggleBtn.Size = UDim2.new(0, 44, 0, 44)
    MobileToggleBtn.Position = UDim2.new(0, 12, 0.5, -22)
else
    MobileToggleBtn.Visible = false
end
MobileToggleBtn.BackgroundColor3 = _G.AccentColor
MobileToggleBtn.Image = "rbxassetid://89122563169047"
Instance.new("UICorner", MobileToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", MobileToggleBtn).Color = Color3.fromRGB(255,255,255)
MobileToggleBtn.MouseButton1Click:Connect(function()
    if _G.Collapsed then CollapseToggle() end
    Main.Visible = not Main.Visible
    _G.GUIOpen = Main.Visible
end)

-- Drag
local dragToggle, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true; dragStart = input.Position; startPos = Main.Position
        for _, child in ipairs(BlackHoleHub:GetChildren()) do
            if child.Name == "DropdownWindow" then child.Visible = false end
        end
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end
end)

-- Sidebar
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BackgroundTransparency = 0.6
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.Size = UDim2.new(0, sidebarWidth, 1, -60)
Sidebar.ScrollBarThickness = 2
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Container = Instance.new("Frame", Main)
Container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Container.BackgroundTransparency = 0.6
Container.Position = UDim2.new(0, sidebarWidth + 20, 0, 50)
Container.Size = UDim2.new(1, -(sidebarWidth + 30), 1, -60)
Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

------------------------------------------------------------------------
-- АВТО-АДАПТАЦИЯ UI ПОД ТЕЛЕФОН / ПЛАНШЕТ / ПОВОРОТ ЭКРАНА
------------------------------------------------------------------------
local MainScale = Instance.new("UIScale")
MainScale.Name = "ResponsiveScale"
MainScale.Scale = 1
MainScale.Parent = Main

local function GetResponsiveMetrics()
    local camera = Workspace.CurrentCamera
    if not camera then
        return baseWidth, baseHeight, sidebarWidth, fontSizeSmall, fontSizeMedium, fontSizeLarge, 1
    end

    local size = camera.ViewportSize
    local w, h = size.X, size.Y
    local mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local console = GuiService:IsTenFootInterface()

    local width, height, side
    local fsSmall, fsMedium, fsLarge
    local scale = 1

    if console then
        width, height = 900, 600
        side = 180
        fsSmall, fsMedium, fsLarge = 14, 16, 18
    elseif mobile then
        if w >= h then
            -- Телефон в альбомной ориентации
            width = math.clamp(w * 0.78, 300, 390)
            height = math.clamp(h * 0.72, 210, 280)
            side = 82
        else
            -- Телефон в портретной ориентации
            width = math.clamp(w * 0.86, 270, 330)
            height = math.clamp(h * 0.50, 200, 245)
            side = 78
        end

        -- Дополнительное уменьшение на очень маленьких экранах.
        if w < 340 then
            scale = math.clamp(w / 340, 0.82, 1)
        end

        fsSmall, fsMedium, fsLarge = 8, 9, 11
    elseif w < 700 then
        width = math.min(w * 0.70, 500)
        height = math.min(h * 0.70, 420)
        side = 140
        fsSmall, fsMedium, fsLarge = 12, 14, 16
    else
        width = math.min(w * 0.60, 700)
        height = math.min(h * 0.60, 500)
        side = 160
        fsSmall, fsMedium, fsLarge = 11, 13, 16
    end

    return width, height, side, fsSmall, fsMedium, fsLarge, scale
end

local function ApplyResponsiveLayout()
    local width, height, side, fsSmall, fsMedium, fsLarge, scale =
        GetResponsiveMetrics()

    baseWidth = width
    baseHeight = height
    sidebarWidth = side
    fontSizeSmall = fsSmall
    fontSizeMedium = fsMedium
    fontSizeLarge = fsLarge

    Main.Size = UDim2.new(0, width, 0, _G.Collapsed and 40 or height)
    Main.Position = UDim2.new(0.5, -width / 2, 0.5, -(Main.AbsoluteSize.Y / 2))
    MainScale.Scale = scale

    if TopBar then
        local topHeight = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
            and 34 or 40

        TopBar.Size = UDim2.new(1, 0, 0, topHeight)
    end

    if TitleLabel then
        TitleLabel.Position = UDim2.new(0, 10, 0, 0)
        TitleLabel.Size = UDim2.new(1, -52, 1, 0)
        TitleLabel.TextSize = fsLarge
        TitleLabel.Text = "BLACK HOLE HUB | ArtSquadFive"
        TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    end

    if CollapseBtn then
        local buttonSize = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
            and 26 or 30

        CollapseBtn.Size = UDim2.new(0, buttonSize, 0, buttonSize)
        CollapseBtn.Position = UDim2.new(1, -buttonSize - 7, 0.5, -buttonSize / 2)
        CollapseBtn.TextSize = (buttonSize <= 26) and 17 or 20
    end

    if Sidebar then
        Sidebar.Position = UDim2.new(0, 7, 0, 43)
        Sidebar.Size = UDim2.new(0, side, 1, -50)
    end

    if Container then
        Container.Position = UDim2.new(0, side + 14, 0, 43)
        Container.Size = UDim2.new(1, -(side + 21), 1, -50)
    end

    -- Масштабируем только содержимое Main, поэтому интерфейс остаётся компактным.
    MainScale.Scale = scale
end

-- Пересчитываем размеры после создания всех основных элементов.
task.defer(ApplyResponsiveLayout)

-- При повороте телефона/изменении размера окна UI автоматически перестраивается.
local boundCamera = nil

local function BindCameraViewport(camera)
    if not camera or camera == boundCamera then
        return
    end

    boundCamera = camera

    camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        task.defer(ApplyResponsiveLayout)
    end)
end

BindCameraViewport(Workspace.CurrentCamera)

task.spawn(function()
    while BlackHoleHub and BlackHoleHub.Parent do
        local camera = Workspace.CurrentCamera

        if camera ~= boundCamera then
            BindCameraViewport(camera)
            task.defer(ApplyResponsiveLayout)
        end

        task.wait(0.25)
    end
end)

local Tabs = {}
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 10)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = fontSizeMedium
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.BorderSizePixel = 0
    local layout = Instance.new("UIListLayout", Page)
    layout.Padding = UDim.new(0, 8)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Page.Visible = false
            TweenService:Create(tab.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 20, 10), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = _G.AccentColor, TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
        for _, child in ipairs(BlackHoleHub:GetChildren()) do
            if child.Name == "DropdownWindow" then child.Visible = false end
        end
    end)
    table.insert(Tabs, {Page = Page, Btn = TabBtn})
    return Page
end

------------------------------------------------------------------------
-- КОНСТРУКТОРЫ ЭЛЕМЕНТОВ
------------------------------------------------------------------------
local function CreateToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.5
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = fontSizeMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    local Check = Instance.new("TextButton", Frame)
    Check.Size = UDim2.new(0, 25, 0, 25)
    Check.Position = UDim2.new(1, -35, 0.5, -12.5)
    Check.BackgroundColor3 = default and _G.AccentColor or Color3.fromRGB(20, 20, 20)
    Check.Text = ""
    Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 6)
    local state = default
    Check.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Check, TweenInfo.new(0.2), {BackgroundColor3 = state and _G.AccentColor or Color3.fromRGB(20, 20, 20)}):Play()
        pcall(callback, state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.5
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = fontSizeMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    local Bg = Instance.new("Frame", Frame)
    Bg.Size = UDim2.new(1, -20, 0, 6)
    Bg.Position = UDim2.new(0, 10, 0, 30)
    Bg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)
    local Fill = Instance.new("Frame", Bg)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = _G.AccentColor
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    local Btn = Instance.new("TextButton", Bg)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. tostring(val)
        pcall(callback, val)
    end
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
    end)
end

local function CreateDropdown(parent, text, list_func, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.5
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -160, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = fontSizeMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    local DropBtn = Instance.new("TextButton", Frame)
    DropBtn.Size = UDim2.new(0, 140, 0, 30)
    DropBtn.Position = UDim2.new(1, -150, 0.5, -15)
    DropBtn.Text = "Выбрать..."
    DropBtn.Font = Enum.Font.GothamBold
    DropBtn.TextSize = fontSizeMedium
    DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)
    local DropList = Instance.new("ScrollingFrame")
    DropList.Name = "DropdownWindow"
    DropList.Size = UDim2.new(0, 140, 0, 120)
    DropList.Visible = false
    DropList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    DropList.BorderSizePixel = 0
    DropList.ZIndex = 300
    DropList.ScrollBarThickness = 4
    Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", DropList)
    stroke.Color = _G.AccentColor
    stroke.Thickness = 1
    local listLayout = Instance.new("UIListLayout", DropList)
    listLayout.Padding = UDim.new(0, 2)
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        DropList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 5)
    end)
    DropList.Parent = BlackHoleHub
    DropBtn.MouseButton1Click:Connect(function()
        for _, child in ipairs(BlackHoleHub:GetChildren()) do
            if child:IsA("ScrollingFrame") and child.Name == "DropdownWindow" and child ~= DropList then
                child.Visible = false
            end
        end
        DropList.Visible = not DropList.Visible
        if DropList.Visible then
            DropList.Position = UDim2.new(0, DropBtn.AbsolutePosition.X, 0, DropBtn.AbsolutePosition.Y + DropBtn.AbsoluteSize.Y + 4)
            for _, child in ipairs(DropList:GetChildren()) do 
                if child:IsA("TextButton") then child:Destroy() end 
            end
            local current_list = type(list_func) == "function" and list_func() or list_func
            for _, v in ipairs(current_list) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                btn.Text = tostring(v)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = fontSizeMedium
                btn.ZIndex = 310
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
                btn.MouseButton1Click:Connect(function()
                    DropBtn.Text = tostring(v)
                    DropList.Visible = false
                    pcall(callback, v)
                end)
                btn.Parent = DropList
            end
        end
    end)
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = _G.AccentColor
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = fontSizeMedium
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

------------------------------------------------------------------------
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
------------------------------------------------------------------------
local function GetWeapons()
    table.clear(WeaponsList)
    local function scan(folder)
        if not folder then return end
        for _, item in ipairs(folder:GetChildren()) do
            if item:IsA("Tool") and not table.find(WeaponsList, item.Name) then table.insert(WeaponsList, item.Name) end
        end
    end
    if LocalPlayer and LocalPlayer:FindFirstChild("Backpack") then scan(LocalPlayer.Backpack) end
    if LocalPlayer.Character then scan(LocalPlayer.Character) end
    if #WeaponsList == 0 then table.insert(WeaponsList, "Пусто") end
    return WeaponsList
end

local function EquipWeapon()
    if not _G.SelectedWeapon or _G.SelectedWeapon == "Пусто" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    pcall(function()
        if char:FindFirstChild(_G.SelectedWeapon) then return end
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            local tool = backpack:FindFirstChild(_G.SelectedWeapon)
            if tool then
                tool.Parent = char
                task.wait(0.05)
            end
        end
    end)
end

local function ClickAttack()
    if _G.GUIOpen then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer.Character.Humanoid.Health <= 0 then
        return
    end
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(10, 10, 0, true, game, 0)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(10, 10, 0, false, game, 0)
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:IsA("Tool") then
            tool:Activate()
        end
    end)
    clickCounter = clickCounter + 1
    if clickCounter % 50 == 0 then
        print("🔹 Кликов отправлено: " .. clickCounter)
    end
end

local function SpamSkills()
    if not _G.SpamSkills then return end
    if tick() - lastSkillTime >= 2.5 then
        local key = skillKeys[currentSkillIndex]
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
        currentSkillIndex = currentSkillIndex % #skillKeys + 1
        lastSkillTime = tick()
    end
end

-- НОВЫЙ ПЛАВНЫЙ ПОЛЁТ С УДЕРЖАНИЕМ (без телепортаций)
local function FlyToPosition(targetPos)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.PlatformStand = true
    end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = root

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    local distance = (root.Position - targetPos).Magnitude
    local duration = distance / _G.FarmSpeed
    if duration < 0.1 then duration = 0.1 end

    local startTime = tick()
    local startPos = root.Position

    while tick() - startTime < duration do
        if not root or not root.Parent then break end
        local alpha = math.min((tick() - startTime) / duration, 1)
        local newPos = startPos:Lerp(targetPos, alpha)
        bodyVelocity.Velocity = (newPos - root.Position) * 10
        bodyGyro.CFrame = CFrame.lookAt(root.Position, targetPos)
        task.wait()
    end

    root.CFrame = CFrame.new(targetPos)

    bodyVelocity:Destroy()
    bodyGyro:Destroy()
    if humanoid then
        humanoid.PlatformStand = false
    end
end

local function SmoothFlyTween(targetPos)
    FlyToPosition(targetPos)
end

local function FindNPCByName(name)
    local enemies = Workspace:FindFirstChild("Enemies") or Workspace
    for _, child in ipairs(enemies:GetChildren()) do
        pcall(function()
            if child.Name == name and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart") then
                return child
            end
        end)
    end
    return nil
end

local function GetAliveBosses()
    local alive = {}
    local enemies = Workspace:FindFirstChild("Enemies") or Workspace
    for _, child in ipairs(enemies:GetChildren()) do
        pcall(function()
            if child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart") then
                for _, bossName in ipairs(BossList) do
                    if child.Name == bossName then
                        table.insert(alive, bossName)
                        break
                    end
                end
            end
        end)
    end
    return alive
end

local function LoadBoss(bossName)
    local boss = FindNPCByName(bossName)
    if boss then return boss end
    local spawnPos = BossSpawnLocations[bossName]
    if spawnPos then
        SmoothFlyTween(spawnPos)
        task.wait(2)
        return FindNPCByName(bossName)
    end
    return nil
end

local function GetMyBoat()
    local char = LocalPlayer.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.SeatPart then
        return humanoid.SeatPart.Parent
    end
    return nil
end

local function FindSeaEvent(targetName)
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:find(targetName) and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
            return obj
        end
    end
    local folders = {Workspace:FindFirstChild("SeaBeasts"), Workspace:FindFirstChild("SeaEvents"), Workspace:FindFirstChild("Bosses")}
    for _, folder in ipairs(folders) do
        if folder then
            for _, obj in ipairs(folder:GetChildren()) do
                if obj.Name:find(targetName) and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                    return obj
                end
            end
        end
    end
    return nil
end

local function FlyObjectTo(object, targetCFrame)
    local primaryPart = object:IsA("Model") and (object.PrimaryPart or object:FindFirstChild("Engine") or object:FindFirstChild("VehicleSeat") or object:FindFirstChild("HumanoidRootPart"))
    if not primaryPart then return nil end
    local distance = (primaryPart.Position - targetCFrame.Position).Magnitude
    local timeToFly = distance / _G.SeaEventFlySpeed
    local tweenInfo = TweenInfo.new(timeToFly, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(primaryPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

local function FarmSeaEvent(eventName)
    if not _G[eventName.."Farm"] then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local boat = GetMyBoat()
    local targetObject = boat or (char:FindFirstChild("HumanoidRootPart") and char)

    local seaEvent = FindSeaEvent(eventName)
    if not seaEvent then
        local targetCFrame = CFrame.new(9000, 15, 9000)
        local primary = targetObject:IsA("Model") and (targetObject.PrimaryPart or targetObject:FindFirstChild("Engine") or targetObject:FindFirstChild("VehicleSeat") or targetObject:FindFirstChild("HumanoidRootPart")) or targetObject:FindFirstChild("HumanoidRootPart")
        if primary and (primary.Position - targetCFrame.Position).Magnitude > 300 then
            local tween = FlyObjectTo(targetObject, targetCFrame)
            if tween then
                while tween.PlaybackState == Enum.PlaybackState.Playing and not FindSeaEvent(eventName) do
                    task.wait(0.5)
                end
            end
        end
        return
    end

    local head = seaEvent:FindFirstChild("Head") or seaEvent:FindFirstChild("HumanoidRootPart") or seaEvent.PrimaryPart
    if head then
        local targetPosition = head.CFrame * CFrame.new(0, _G.SeaEventHoverHeight, 0)
        local tween = FlyObjectTo(targetObject, targetPosition)
        if tween then tween.Completed:Wait() end

        while seaEvent and seaEvent:FindFirstChild("Humanoid") and seaEvent.Humanoid.Health > 0 and _G[eventName.."Farm"] do
            if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then break end
            if targetObject:IsA("Model") and targetObject.PrimaryPart then
                targetObject.PrimaryPart.CFrame = head.CFrame * CFrame.new(0, _G.SeaEventHoverHeight, 0)
            elseif char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = head.CFrame * CFrame.new(0, _G.SeaEventHoverHeight, 0)
            end
            ClickAttack()
            task.wait(_G.ClickInterval / 1000)
        end
    end
end

------------------------------------------------------------------------
-- ФУНКЦИЯ GetQuestData
------------------------------------------------------------------------
local function GetQuestData()
    local lvl = 1
    pcall(function()
        local data = LocalPlayer:FindFirstChild("Data")
        local level = data and data:FindFirstChild("Level")
        if level then
            lvl = level.Value
        end
    end)

    local questTable = _G.MainQuestTable
    if not questTable then
        warn("❌ MainQuestTable не найдена в _G!")
        return nil
    end

    local allQuests = {}

    for qKey, qData in pairs(questTable) do
        if type(qData) == "table" then
            for index, info in ipairs(qData) do
                if type(info) == "table"
                    and tonumber(info.LevelReq)
                    and info.LevelReq <= lvl
                    and type(info.Task) == "table" then

                    local npcName, required = nil, 0

                    for name, amount in pairs(info.Task) do
                        npcName = tostring(name)
                        required = tonumber(amount) or 0
                        break
                    end

                    if npcName and required > 0 then
                        table.insert(allQuests, {
                            qKey = qKey,
                            qId = index,
                            level = info.LevelReq,
                            npcName = npcName,
                            count = required,
                            isBoss = (required == 1)
                        })
                    end
                end
            end
        end
    end

    if #allQuests == 0 then
        warn("❌ Нет доступных квестов для уровня", lvl)
        return nil
    end

    table.sort(allQuests, function(a, b)
        if a.level == b.level then
            return tostring(a.qKey) < tostring(b.qKey)
        end
        return a.level > b.level
    end)

    return allQuests[1]
end

------------------------------------------------------------------------
-- СОСТОЯНИЕ АВТОФАРМА КВЕСТА
------------------------------------------------------------------------
local QuestState = {
    Active = false,
    QuestKey = nil,
    QuestId = nil,
    TargetName = nil,
    Required = 0,
    Kills = 0,
    StartedAt = 0,
    LastStart = 0,
    LastTurnIn = 0,
    TurnInAttempts = 0,
    LastProgress = -1,
    BoundMobs = {},
}

local QUEST_START_COOLDOWN = 1.25
local QUEST_TURNIN_COOLDOWN = 1.0
local QUEST_NO_MOB_GRACE = 2.5
local QUEST_TURNIN_VERIFY_TIMEOUT = 3.0

local function ClearQuestState()
    QuestState.Active = false
    QuestState.QuestKey = nil
    QuestState.QuestId = nil
    QuestState.TargetName = nil
    QuestState.Required = 0
    QuestState.Kills = 0
    QuestState.StartedAt = 0
    QuestState.LastProgress = -1
    QuestState.TurnInAttempts = 0
    QuestState.BoundMobs = {}
    _G.CurrentRunningNPC = nil
end

local function SetQuestState(quest)
    QuestState.Active = true
    QuestState.QuestKey = quest.qKey
    QuestState.QuestId = quest.qId
    QuestState.TargetName = quest.npcName
    QuestState.Required = quest.count
    QuestState.Kills = 0
    QuestState.StartedAt = os.clock()
    QuestState.LastProgress = -1
    QuestState.TurnInAttempts = 0
    QuestState.BoundMobs = {}
    _G.CurrentRunningNPC = quest.npcName
end

local function QuestStateMatches(quest)
    return QuestState.Active
        and QuestState.QuestKey == quest.qKey
        and QuestState.QuestId == quest.qId
        and QuestState.TargetName == quest.npcName
end

local function GetQuestRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    return remotes and remotes:FindFirstChild("CommF_")
end

local function FindQuestFrame()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local main = playerGui and playerGui:FindFirstChild("Main")
    return main and main:FindFirstChild("Quest")
end

local function GetQuestProgressFromGui(required)
    local frame = FindQuestFrame()
    if not frame then
        return nil
    end

    local best = nil

    for _, obj in ipairs(frame:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            local text = tostring(obj.Text or "")
            if text ~= "" then
                local a, b = text:match("(%d+)%s*/%s*(%d+)")
                if a and b then
                    a, b = tonumber(a), tonumber(b)
                    if b and b > 0 and (not required or b == required) then
                        best = math.max(best or 0, a)
                    end
                end
            end
        end
    end

    return best
end

local function IsQuestGuiVisible()
    local frame = FindQuestFrame()
    return frame and frame.Visible == true
end

local function IsQuestComplete()
    if not QuestState.Active then
        return false
    end

    local progress = GetQuestProgressFromGui(QuestState.Required)

    if progress ~= nil then
        QuestState.LastProgress = progress
        if progress >= QuestState.Required then
            return true
        end
    end

    if QuestState.Kills >= QuestState.Required then
        return true
    end

    return false
end

local function BindMobDeath(mob)
    if not QuestState.Active or not mob or not mob:IsA("Model") then
        return
    end

    if QuestState.BoundMobs[mob] then
        return
    end

    local hum = mob:FindFirstChildOfClass("Humanoid")
    if not hum then
        return
    end

    QuestState.BoundMobs[mob] = true

    hum.Died:Connect(function()
        if not QuestState.Active then
            return
        end

        if mob.Name ~= QuestState.TargetName then
            return
        end

        QuestState.Kills = math.min(
            QuestState.Required,
            QuestState.Kills + 1
        )

        QuestState.LastProgress = math.max(
            QuestState.LastProgress,
            QuestState.Kills
        )
    end)
end

local function FindQuestEnemy(name)
    if not name then
        return nil
    end

    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    local searchRoot = enemiesFolder or Workspace

    for _, obj in ipairs(searchRoot:GetChildren()) do
        if obj:IsA("Model") and obj.Name == name then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and root
                and obj ~= LocalPlayer.Character
                and not Players:GetPlayerFromCharacter(obj) then
                BindMobDeath(obj)
                return obj
            end
        end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == name then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and root
                and obj ~= LocalPlayer.Character
                and not Players:GetPlayerFromCharacter(obj) then
                BindMobDeath(obj)
                return obj
            end
        end
    end

    return nil
end

local function GetAllQuestEnemies(name)
    local result = {}
    if not name then
        return result
    end

    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    local searchRoot = enemiesFolder or Workspace

    for _, obj in ipairs(searchRoot:GetChildren()) do
        if obj:IsA("Model") and obj.Name == name then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and root
                and obj ~= LocalPlayer.Character
                and not Players:GetPlayerFromCharacter(obj) then
                BindMobDeath(obj)
                table.insert(result, obj)
            end
        end
    end

    return result
end

local function StartQuest(quest)
    local commF = GetQuestRemote()
    if not commF then
        warn("❌ CommF_ не найден!")
        return false
    end

    if os.clock() - QuestState.LastStart < QUEST_START_COOLDOWN then
        return false
    end

    QuestState.LastStart = os.clock()

    local ok, result = pcall(function()
        return commF:InvokeServer("StartQuest", quest.qKey, quest.qId)
    end)

    if not ok then
        warn("❌ Ошибка StartQuest:", result)
        return false
    end

    SetQuestState(quest)

    print(string.format(
        "📜 Взят квест: %s [%d/%d] (уровень %d)",
        quest.npcName,
        0,
        quest.count,
        quest.level
    ))

    return true
end

local function TryTurnInQuest()
    if not QuestState.Active then
        return false
    end

    local commF = GetQuestRemote()
    if not commF then
        return false
    end

    if os.clock() - QuestState.LastTurnIn < QUEST_TURNIN_COOLDOWN then
        return false
    end

    QuestState.LastTurnIn = os.clock()
    QuestState.TurnInAttempts = QuestState.TurnInAttempts + 1

    local key = QuestState.QuestKey
    local id = QuestState.QuestId

    local ok, result = pcall(function()
        return commF:InvokeServer("StartQuest", key, id)
    end)

    if not ok then
        warn("⚠️ Ошибка при сдаче квеста:", result)
        return false
    end

    task.wait(0.15)

    local progress = GetQuestProgressFromGui(QuestState.Required)
    local visible = IsQuestGuiVisible()

    if not visible or (progress ~= nil and progress < QuestState.Required) then
        print("✅ Квест выполнен и сдан:", QuestState.TargetName)
        ClearQuestState()
        return true
    end

    if result == true and QuestState.TurnInAttempts >= 2 then
        print("✅ Сервер подтвердил сдачу:", QuestState.TargetName)
        ClearQuestState()
        return true
    end

    return false
end

local function EnsureQuest()
    if QuestState.Active then
        return true
    end

    local quest = GetQuestData()
    if not quest then
        return false
    end

    return StartQuest(quest)
end

------------------------------------------------------------------------
-- СОЗДАНИЕ ВКЛАДОК
------------------------------------------------------------------------
local FarmTab = CreateTab("⚔️ Фарм")
local WorldTab = CreateTab("🌍 Мир")
local BossTab = CreateTab("👑 Рейд боссов")
local SettingsTab = CreateTab("⚙️ Настройки")
local ConfigTab = CreateTab("💾 Конфиг")

CreateToggle(FarmTab, "Включить Автофарм (с квестом)", _G.AutoFarmLevel, function(s)
    _G.AutoFarmLevel = s
    currentTarget = nil
    if s then
        _G.AutoHaki = true
        _G.AutoInstinct = true
        ClearQuestState()
    else
        ClearQuestState()
    end
end)
CreateToggle(FarmTab, "Фарм без квеста (1000м)", _G.KillAuraRadius, function(s)
    _G.KillAuraRadius = s
    if s then
        _G.AutoHaki = true
        _G.AutoInstinct = true
    end
    if not s then currentTarget = nil end
end)
CreateToggle(FarmTab, "Авто-Спам Скиллов", _G.SpamSkills, function(s) _G.SpamSkills = s end)
CreateToggle(FarmTab, "Авто-Хаки (Вооружение)", _G.AutoHaki, function(s) _G.AutoHaki = s end)
CreateToggle(FarmTab, "Авто-Инстинкт (Наблюдение)", _G.AutoInstinct, function(s) _G.AutoInstinct = s end)
CreateSlider(FarmTab, "Дистанция атаки", 6, 50, _G.FarmDistance, function(v) _G.FarmDistance = v end)
CreateDropdown(FarmTab, "Выбор стороны атаки", {"Сверху", "Снизу", "Со спины"}, function(v) _G.AttackSide = v end)
CreateDropdown(FarmTab, "Выбери Оружие", GetWeapons, function(v) _G.SelectedWeapon = v end)

CreateToggle(WorldTab, "Fruit ESP", _G.FruitESPEnabled, function(s) _G.FruitESPEnabled = s end)
CreateToggle(WorldTab, "Магнит Сундуков (Умный)", _G.AutoChestSteal, function(s) _G.AutoChestSteal = s end)

-- РЕЙД БОССОВ
local BossFrame = Instance.new("Frame", BossTab)
BossFrame.Size = UDim2.new(1, 0, 0, 260)
BossFrame.BackgroundTransparency = 1

local StatusLabel = Instance.new("TextLabel", BossFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Сканирование живых боссов..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = fontSizeMedium
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local DropFrame = Instance.new("Frame", BossFrame)
DropFrame.Size = UDim2.new(1, 0, 0, 45)
DropFrame.Position = UDim2.new(0, 0, 0, 35)
DropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropFrame.BackgroundTransparency = 0.5
Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

local DropLabel = Instance.new("TextLabel", DropFrame)
DropLabel.Size = UDim2.new(1, -160, 1, 0)
DropLabel.Position = UDim2.new(0, 10, 0, 0)
DropLabel.BackgroundTransparency = 1
DropLabel.Text = "Живые боссы"
DropLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
DropLabel.Font = Enum.Font.GothamSemibold
DropLabel.TextSize = fontSizeMedium
DropLabel.TextXAlignment = Enum.TextXAlignment.Left

local DropBtn = Instance.new("TextButton", DropFrame)
DropBtn.Size = UDim2.new(0, 140, 0, 30)
DropBtn.Position = UDim2.new(1, -150, 0.5, -15)
DropBtn.Text = "Нет боссов"
DropBtn.Font = Enum.Font.GothamBold
DropBtn.TextSize = fontSizeMedium
DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DropBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)

local DropList = Instance.new("ScrollingFrame")
DropList.Name = "DropdownWindow"
DropList.Size = UDim2.new(0, 140, 0, 120)
DropList.Visible = false
DropList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DropList.BorderSizePixel = 0
DropList.ZIndex = 300
DropList.ScrollBarThickness = 4
Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 6)
local stroke2 = Instance.new("UIStroke", DropList)
stroke2.Color = _G.AccentColor
stroke2.Thickness = 1
local listLayout2 = Instance.new("UIListLayout", DropList)
listLayout2.Padding = UDim.new(0, 2)
listLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    DropList.CanvasSize = UDim2.new(0, 0, 0, listLayout2.AbsoluteContentSize.Y + 5)
end)
DropList.Parent = BlackHoleHub

local function RefreshBossDropdown()
    local aliveBosses = GetAliveBosses()
    for _, child in ipairs(DropList:GetChildren()) do 
        if child:IsA("TextButton") then child:Destroy() end 
    end
    if #aliveBosses == 0 then
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.Text = "Нет живых боссов"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = fontSizeMedium
        btn.ZIndex = 310
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.MouseButton1Click:Connect(function()
            DropList.Visible = false
        end)
        btn.Parent = DropList
        DropBtn.Text = "Нет боссов"
        StatusLabel.Text = "Нет живых боссов"
    else
        for _, name in ipairs(aliveBosses) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = fontSizeMedium
            btn.ZIndex = 310
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            btn.MouseButton1Click:Connect(function()
                DropBtn.Text = name
                DropList.Visible = false
                _G.BossFarmTarget = name
                StatusLabel.Text = "Выбран босс: " .. name
            end)
            btn.Parent = DropList
        end
        if _G.BossFarmTarget and FindNPCByName(_G.BossFarmTarget) then
            DropBtn.Text = _G.BossFarmTarget
        else
            DropBtn.Text = "Выбрать..."
        end
        StatusLabel.Text = "Найдено боссов: " .. #aliveBosses
    end
end

DropBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(BlackHoleHub:GetChildren()) do
        if child:IsA("ScrollingFrame") and child.Name == "DropdownWindow" and child ~= DropList then
            child.Visible = false
        end
    end
    DropList.Visible = not DropList.Visible
    if DropList.Visible then
        DropList.Position = UDim2.new(0, DropBtn.AbsolutePosition.X, 0, DropBtn.AbsolutePosition.Y + DropBtn.AbsoluteSize.Y + 4)
        RefreshBossDropdown()
    end
end)

local ButtonRow1 = Instance.new("Frame", BossFrame)
ButtonRow1.Size = UDim2.new(1, 0, 0, 40)
ButtonRow1.Position = UDim2.new(0, 0, 0, 85)
ButtonRow1.BackgroundTransparency = 1

local BtnFly = Instance.new("TextButton", ButtonRow1)
BtnFly.Size = UDim2.new(0.48, 0, 1, 0)
BtnFly.Position = UDim2.new(0, 0, 0, 0)
BtnFly.BackgroundColor3 = _G.AccentColor
BtnFly.Text = "Лететь за боссом"
BtnFly.TextColor3 = Color3.fromRGB(0, 0, 0)
BtnFly.Font = Enum.Font.GothamBold
BtnFly.TextSize = fontSizeMedium
Instance.new("UICorner", BtnFly).CornerRadius = UDim.new(0, 6)
BtnFly.MouseButton1Click:Connect(function()
    if not _G.BossFarmTarget then
        StatusLabel.Text = "Сначала выбери босса!"
        return
    end
    local boss = LoadBoss(_G.BossFarmTarget)
    if boss then
        currentTarget = boss
        StatusLabel.Text = "Летим к " .. _G.BossFarmTarget
    else
        StatusLabel.Text = "Не удалось найти босса " .. _G.BossFarmTarget
    end
end)

local BtnStop = Instance.new("TextButton", ButtonRow1)
BtnStop.Size = UDim2.new(0.48, 0, 1, 0)
BtnStop.Position = UDim2.new(0.52, 0, 0, 0)
BtnStop.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
BtnStop.Text = "Остановить"
BtnStop.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnStop.Font = Enum.Font.GothamBold
BtnStop.TextSize = fontSizeMedium
Instance.new("UICorner", BtnStop).CornerRadius = UDim.new(0, 6)
BtnStop.MouseButton1Click:Connect(function()
    _G.BossFarmTarget = nil
    _G.BossFarmEnabled = false
    currentTarget = nil
    StatusLabel.Text = "Фарм босса остановлен"
    DropBtn.Text = "Выбрать..."
end)

local function CreateToggleInline(parent, text, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.5
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = fontSizeMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    local Check = Instance.new("TextButton", Frame)
    Check.Size = UDim2.new(0, 25, 0, 25)
    Check.Position = UDim2.new(1, -35, 0.5, -12.5)
    Check.BackgroundColor3 = default and _G.AccentColor or Color3.fromRGB(20, 20, 20)
    Check.Text = ""
    Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 6)
    local state = default
    Check.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Check, TweenInfo.new(0.2), {BackgroundColor3 = state and _G.AccentColor or Color3.fromRGB(20, 20, 20)}):Play()
        pcall(callback, state)
    end)
end

local ToggleRow = Instance.new("Frame", BossFrame)
ToggleRow.Size = UDim2.new(1, 0, 0, 40)
ToggleRow.Position = UDim2.new(0, 0, 0, 130)
ToggleRow.BackgroundTransparency = 1
CreateToggleInline(ToggleRow, "Авто-фарм босса", false, function(s)
    _G.BossFarmEnabled = s
    if s then
        _G.AutoHaki = true
        _G.AutoInstinct = true
    end
    if not s then
        if _G.BossFarmTarget and currentTarget and currentTarget.Name == _G.BossFarmTarget then
            currentTarget = nil
        end
        StatusLabel.Text = "Авто-фарм босса отключён"
    else
        StatusLabel.Text = "Авто-фарм босса включён"
    end
end)

-- МОРСКИЕ СОБЫТИЯ
local SeaEventsSeparator = Instance.new("Frame", BossTab)
SeaEventsSeparator.Size = UDim2.new(1, 0, 0, 10)
SeaEventsSeparator.BackgroundTransparency = 1

local SeaEventsLabel = Instance.new("TextLabel", BossTab)
SeaEventsLabel.Size = UDim2.new(1, 0, 0, 30)
SeaEventsLabel.BackgroundTransparency = 1
SeaEventsLabel.Text = "🌊 Морские события"
SeaEventsLabel.TextColor3 = _G.AccentColor
SeaEventsLabel.Font = Enum.Font.GothamBold
SeaEventsLabel.TextSize = fontSizeMedium
SeaEventsLabel.TextXAlignment = Enum.TextXAlignment.Left

CreateToggleInline(BossTab, "Фарм Sea Beast", _G.SeaBeastFarm, function(s) _G.SeaBeastFarm = s end)
CreateToggleInline(BossTab, "Фарм Leviathan", _G.LeviathanFarm, function(s) _G.LeviathanFarm = s end)
CreateToggleInline(BossTab, "Фарм Terrorshark", _G.TerrorsharkFarm, function(s) _G.TerrorsharkFarm = s end)
CreateToggleInline(BossTab, "Фарм Hydra", _G.HydraFarm, function(s) _G.HydraFarm = s end)
CreateToggleInline(BossTab, "Фарм Ghost Ship", _G.GhostShipFarm, function(s) _G.GhostShipFarm = s end)
CreateToggleInline(BossTab, "Фарм Piranha", _G.PiranhaFarm, function(s) _G.PiranhaFarm = s end)

CreateSlider(BossTab, "Скорость полёта (Sea Events)", 100, 350, _G.SeaEventFlySpeed, function(v) _G.SeaEventFlySpeed = v end)
CreateSlider(BossTab, "Высота над событием", 50, 150, _G.SeaEventHoverHeight, function(v) _G.SeaEventHoverHeight = v end)

-- НАСТРОЙКИ
-- ----------------------------------------------------------------------
-- НАДЁЖНЫЕ НАСТРОЙКИ: NOCLIP + FULLBRIGHT
-- ----------------------------------------------------------------------
local savedCollision = {}
local savedLighting = nil

local function SaveLightingState()
    if savedLighting then return end
    savedLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top,
    }
end

local function EnableFullBright()
    SaveLightingState()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
    Lighting.ColorShift_Top = Color3.new(0, 0, 0)
end

local function DisableFullBright()
    if not savedLighting then return end
    for property, value in pairs(savedLighting) do
        pcall(function() Lighting[property] = value end)
    end
    savedLighting = nil
end

local function ApplyNoclip(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if savedCollision[part] == nil then
                savedCollision[part] = part.CanCollide
            end
            part.CanCollide = false
        end
    end
end

local function RestoreNoclip()
    for part, value in pairs(savedCollision) do
        if part and part.Parent then
            pcall(function() part.CanCollide = value end)
        end
    end
    table.clear(savedCollision)
end

RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if _G.Noclip then
        ApplyNoclip(character)
    else
        if next(savedCollision) then RestoreNoclip() end
    end
end)

RunService.Heartbeat:Connect(function()
    if _G.FullBrightEnabled then
        EnableFullBright()
    elseif savedLighting then
        DisableFullBright()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    table.clear(savedCollision)
    character:WaitForChild("HumanoidRootPart", 5)
    task.wait(0.1)
    if _G.Noclip then ApplyNoclip(character) end
    if _G.FullBrightEnabled then EnableFullBright() end
end)

CreateSlider(SettingsTab, "Скорость Полета (Автофарм)", 100, 450, _G.FarmSpeed, function(v) _G.FarmSpeed = v end)
CreateSlider(SettingsTab, "Интервал кликов (мс)", 5, 200, _G.ClickInterval, function(v) _G.ClickInterval = v end)
CreateToggle(SettingsTab, "Noclip (Сквозь Стены)", _G.Noclip, function(s)
    _G.Noclip = s
    if not s then RestoreNoclip() else ApplyNoclip(LocalPlayer.Character) end
end)
CreateToggle(SettingsTab, "Бесконечные Прыжки", _G.InfJump, function(s) _G.InfJump = s end)
CreateToggle(SettingsTab, "Включить Полет (Fly)", _G.FlyEnabled, function(s) _G.FlyEnabled = s end)
CreateSlider(SettingsTab, "Скорость Полета (Fly)", 10, 300, _G.FlySpeed, function(v) _G.FlySpeed = v end)
CreateToggle(SettingsTab, "Своя Скорость Игрока", _G.WalkSpeedEnabled, function(s) _G.WalkSpeedEnabled = s end)
CreateSlider(SettingsTab, "Скорость (WalkSpeed)", 16, 250, _G.WalkSpeed, function(v) _G.WalkSpeed = v end)
CreateToggle(SettingsTab, "Свой Прыжок", _G.JumpPowerEnabled, function(s) _G.JumpPowerEnabled = s end)
CreateSlider(SettingsTab, "Прыжок (JumpPower)", 50, 250, _G.JumpPower, function(v) _G.JumpPower = v end)
CreateToggle(SettingsTab, "FullBright (Яркость)", _G.FullBrightEnabled, function(s)
    _G.FullBrightEnabled = s
    if s then EnableFullBright() else DisableFullBright() end
end)

-- Выбор темы
CreateDropdown(SettingsTab, "Тема интерфейса", function()
    local themeNames = {}
    for name, _ in pairs(Themes) do
        table.insert(themeNames, name)
    end
    table.sort(themeNames)
    return themeNames
end, function(selectedTheme)
    _G.Theme = selectedTheme
    ApplyTheme(selectedTheme)
end)

-- ФУНКЦИЯ ApplyTheme (должна быть определена до использования)
function ApplyTheme(themeName)
    local newAccent = Themes[themeName]
    if not newAccent then return end
    local oldAccent = _G.AccentColor
    _G.AccentColor = newAccent

    local function updateElement(element)
        pcall(function()
            if element:IsA("GuiObject") then
                if element.BackgroundColor3 == oldAccent then
                    element.BackgroundColor3 = newAccent
                end
                if element.TextColor3 == oldAccent then
                    element.TextColor3 = newAccent
                end
            elseif element:IsA("UIStroke") then
                if element.Color == oldAccent then
                    element.Color = newAccent
                end
            end
        end)
    end

    local function traverse(parent)
        for _, child in ipairs(parent:GetChildren()) do
            updateElement(child)
            traverse(child)
        end
    end
    traverse(BlackHoleHub)
end

-- КОНФИГ (с выпадающим списком)
local ConfigNameBox = Instance.new("TextBox")
ConfigNameBox.Size = UDim2.new(1, -20, 0, 40)
ConfigNameBox.Position = UDim2.new(0, 10, 0, 10)
ConfigNameBox.PlaceholderText = "Введите название конфига"
ConfigNameBox.Text = "default"
ConfigNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ConfigNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigNameBox.Font = Enum.Font.GothamSemibold
ConfigNameBox.TextSize = fontSizeMedium
ConfigNameBox.Parent = ConfigTab

local SaveButton = Instance.new("TextButton")
SaveButton.Size = UDim2.new(1, -20, 0, 40)
SaveButton.Position = UDim2.new(0, 10, 0, 60)
SaveButton.BackgroundColor3 = _G.AccentColor
SaveButton.Text = "💾 Сохранить конфиг"
SaveButton.TextColor3 = Color3.fromRGB(0, 0, 0)
SaveButton.Font = Enum.Font.GothamBold
SaveButton.TextSize = fontSizeMedium
SaveButton.Parent = ConfigTab
Instance.new("UICorner", SaveButton).CornerRadius = UDim.new(0, 6)

local LoadButton = Instance.new("TextButton")
LoadButton.Size = UDim2.new(1, -20, 0, 40)
LoadButton.Position = UDim2.new(0, 10, 0, 110)
LoadButton.BackgroundColor3 = _G.AccentColor
LoadButton.Text = "📂 Загрузить конфиг"
LoadButton.TextColor3 = Color3.fromRGB(0, 0, 0)
LoadButton.Font = Enum.Font.GothamBold
LoadButton.TextSize = fontSizeMedium
LoadButton.Parent = ConfigTab
Instance.new("UICorner", LoadButton).CornerRadius = UDim.new(0, 6)

local function SerializeConfigValue(value)
    if typeof(value) == "Color3" then
        return {__type = "Color3", R = value.R, G = value.G, B = value.B}
    end
    return value
end

local function DeserializeConfigValue(value)
    if type(value) == "table" and value.__type == "Color3" then
        return Color3.new(value.R or 1, value.G or 1, value.B or 1)
    end
    return value
end

local function GetConfigData()
    local data = {}
    for key, value in pairs(_G) do
        local valueType = typeof(value)
        if valueType == "boolean" or valueType == "number" or valueType == "string" or valueType == "Color3" then
            data[key] = SerializeConfigValue(value)
        end
    end
    return data
end

local function ApplyLoadedConfig(result)
    for key, value in pairs(result) do
        if _G[key] ~= nil then
            local decoded = DeserializeConfigValue(value)
            local expected = typeof(_G[key])
            if expected == "boolean" and type(decoded) == "boolean" then
                _G[key] = decoded
            elseif expected == "number" and type(decoded) == "number" then
                _G[key] = decoded
            elseif expected == "string" and type(decoded) == "string" then
                _G[key] = decoded
            elseif expected == "Color3" and typeof(decoded) == "Color3" then
                _G[key] = decoded
            end
        end
    end
end

local function SaveConfig()
    local configName = tostring(ConfigNameBox.Text or "default"):gsub("[^%w_%-%s]", ""):sub(1, 40)
    if configName == "" then configName = "default" end

    if not writefile then
        warn("⚠️ Функция writefile недоступна. Сохранение невозможно.")
        return
    end

    local folder = "BlackHoleHub-Config-"
    pcall(function()
        if not isfolder(folder) then makefolder(folder) end
    end)

    local success, jsonData = pcall(function()
        return HttpService:JSONEncode(GetConfigData())
    end)
    if not success then
        warn("⚠️ Не удалось сериализовать конфиг: " .. tostring(jsonData))
        return
    end

    local filePath = folder .. "/" .. configName .. ".json"
    local ok, err = pcall(function() writefile(filePath, jsonData) end)
    if ok then
        print("✅ Конфиг сохранён: " .. filePath)
    else
        warn("⚠️ Ошибка записи конфига: " .. tostring(err))
    end
end
SaveButton.MouseButton1Click:Connect(SaveConfig)

local function LoadConfig()
    local configName = tostring(ConfigNameBox.Text or "default"):gsub("[^%w_%-%s]", ""):sub(1, 40)
    if configName == "" then configName = "default" end
    local folder = "BlackHoleHub-Config-"
    local filePath = folder .. "/" .. configName .. ".json"

    if not readfile or not isfile then
        warn("⚠️ readfile/isfile недоступны. Загрузка невозможна.")
        return
    end
    if not isfile(filePath) then
        warn("⚠️ Конфиг не найден: " .. filePath)
        return
    end

    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(filePath))
    end)
    if not success or type(result) ~= "table" then
        warn("⚠️ Не удалось разобрать конфиг.")
        return
    end

    ApplyLoadedConfig(result)
    if _G.Noclip then
        ApplyNoclip(LocalPlayer.Character)
    else
        RestoreNoclip()
    end
    if _G.FullBrightEnabled then
        EnableFullBright()
    else
        DisableFullBright()
    end
    ApplyTheme(_G.Theme)
    print("✅ Конфиг загружен: " .. configName)
end
LoadButton.MouseButton1Click:Connect(LoadConfig)

-- Выпадающий список конфигов
CreateDropdown(ConfigTab, "Существующие конфиги", function()
    local files = {}
    if listfiles then
        local folder = "BlackHoleHub-Config-"
        if isfolder(folder) then
            for _, file in ipairs(listfiles(folder)) do
                if file:sub(-5) == ".json" then
                    local name = file:match("([^/]+)%.json$")
                    if name then table.insert(files, name) end
                end
            end
        end
    end
    if #files == 0 then table.insert(files, "Нет конфигов") end
    return files
end, function(selected)
    if selected ~= "Нет конфигов" then
        ConfigNameBox.Text = selected
    end
end)

------------------------------------------------------------------------
-- ESP ДЛЯ ФРУКТОВ И СУНДУКОВ
------------------------------------------------------------------------
local function GetFruitLocation(position, fruit)
    if fruit then
        local attr = fruit:GetAttribute("Location") or fruit:GetAttribute("Island") or fruit:GetAttribute("Zone")
        if type(attr) == "string" and attr ~= "" then return attr end

        local parent = fruit.Parent
        for _ = 1, 4 do
            if not parent then break end
            local name = parent.Name
            if name and name ~= "Workspace" and name ~= "Map" and name ~= "Tools" and name ~= "Items" then
                if name:lower():find("island") or name:lower():find("sea") or name:lower():find("town") or name:lower():find("village") or name:lower():find("castle") or name:lower():find("city") then
                    return name
                end
            end
            parent = parent.Parent
        end
    end
    return nil
end

local function createESP(text, color)
    if not Drawing then return nil end
    local esp = Drawing.new("Text")
    esp.Text = text
    esp.Color = color or Color3.fromRGB(255, 255, 255)
    esp.Size = 14
    esp.Center = true
    esp.Outline = true
    esp.Visible = false
    return esp
end

local fruitESP = createESP("🍎 Фрукт | 0м", Color3.fromRGB(255, 200, 0))
local chestESP = createESP("Сундук: 0м", Color3.fromRGB(0, 200, 255))

local nearestFruitCache = nil
local nearestFruitDistCache = math.huge
local fruitLocationCache = nil

-- Держим список фруктов через события Workspace, чтобы не делать GetDescendants каждый кадр.
local fruitObjects = {}
local function IsFruitObject(obj)
    if not obj or not obj:IsA("Tool") or not obj:FindFirstChild("Handle") then return false end
    local lower = obj.Name:lower()
    return lower:find("fruit") ~= nil or lower:find("devil") ~= nil
end

for _, obj in ipairs(Workspace:GetDescendants()) do
    if IsFruitObject(obj) then
        fruitObjects[obj] = true
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    if IsFruitObject(obj) then fruitObjects[obj] = true end
end)
Workspace.DescendantRemoving:Connect(function(obj)
    fruitObjects[obj] = nil
end)

task.spawn(function()
    while task.wait(0.25) do
        if not _G.FruitESPEnabled then
            nearestFruitCache = nil
            nearestFruitDistCache = math.huge
            fruitLocationCache = nil
            continue
        end

        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then
            nearestFruitCache = nil
            continue
        end

        local nearestFruit = nil
        local nearestDist = math.huge
        for obj in pairs(fruitObjects) do
            if not obj.Parent or not IsFruitObject(obj) then
                fruitObjects[obj] = nil
            else
                local handle = obj:FindFirstChild("Handle")
                local dist = handle and (root.Position - handle.Position).Magnitude
                if dist and dist < nearestDist then
                    nearestDist = dist
                    nearestFruit = obj
                end
            end
        end
        nearestFruitCache = nearestFruit
        nearestFruitDistCache = nearestDist
        fruitLocationCache = nearestFruit and GetFruitLocation(nearestFruit.Handle.Position, nearestFruit) or nil
    end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        if fruitESP then fruitESP.Visible = false end
        if chestESP then chestESP.Visible = false end
        return
    end

    if _G.FruitESPEnabled and nearestFruitCache and nearestFruitCache.Parent and nearestFruitCache:FindFirstChild("Handle") then
        local locationText = fruitLocationCache and (" | " .. fruitLocationCache) or ""
        fruitESP.Text = string.format("🍎 %s | %.0fм%s", nearestFruitCache.Name, nearestFruitDistCache, locationText)
        local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(nearestFruitCache.Handle.Position)
        fruitESP.Position = Vector2.new(screenPos.X, screenPos.Y)
        fruitESP.Visible = onScreen
    else
        fruitESP.Visible = false
    end

    if _G.AutoChestSteal then
        local nearestChest = nil
        local nearestDist = math.huge
        local chestsFolder = Workspace:FindFirstChild("ChestModels")
        local searchList = chestsFolder and chestsFolder:GetChildren() or {}
        for _, chest in ipairs(searchList) do
            if chest:IsA("Model") and chest:FindFirstChildWhichIsA("BasePart") then
                local part = chest:FindFirstChildWhichIsA("BasePart")
                local dist = (root.Position - part.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestChest = part
                end
            end
        end
        if nearestChest then
            chestESP.Text = string.format("📦 Сундук: %.0fм", nearestDist)
            local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(nearestChest.Position)
            chestESP.Position = Vector2.new(screenPos.X, screenPos.Y)
            chestESP.Visible = onScreen
        else
            chestESP.Visible = false
        end
    else
        chestESP.Visible = false
    end
end)

------------------------------------------------------------------------
-- ГЛАВНЫЙ ЦИКЛ ФАРМА
-- Buso Haki: включается 1 раз после включения AutoHaki
-- Instinct: переключается каждые 5 секунд
-- Мобильный ввод: те же key events используются на телефоне
------------------------------------------------------------------------

task.spawn(function()
    local lastInstinctPress = 0
    local hakiActivated = false
    local noMobSince = 0

    while task.wait(0.1) do

        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if not char or not root or not humanoid or humanoid.Health <= 0 then
            currentTarget = nil
            task.wait(0.5)
            continue
        end

        ----------------------------------------------------------------
        -- BUSO HAKI
        -- J нажимается только один раз за одно включение AutoHaki.
        ----------------------------------------------------------------
        if _G.AutoHaki then
            if not hakiActivated then
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.J, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.J, false, game)
                end)

                hakiActivated = true
                print("🔴 Buso Haki включён")
            end
        else
            -- После выключения разрешаем одно новое нажатие J.
            hakiActivated = false
        end

        ----------------------------------------------------------------
        -- KEN HAKI / INSTINCT
        -- E: включить -> 5 секунд -> выключить -> 5 секунд -> включить...
        ----------------------------------------------------------------
        if _G.AutoInstinct then
            if os.clock() - lastInstinctPress >= 5 then
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end)

                lastInstinctPress = os.clock()
                print("🔵 Переключён Ken Haki / Instinct")
            end
        else
            lastInstinctPress = 0
        end

        ----------------------------------------------------------------
        -- БОСС
        ----------------------------------------------------------------
        if _G.BossFarmEnabled and _G.BossFarmTarget then
            pcall(function()
                local boss = FindNPCByName(_G.BossFarmTarget)

                if not boss then
                    local spawnPos = BossSpawnLocations[_G.BossFarmTarget]
                    if spawnPos then
                        SmoothFlyTween(spawnPos)
                        task.wait(2)
                        boss = FindNPCByName(_G.BossFarmTarget)
                    end
                end

                if boss then
                    currentTarget = boss
                    EquipWeapon()

                    while boss
                        and boss.Parent
                        and boss:FindFirstChildOfClass("Humanoid")
                        and boss:FindFirstChild("HumanoidRootPart")
                        and boss:FindFirstChildOfClass("Humanoid").Health > 0
                        and _G.BossFarmEnabled do

                        local currentChar = LocalPlayer.Character
                        local currentHumanoid = currentChar
                            and currentChar:FindFirstChildOfClass("Humanoid")
                        local currentRoot = currentChar
                            and currentChar:FindFirstChild("HumanoidRootPart")

                        if not currentChar
                            or not currentRoot
                            or not currentHumanoid
                            or currentHumanoid.Health <= 0 then
                            break
                        end

                        EquipWeapon()
                        ClickAttack()
                        SpamSkills()

                        task.wait((_G.ClickInterval or 100) / 1000)
                    end

                    currentTarget = nil
                end
            end)

            continue
        end

        ----------------------------------------------------------------
        -- МОРСКИЕ СОБЫТИЯ
        ----------------------------------------------------------------
        if _G.SeaBeastFarm then FarmSeaEvent("SeaBeast") end
        if _G.LeviathanFarm then FarmSeaEvent("Leviathan") end
        if _G.TerrorsharkFarm then FarmSeaEvent("Terrorshark") end
        if _G.HydraFarm then FarmSeaEvent("Hydra") end
        if _G.GhostShipFarm then FarmSeaEvent("Ghost Ship") end
        if _G.PiranhaFarm then FarmSeaEvent("Piranha") end

        ----------------------------------------------------------------
        -- АВТОФАРМ КВЕСТОВ
        ----------------------------------------------------------------
        if _G.AutoFarmLevel then
            pcall(function()
                if not QuestState.Active then
                    EnsureQuest()
                    noMobSince = 0
                    task.wait(0.1)
                    return
                end

                local progress = GetQuestProgressFromGui(QuestState.Required)

                if progress ~= nil then
                    QuestState.LastProgress = progress

                    if progress > QuestState.Kills then
                        QuestState.Kills = math.min(progress, QuestState.Required)
                    end
                end

                if IsQuestComplete() then
                    currentTarget = nil

                    if TryTurnInQuest() then
                        noMobSince = 0
                        task.wait(0.25)
                    else
                        task.wait(0.5)
                    end

                    return
                end

                local target = FindQuestEnemy(QuestState.TargetName)

                if target then
                    noMobSince = 0
                    currentTarget = target

                    local targetRoot = target:FindFirstChild("HumanoidRootPart")
                    local currentRoot = LocalPlayer.Character
                        and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                    if targetRoot and currentRoot then
                        local dist = (currentRoot.Position - targetRoot.Position).Magnitude

                        if dist > _G.FarmDistance + 5 then
                            SmoothFlyTween(targetRoot.Position)
                        end
                    end

                    EquipWeapon()

                    while target
                        and target.Parent
                        and target:FindFirstChildOfClass("Humanoid")
                        and target:FindFirstChild("HumanoidRootPart")
                        and target:FindFirstChildOfClass("Humanoid").Health > 0
                        and _G.AutoFarmLevel
                        and QuestState.Active do

                        local currentChar = LocalPlayer.Character
                        local currentHumanoid = currentChar
                            and currentChar:FindFirstChildOfClass("Humanoid")
                        local currentRoot = currentChar
                            and currentChar:FindFirstChild("HumanoidRootPart")

                        if not currentChar
                            or not currentRoot
                            or not currentHumanoid
                            or currentHumanoid.Health <= 0 then
                            break
                        end

                        local liveProgress = GetQuestProgressFromGui(QuestState.Required)

                        if liveProgress ~= nil then
                            QuestState.LastProgress = liveProgress

                            if liveProgress > QuestState.Kills then
                                QuestState.Kills = math.min(
                                    liveProgress,
                                    QuestState.Required
                                )
                            end

                            if liveProgress >= QuestState.Required then
                                break
                            end
                        end

                        BindMobDeath(target)
                        EquipWeapon()
                        ClickAttack()
                        SpamSkills()

                        task.wait((_G.ClickInterval or 100) / 1000)
                    end

                    currentTarget = nil
                    return
                end

                if noMobSince == 0 then
                    noMobSince = os.clock()
                end

                if IsQuestComplete() then
                    currentTarget = nil
                    TryTurnInQuest()
                    return
                end

                if os.clock() - noMobSince < QUEST_NO_MOB_GRACE then
                    task.wait(0.2)
                    return
                end

                task.wait(0.3)
            end)

            continue
        end

        if QuestState.Active then
            ClearQuestState()
        end

        currentTarget = nil
        task.wait(0.5)
    end
end)

------------------------------------------------------------------------
-- ОТДЕЛЬНЫЙ ПОТОК ДЛЯ ФАРМА В РАДИУСЕ 1000 МЕТРОВ
-- Полностью без квестов. Не использует currentTarget, чтобы не мешать
-- оригинальному квестовому Auto Farm.
-- Движение повторяет ту же формулу AttackSide/FarmDistance/FarmSpeed.
------------------------------------------------------------------------
do
    local killAuraTarget = nil
    local enemyCache = {}
    local enemyFolder = nil

    local function IsEnemyModel(obj)
        if not obj or not obj:IsA("Model") then return false end
        if obj == LocalPlayer.Character then return false end
        if Players:GetPlayerFromCharacter(obj) then return false end
        local hum = obj:FindFirstChildOfClass("Humanoid")
        local root = obj:FindFirstChild("HumanoidRootPart")
        return hum and root and hum.Health > 0
    end

    local function AddEnemy(obj)
        if IsEnemyModel(obj) then enemyCache[obj] = true end
    end

    local function RemoveEnemy(obj)
        enemyCache[obj] = nil
        if killAuraTarget == obj then killAuraTarget = nil end
    end

    local function ScanEnemies()
        table.clear(enemyCache)
        local folder = Workspace:FindFirstChild("Enemies")
        if not folder then return end
        enemyFolder = folder
        for _, obj in ipairs(folder:GetChildren()) do
            AddEnemy(obj)
        end
    end

    local function HookEnemyFolder(folder)
        if not folder or enemyFolder == folder then return end
        enemyFolder = folder
        folder.ChildAdded:Connect(function(obj)
            task.defer(AddEnemy, obj)
        end)
        folder.ChildRemoved:Connect(RemoveEnemy)
        ScanEnemies()
    end

    local function GetNearestEnemy(root)
        if not root then return nil end
        local nearest, nearestDistance = nil, 1000
        for mob in pairs(enemyCache) do
            if not mob or not mob.Parent then
                enemyCache[mob] = nil
            else
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                if hum and mobRoot and hum.Health > 0 then
                    local dist = (root.Position - mobRoot.Position).Magnitude
                    if dist <= 1000 and dist < nearestDistance then
                        nearest, nearestDistance = mob, dist
                    end
                end
            end
        end
        return nearest
    end

    ScanEnemies()
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Enemies" then
            task.wait()
            HookEnemyFolder(child)
        end
    end)

    task.spawn(function()
        while task.wait(0.08) do
            if not _G.KillAuraRadius or _G.GUIOpen or _G.AutoFarmLevel then
                killAuraTarget = nil
                continue
            end

            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root or not hum or hum.Health <= 0 then
                killAuraTarget = nil
                continue
            end

            local folder = Workspace:FindFirstChild("Enemies")
            if folder ~= enemyFolder then
                HookEnemyFolder(folder)
            end

            local target = killAuraTarget
            local targetHum = target and target:FindFirstChildOfClass("Humanoid")
            local targetRoot = target and target:FindFirstChild("HumanoidRootPart")
            if not target
                or not target.Parent
                or not targetHum
                or targetHum.Health <= 0
                or not targetRoot
                or (root.Position - targetRoot.Position).Magnitude > 1000 then
                target = GetNearestEnemy(root)
                killAuraTarget = target
            end

            if not target then continue end

            -- Атака та же: выбранное оружие + клик + скиллы + интервал.
            EquipWeapon()
            ClickAttack()
            SpamSkills()

            task.wait((_G.ClickInterval or 100) / 1000)
        end
    end)

    -- Отдельный контроллер движения только для 1000м.
    -- Квестовый Auto Farm использует свой оригинальный currentTarget-контроллер.
    RunService.RenderStepped:Connect(function(deltaTime)
        if not _G.KillAuraRadius or _G.GUIOpen or _G.AutoFarmLevel then return end
        local target = killAuraTarget
        if not target or not target.Parent then return end

        local char = LocalPlayer.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local mobRoot = target:FindFirstChild("HumanoidRootPart")
        local mobHum = target:FindFirstChildOfClass("Humanoid")
        if not myRoot or not humanoid or humanoid.Health <= 0 or not mobRoot or not mobHum or mobHum.Health <= 0 then return end
        if (myRoot.Position - mobRoot.Position).Magnitude > 1000 then return end

        local targetCF
        if _G.AttackSide == "Сверху" then
            targetCF = CFrame.lookAt(mobRoot.Position + Vector3.new(0, _G.FarmDistance, 0), mobRoot.Position)
        elseif _G.AttackSide == "Снизу" then
            targetCF = CFrame.lookAt(mobRoot.Position - Vector3.new(0, _G.FarmDistance, 0), mobRoot.Position)
        else
            local behindPos = (mobRoot.CFrame * CFrame.new(0, 0, _G.FarmDistance)).Position
            targetCF = CFrame.lookAt(behindPos, mobRoot.Position)
        end

        local dist = (myRoot.Position - targetCF.Position).Magnitude
        local moveStep = (_G.FarmSpeed or 250) * deltaTime
        if dist > 2 then
            local direction = targetCF.Position - myRoot.Position
            if direction.Magnitude > 0 then
                local newPos = myRoot.Position + direction.Unit * math.min(moveStep, dist)
                myRoot.CFrame = CFrame.lookAt(newPos, mobRoot.Position)
            end
        else
            myRoot.CFrame = targetCF
        end
    end)
end

-- УМНЫЕ ФРУКТЫ И СУНДУКИ (полёт с использованием FlyToPosition)
------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.4) do
        if _G.AutoChestSteal and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local chests = {}
            if Workspace:FindFirstChild("ChestModels") then
                for _, chest in ipairs(Workspace.ChestModels:GetChildren()) do
                    if chest:IsA("Model") and chest:FindFirstChildWhichIsA("BasePart") then
                        local p = chest:FindFirstChildWhichIsA("BasePart")
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Position).Magnitude
                        table.insert(chests, {model = chest, part = p, dist = dist})
                    end
                end
            end
            if #chests > 0 then
                table.sort(chests, function(a, b) return a.dist < b.dist end)
                local nearestChest = chests[1]
                FlyToPosition(nearestChest.part.Position)
                task.wait(0.2)
                pcall(function()
                    local prompt = nearestChest.model:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then fireproximityprompt(prompt) end
                end)
            end
        end
    end
end)

------------------------------------------------------------------------
-- ПЛАВНЫЙ ПОЛЕТ И АТАКА (для одного врага) — используется основным циклом
------------------------------------------------------------------------
RunService.RenderStepped:Connect(function(deltaTime)
    if not currentTarget then return end
    if not currentTarget.Parent or not currentTarget:FindFirstChild("HumanoidRootPart") then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    local mobRoot = currentTarget.HumanoidRootPart
    local myRoot = char.HumanoidRootPart

    myRoot.Velocity = Vector3.zero
    myRoot.RotVelocity = Vector3.zero
    for _, force in ipairs(myRoot:GetChildren()) do
        if force:IsA("BodyVelocity") or force:IsA("BodyPosition") or force:IsA("BodyForce") or force:IsA("BodyGyro") then
            force:Destroy()
        end
    end

    local targetCF
    if _G.AttackSide == "Сверху" then
        targetCF = CFrame.lookAt(mobRoot.Position + Vector3.new(0, _G.FarmDistance, 0), mobRoot.Position)
    elseif _G.AttackSide == "Снизу" then
        targetCF = CFrame.lookAt(mobRoot.Position - Vector3.new(0, _G.FarmDistance, 0), mobRoot.Position)
    elseif _G.AttackSide == "Со спины" then
        local behindPos = (mobRoot.CFrame * CFrame.new(0, 0, _G.FarmDistance)).Position
        targetCF = CFrame.lookAt(behindPos, mobRoot.Position)
    end

    local dist = (myRoot.Position - targetCF.Position).Magnitude
    local moveStep = _G.FarmSpeed * deltaTime

    if dist > 2 then
        local newPos = myRoot.Position + (targetCF.Position - myRoot.Position).Unit * math.min(moveStep, dist)
        myRoot.CFrame = CFrame.lookAt(newPos, mobRoot.Position)
    else
        myRoot.CFrame = targetCF
    end
end)

-- Активация первой вкладки
Tabs[1].Page.Visible = true
TweenService:Create(Tabs[1].Btn, TweenInfo.new(0.2), {BackgroundColor3 = _G.AccentColor, TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
