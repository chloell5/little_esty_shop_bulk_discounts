require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    before(:each) do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)
    end

    it "total_revenue" do
      expect(@invoice_1.total_revenue).to eq(100)
    end

    it "merchant total_revenue" do
      expect(@invoice_1.merchant_total_revenue(@merchant1)).to eq(100)
    end

    it 'gets merchant_items' do
      expect(@invoice_1.merchant_items(@merchant1)).to eq([@ii_1, @ii_11])
    end

    it 'gets total_discounted_revenue' do
      merchant2 = Merchant.create!(name: 'Bear Care')
      item2 = Item.create!(name: 'Bear Food', description: 'Food for bear', unit_price: 50, merchant_id: merchant2.id, status: 1)
      InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: item2.id, quantity: 2, unit_price: 50, status: 2)
      BulkDiscount.create(percentage_discount: 20, quantity_threshold: 9, merchant_id: @merchant1.id)
      BulkDiscount.create(percentage_discount: 50, quantity_threshold: 1, merchant_id: merchant2.id)

      expect(@invoice_1.total_discounted_revenue).to eq(132.0)
    end

    it 'gets merchant_discounted_revenue' do
      merchant2 = Merchant.create!(name: 'Bear Care')
      item2 = Item.create!(name: 'Bear Food', description: 'Food for bear', unit_price: 50, merchant_id: merchant2.id, status: 1)
      InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: item2.id, quantity: 2, unit_price: 50, status: 2)
      BulkDiscount.create(percentage_discount: 20, quantity_threshold: 9, merchant_id: @merchant1.id)
      BulkDiscount.create(percentage_discount: 50, quantity_threshold: 1, merchant_id: merchant2.id)
      BulkDiscount.create(percentage_discount: 20, quantity_threshold: 9, merchant_id: @merchant1.id)

      expect(@invoice_1.merchant_discounted_revenue(@merchant1)).to eq(82.0)
    end
  end
end
