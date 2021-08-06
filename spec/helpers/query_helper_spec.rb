require 'rails_helper'

RSpec.describe QueryHelper, type: :helper do
    describe "#build_query" do
      it "builds a simple query" do
        input = ["poire"]
        
        output = <<~HEREDOC.strip
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
            where value ilike '%' || $1 || '%'
            group by id
          )
          select *
            , ingredients_matched::decimal / ingredients_total::decimal as ingredients_percentage_matched
          from matches
          order by ingredients_percentage_matched DESC
          limit 50;
        HEREDOC

        expect(helper.build_query(input)).to eq(output)
      end
    
      it "builds complex queries" do
        input = ["poire", "oeuf", "veau"]
        
        output = <<~HEREDOC.strip
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
            where value ilike '%' || $1 || '%' or value ilike '%' || $2 || '%' or value ilike '%' || $3 || '%'
            group by id
          )
          select *
            , ingredients_matched::decimal / ingredients_total::decimal as ingredients_percentage_matched
          from matches
          order by ingredients_percentage_matched DESC
          limit 50;
        HEREDOC
        
        expect(helper.build_query(input)).to eq(output)
    end
  end
end
