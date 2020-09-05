require 'rails_helper'

RSpec.feature "Customers", type: :feature do
  scenario 'Verify register clients link' do
    visit(root_path)
    expect(page).to have_link('Register clients')
  end
end
