class RecipesController < ApplicationController
  def index
  end
  
  def search
    render :not_found and return if params[:query].blank?
    
    keywords = params[:query].split(", ")
    query = helpers.build_query(keywords)
    result_set = helpers.conn.exec_params(query, keywords)
    
    render :not_found and return if result_set.values.blank?

    @recipes = helpers.deserialize(result_set)
    render :results
  end
end
