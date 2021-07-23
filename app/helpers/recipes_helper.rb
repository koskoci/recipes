module RecipesHelper
  def build_query (keywords)
    return nil if keywords.blank?
    
    keywords[1..].each_index.inject(query_for_first_keyword) do |acc, index|
      placeholder = (index + 2).to_s
      acc + "\n" + fragment_for(placeholder)
    end + ";"
  end
  
  private
  
  def query_for_first_keyword
    <<~HEREDOC.strip
      select id, data
      from recipes, jsonb_array_elements_text(data -> 'ingredients')
      where value ilike '%$1%'
    HEREDOC
  end
  
  def fragment_for(n)
    <<~HEREDOC.strip
    and id in (
      select id
      from recipes, jsonb_array_elements_text(data -> 'ingredients')
      where value ilike '%$#{n}%'
    )
    HEREDOC
  end
end
