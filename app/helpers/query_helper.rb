module QueryHelper
  def build_query(keywords)
    <<~HEREDOC.strip
      with matches as (
        select id
          , (data -> 'name') as name
          , (data -> 'image') as image_url
          , (data -> 'cook_time') as cook_time
          , (data -> 'prep_time') as prep_time
          , (data -> 'total_time') as total_time
          , (data -> 'ingredients') as ingredients
          , count(id) as ingredients_matched
          , jsonb_array_length(data -> 'ingredients') as ingredients_total
        from recipes, jsonb_array_elements_text(data -> 'ingredients')
        #{where_ingredient_matches_any(keywords)}
        group by id
      )
      select *
        , ingredients_matched::decimal / ingredients_total::decimal as ingredients_percentage_matched
      from matches
      order by ingredients_percentage_matched DESC
      limit 50;
    HEREDOC
  end
  
  private
  
  def where_ingredient_matches_any(keywords)
    (1...keywords.count).inject("where value ilike '%' || $1 || '%'") do |acc, ordinal|
      acc + " or value ilike '%' || $#{ordinal + 1} || '%'"
    end
  end
end
