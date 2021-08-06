require 'rails_helper'

RSpec.feature "User sends query", type: :feature do
  scenario "blank search is made" do
    visit root_path
    
    click_on "Search"
    
    expect(page).not_to have_css '#results'
    expect(page).to have_css '#not-found', text: "Sorry, no recipes found with these ingredients"
  end
  
  scenario "no recipe found" do
    visit root_path
    
    fill_in "query", with: "foobarbaz"
    click_on "Search"
    
    expect(page).not_to have_css '#results'
    expect(page).to have_css '#not-found', text: "Sorry, no recipes found with these ingredients"
  end
  
  scenario "recipes found" do
    visit root_path
    
    fill_in "query", with: "oeuf, viande"
    click_on "Search"
    
    expect(page).to have_css '#results'
    expect(page).not_to have_css '#not-found'
  end
end
