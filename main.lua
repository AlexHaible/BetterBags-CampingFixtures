-- Variables --
---@class BetterBags: AceAddon
local BetterBags = LibStub('AceAddon-3.0'):GetAddon("BetterBags")
assert(BetterBags, "BetterBags - Camping Fixtures requires BetterBags")

---@class Categories: AceModule
local Categories = BetterBags:GetModule('Categories')

---@class Localization: AceModule
local L = BetterBags:GetModule('Localization')

---@class CampingFixtures: AceModule
local CampingFixtures = BetterBags:NewModule('CampingFixtures')

---@class AceDB-3.0: AceModule
local AceDB = LibStub("AceDB-3.0")

---@class Config: AceModule
local Config = BetterBags:GetModule('Config')

---@class Context: AceModule
local Context = BetterBags:GetModule('Context')

---@class Events: AceModule
local Events = BetterBags:GetModule('Events')

---@type string, AddonNS
local _, addon = ...

local _, _, _, interfaceVersion = GetBuildInfo()


local defaults = {
    profile = {}
}
local configOptions

-- List of Item IDs for Greedy Emissary
local campingFixtures = {
    -- Campfire
    279981, 279961, 279974,
    -- Cooking
    279957, 279982,
    -- Fishing
    279967, 279965, 279966,
    -- First Aid
    279968, 279940, 279951,
    -- Herbalism
    279962, 279964, 279947,
    -- Mining
    279960, 279948, 279952,
    -- Skinning
    279979, 279969, 279938,
    -- Tailoring
    279973, 279943, 279959,
    -- Leatherworking
    279978, 279941, 279945,
    -- Blacksmithing
    279944, 279988, 279955,
    -- Alchemy
    279956, 279970, 279990,
    -- Enchanting
    279976, 279985, 279987,
    -- Engineering
    279950, 279949, 279989
}

configOptions = {
    retailOptions = {
        name = L:G("Options"),
        type = "group",
        order = 1,
        inline = true,
        args = {
            forceRefreshCampingFixtures = {
                type = "execute",
                name = "Force Refresh",
                desc = "This will forcibly refresh the Camping Fixtures category.",
                func = function()
                    CampingFixtures:clearCampingFixturesCategory()

                    CampingFixtures:addCampingFixturesToCategory()
                    local ctx = Context:New('BBCampingFixtures_RefreshAll')
                    Events:SendMessage(ctx, 'bags/FullRefreshAll')
                end,
            },
        },
    },
}

function CampingFixtures:addCampingFixturesConfig()
    if not Config or not configOptions then
        print("Failed to load configurations for Camping Fixtures plugin.")
        return
    end

    Config:AddPluginConfig("CampingFixtures", configOptions)
end

function CampingFixtures:clearCampingFixturesCategory()
    Categories:WipeCategory(Context:New('BBCampingFixtures_DeleteCategory'),L:G("Camping Fixtures"))
end



function CampingFixtures:addCampingFixturesToCategory()
    local ctx = Context:New('BBCampingFixtures_AddItemToCategory')
    local categoryName = L:G("Camping Fixtures")
    -- Loop through list of campingfixtures and add to category.
    for _, itemID in ipairs(campingFixtures) do
        Categories:AddItemToCategory(ctx, itemID, categoryName)
    end
end

-- On plugin load, wipe the Categories we've added
function CampingFixtures:OnInitialize()
    self.db = AceDB:New("BetterBags_CampingFixturesDB", defaults)
    self.db:SetProfile("global")


    self:addCampingFixturesConfig()
    self:clearCampingFixturesCategory()

    self:addCampingFixturesToCategory()
end
