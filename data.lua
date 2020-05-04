if not settings.startup["deadlock-enable-beltboxes"].value then
    return
end

local function get_localised_name(item_name)
	if data.raw.item[item_name] and data.raw.item[item_name].localised_name then
		return data.raw.item[item_name].localised_name
	else
		return {"item-name."..item_name}
	end
end

local craftSize = settings.startup["stackedrecipes-multiplier"].value * settings.startup["deadlock-stack-size"].value
local items = { "iron-ore", "copper-ore", "stone", "coal", "uranium-ore" }

for i,item in ipairs(items) do
	data:extend{
        {
            type = "recipe",
            name = string.format("stackedrecipes-%s", item),
            enabled = false,
            localised_name = {"item-name.stackedrecipes", get_localised_name(item), settings.startup["deadlock-stack-size"].value},
            ingredients =
            {
                {item, craftSize}
            },
            hide_from_player_crafting = true,
            results= {
                {
                    type = "item", name = string.format("deadlock-stack-%s", item), amount = settings.startup["stackedrecipes-multiplier"].value
                }
            }
        }
    }

    table.insert(data.raw["technology"]["deadlock-stacking-1"].effects, {
                                                                            type = "unlock-recipe",
                                                                            recipe = string.format("stackedrecipes-%s", item)
                                                                        })

end

