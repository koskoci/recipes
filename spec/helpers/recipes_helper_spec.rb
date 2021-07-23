require 'rails_helper'

RSpec.describe RecipesHelper, type: :helper do
    describe "#build_query" do
      it "returns nil if input is empty" do
        input = []
        output = nil
        
        expect(helper.build_query(input)).to eq(output)
      end
      
      it "returns nil if input is nil" do
        input = nil
        output = nil
        
        expect(helper.build_query(input)).to eq(output)
      end
      
      it "builds a simple query" do
        input = ["poire"]
        
        output = <<~HEREDOC.strip
          select id, data
          from recipes, jsonb_array_elements_text(data -> 'ingredients')
          where value ilike '%$1%';
        HEREDOC
        
        expect(helper.build_query(input)).to eq(output)
      end
    
      it "builds complex queries" do
        input = ["poire", "oeuf", "veau"]
        
        output = <<~HEREDOC.strip
          select id, data
          from recipes, jsonb_array_elements_text(data -> 'ingredients')
          where value ilike '%$1%'
          and id in (
            select id
            from recipes, jsonb_array_elements_text(data -> 'ingredients')
            where value ilike '%$2%'
          )
          and id in (
            select id
            from recipes, jsonb_array_elements_text(data -> 'ingredients')
            where value ilike '%$3%'
          );
        HEREDOC
        
        expect(helper.build_query(input)).to eq(output)
    end
  end
end
