
for index, force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes

  recipes["stackedrecipes-iron-ore"].enabled = technologies["deadlock-stacking-1"].researched
  recipes["stackedrecipes-copper-ore"].enabled = technologies["deadlock-stacking-1"].researched
  recipes["stackedrecipes-stone"].enabled = technologies["deadlock-stacking-1"].researched
  recipes["stackedrecipes-coal"].enabled = technologies["deadlock-stacking-1"].researched
  recipes["stackedrecipes-uranium-ore"].enabled = technologies["deadlock-stacking-1"].researched

end