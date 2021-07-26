require 'rails_helper'

RSpec.describe QueryHelper, type: :helper do
    describe "#build_query" do
      it "builds a simple query" do
        input = ["poire"]
        
        output = <<~HEREDOC.strip
          select id
          , (data -> 'name') as name
          , (data -> 'tags') as tags
          , (data -> 'image') as image_url
          , (data -> 'cook_time') as cook_time
          , (data -> 'prep_time') as prep_time
          , (data -> 'total_time') as total_time
          , (data -> 'ingredients') as ingredients
          from recipes, jsonb_array_elements_text(data -> 'ingredients')
          where value ilike $1::text
          order by image_url desc;
        HEREDOC
        
        expect(helper.build_query(input)).to eq(output)
      end
    
      it "builds complex queries" do
        input = ["poire", "oeuf", "veau"]
        
        output = <<~HEREDOC.strip
          select id
          , (data -> 'name') as name
          , (data -> 'tags') as tags
          , (data -> 'image') as image_url
          , (data -> 'cook_time') as cook_time
          , (data -> 'prep_time') as prep_time
          , (data -> 'total_time') as total_time
          , (data -> 'ingredients') as ingredients
          from recipes, jsonb_array_elements_text(data -> 'ingredients')
          where value ilike $1::text
          and id in (
            select id
            from recipes, jsonb_array_elements_text(data -> 'ingredients')
            where value ilike $2::text
          )
          and id in (
            select id
            from recipes, jsonb_array_elements_text(data -> 'ingredients')
            where value ilike $3::text
          )
          order by image_url desc;
        HEREDOC
        
        expect(helper.build_query(input)).to eq(output)
    end
  end
end
