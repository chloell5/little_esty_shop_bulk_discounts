require 'rails_helper'

describe 'bulk discounts new page' do
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Hair Care')
  end

  it 'creates with valid information' do
    visit new_merchant_bulk_discount_path(@merchant1)

    fill_in 'Percentage discount', with: 30
    fill_in 'Quantity threshold', with: 35

    click_on('Submit')

    expect(page).to have_content('Percentage Discount: 30')
    expect(page).to have_content('Quantity Threshold: 35')
    expect(page).to have_current_path("/merchant/#{@merchant1.id}/bulk_discounts")
  end

  it 'redirects with invalid information' do
    visit new_merchant_bulk_discount_path(@merchant1)

    fill_in 'Percentage discount', with: 'asdf'
    fill_in 'Quantity threshold', with: ''

    click_on('Submit')

    expect(page).to have_content('Error')
    expect(page).to have_current_path("/merchant/#{@merchant1.id}/bulk_discounts/new")
  end
end
