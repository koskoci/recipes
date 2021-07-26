module RecipesHelper
  def deserialize(result)
    objects_from(result).map { |recipe| humanize(recipe) }
  end

  private

  def objects_from(result)
    fields = result.fields
    
    result.values.map do |value_set| 
      OpenStruct.new(Hash[fields.zip(value_set)])
    end
  end

  def humanize(recipe)
    recipe.name = recipe.name[1..-2]
    recipe.image_url = recipe.image_url[1..-2]
    recipe.ingredients = recipe.ingredients[2..-3].split("\", \"")
    recipe.time_needed = 
      recipe.prep_time[1..-2] + " prep time + " +
      recipe.cook_time[1..-2] + " cook time = " +
      recipe.total_time[1..-2]
      
    recipe
  end
end