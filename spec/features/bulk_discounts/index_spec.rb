require 'rails_helper'

describe "bulk discounts index" do
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Jewelry')

    @bd1 = @merchant1.bulk_discounts.create!(percentage_discount: 25, quantity_threshold: 30)
    @bd2 = @merchant1.bulk_discounts.create!(percentage_discount: 35, quantity_threshold: 60)
    @bd3 = @merchant2.bulk_discounts.create!(percentage_discount: 22, quantity_threshold: 33)
  end

  it 'shows all bulk discounts, and their percentage and thresholds' do
    visit merchant_bulk_discounts_path(@merchant1)

    expect(page).to have_content("Discount No #{@bd1.id}")
    expect(page).to have_content("Percentage Discount: #{@bd1.percentage_discount}")
    expect(page).to have_content("Quantity Threshold: #{@bd1.quantity_threshold}")
    expect(page).to have_content("Discount No #{@bd2.id}")
    expect(page).to have_content("Percentage Discount: #{@bd2.percentage_discount}")
    expect(page).to have_content("Quantity Threshold: #{@bd2.quantity_threshold}")

    expect(page).to_not have_content("Discount No #{@bd3.id}")
    expect(page).to_not have_content("Percentage Discount: #{@bd3.percentage_discount}")
    expect(page).to_not have_content("Quantity Threshold: #{@bd3.quantity_threshold}")
  end

  it 'for each discount id it is a link to the discount show page' do
    visit merchant_bulk_discounts_path(@merchant1)

    click_link "Discount No #{@bd1.id}"

    expect(page).to have_current_path("/merchant/#{@merchant1.id}/bulk_discounts/#{@bd1.id}")
  end

  it 'has a link to create new discounts' do
    visit merchant_bulk_discounts_path(@merchant1)

    click_link 'Create New Discount'

    expect(page).to have_current_path("/merchant/#{@merchant1.id}/bulk_discounts/new")
  end

  it 'has a button to delete discounts' do
    visit merchant_bulk_discounts_path(@merchant1)

    click_button "Delete Discount No #{@bd2.id}"

    expect(page).to have_current_path("/merchant/#{@merchant1.id}/bulk_discounts")

    expect(page).to_not have_content("Discount No #{@bd2.id}")
    expect(page).to_not have_content("Percentage Discount: #{@bd2.percentage_discount}")
    expect(page).to_not have_content("Quantity Threshold: #{@bd2.quantity_threshold}")
  end

  it 'has next three holidays' do
    visit merchant_bulk_discounts_path(@merchant1)
    
    expect(page.status_code).to eq 200
    expect(page).to have_content("Thanksgiving")
    expect(page).to have_content("Christmas Day")
    expect(page).to have_content("New Year's Day")
  end
end
