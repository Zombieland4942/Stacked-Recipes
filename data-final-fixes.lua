if not settings.startup["deadlock-enable-beltboxes"].value then
    return
end

-- helper function to test for a member of a table
local function contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- helper function to test for start of string
local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function get_localised_name(item_name)
    log(item_name)
    if data.raw.item[item_name] and data.raw.item[item_name].localised_name then
        return data.raw.item[item_name].localised_name
    else
        return {"item-name." .. item_name}
    end
end

local craftSize = settings.startup["stackedrecipes-multiplier"].value * settings.startup["deadlock-stack-size"].value

-- using "data.raw.resource" find which resources have been stacked by deadlock bridges
local items = {}
for _, resource in pairs(data.raw.resource) do
    if resource.minable and (resource.minable.result or resource.minable.results) then
        local name = resource.minable.result or resource.minable.results[1] or nil
        if name then
            if data.raw.item[string.format("deadlock-stack-%s", name)] then
                table.insert(items, name)
            end
        end
    end
end

for _, item in ipairs(items) do
    data:extend {
        {
            type = "recipe",
            name = string.format("stackedrecipes-%s", item),
            enabled = false,
            localised_name = {"item-name.stackedrecipes", get_localised_name(item), settings.startup["deadlock-stack-size"].value},
            ingredients = {
                {item, craftSize}
            },
            hide_from_player_crafting = true,
            results = {
                {
                    type = "item",
                    name = string.format("deadlock-stack-%s", item),
                    amount = settings.startup["stackedrecipes-multiplier"].value
                }
            }
        }
    }
end

-- now add the bulk recipe to where ever the stacked recipe has been added
for tech, tech_table in pairs(data.raw.technology) do
    if tech_table.effects then
        for _, effect in pairs(tech_table.effects) do
            if effect.type == "unlock-recipe" then
                if starts_with(effect.recipe, "deadlock-stacks-stack") then
                    local element = string.sub(effect.recipe, 23)
                    if contains(items, element) then
                        table.insert(data.raw["technology"][tech].effects, {type = "unlock-recipe", recipe = string.format("stackedrecipes-%s", element)})
                    end
                end
            end
        end
    end
end
