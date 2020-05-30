local function starts_with(str, start)
    return str:sub(1, #start) == start
end

for _, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes

    for _, tech_table in pairs(technologies) do
        if tech_table.researched then
            if tech_table.effects then
                for _, effect in pairs(tech_table.effects) do
                    if effect.type == "unlock-recipe" then
                        if starts_with(effect.recipe, "stackedrecipes") then
                            recipes[effect.recipe].enabled = true
                            recipes[effect.recipe].reload()
                        end
                    end
                end
            end
        end
    end
end
