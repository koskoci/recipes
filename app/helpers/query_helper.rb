module QueryHelper
  def build_query(keywords)
    keywords[1..].each_index.inject(query_for_first_keyword) do |acc, index|
      placeholder = (index + 2).to_s
      acc + "\n" + fragment_for(placeholder)
    end + "\n" + "order by image_url desc;"
  end
  
  private
  
  def query_for_first_keyword
    <<~HEREDOC.strip
      select id
      , (data -> 'name') as name
      , (data -> 'tags') as tags
      , (data -> 'image') as image_url
      , (data -> 'cook_time') as cook_time
      , (data -> 'prep_time') as prep_time
      , (data -> 'total_time') as total_time
      , (data -> 'ingredients') as ingredients
      from recipes, jsonb_array_elements_text(data -> 'ingredients')
      where value ILIKE '%' || $1 || '%'
    HEREDOC
  end
  
  def fragment_for(n)
    <<~HEREDOC.strip
    and id in (
      select id
      from recipes, jsonb_array_elements_text(data -> 'ingredients')
      where value ILIKE '%' || $#{n} || '%'
    )
    HEREDOC
  end
end
