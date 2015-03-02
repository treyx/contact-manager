require 'rails_helper'

describe "the company view", type: :feature do
  let(:company) { Company.create(name: "Yahoo") }
  
  describe "#phone_numbers" do

    before(:each) do
      company.phone_numbers.create(number: "635-4809")
      company.phone_numbers.create(number: "375-9934")

      visit company_path(company)
    end

    it "shows the phone numbers" do
      company.phone_numbers.each do |phone|
        expect(page).to have_content(phone.number)
      end
    end

    it "has a link to add a new phone number" do
      expect(page).to have_link('Add phone number', href: new_phone_number_path(contact_id: company.id, contact_type: 'Company'))
    end

    it "adds a new phone number" do
      page.click_link_or_button('Add phone number')

      expect(current_path).to eq(new_phone_number_path)

      page.fill_in('Number', with: '536-9373')
      page.click_link_or_button('Create Phone number')

      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('536-9373')
    end

    it "has links to edit phone numbers" do
      company.phone_numbers.each do |phone|
        expect(page).to have_link('edit', href: edit_phone_number_path(phone))
      end
    end

    it "edits a phone number" do
      phone = company.phone_numbers.first
      old_number = phone.number

      first(:link, 'edit').click
      page.fill_in('Number', with: '827-9303')
      page.click_link_or_button('Update Phone number')
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('827-9303')
      expect(page).to_not have_content(old_number)
    end

    it "has links to delete phone numbers" do
      company.phone_numbers.each do |phone|
        expect(page).to have_link('delete', href: phone_number_path(phone))
      end
    end

    it "deletes a phone number" do
      first(:link, 'delete').click

      expect(current_path).to eq(company_path(company))
      expect(page).to_not have_content('867-5309')

      page.click_link_or_button('delete')
      expect(page).to_not have_link('delete')
    end
  end

  describe "#email_addresses" do

    before(:each) do
      company.email_addresses.create(address: "example@example.com")
      company.email_addresses.create(address: "testing@example.com")

      visit company_path(company)
    end

    it "shows the email addresses" do
      company.email_addresses.each do |email|
        expect(page).to have_selector('li', text: "#{email.address}")
      end
    end

    it "has a link to add an email address" do
      expect(page).to have_link('Add email address', href: new_email_address_path(contact_id: company.id, contact_type: 'Company'))
    end

    it "adds a new email address" do
      click_link_or_button('Add email address')

      expect(current_path).to eq(new_email_address_path)

      fill_in('Address', with: 'testing@example.com')
      click_link_or_button('Create Email address')

      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('testing@example.com')
    end

    it "has links to edit email addresses" do
      company.email_addresses.each do |email|
        expect(page).to have_link('edit', href: edit_email_address_path(email))
      end
    end

    it "edits an email address" do
      within("#email_addresses") { first(:link, 'edit').click }

      expect(current_path).to eq(edit_email_address_path(company.email_addresses.first))

      fill_in('Address', with: 'updated@example.com')
      click_link_or_button('Update Email address')

      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('updated@example.com')
    end

    it "has links to delete email addresses" do
      company.email_addresses.each do |email|
        expect(page).to have_link('delete', href: email_address_path(email))
      end
    end

    it "can delete an email address" do
      within("#email_addresses") { first(:link, 'delete').click }

      expect(current_path).to eq(company_path(company))
      expect(page).to_not have_content('example@example.com')
    end

  end
end