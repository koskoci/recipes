class RecipesController < ApplicationController
  def index
    @recipes = helpers.conn.exec(query).values
  end
  
  private
  def query
    <<~HEREDOC.strip
      select id, (data -> 'name') as name
      from recipes, jsonb_array_elements_text(data -> 'ingredients')
      where value ilike '%oeuf%'
      and id in (
        select id
        from recipes, jsonb_array_elements_text(data -> 'ingredients')
        where value ilike '%viande%'
      )
      and id in (
        select id
        from recipes, jsonb_array_elements_text(data -> 'ingredients')
        where value ilike '%sel%'
      );
    HEREDOC
  end
end
