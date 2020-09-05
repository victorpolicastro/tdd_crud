require 'rails_helper'

RSpec.feature "Customers", type: :feature do
  scenario 'Verify register clients link' do
    visit(root_path)
    expect(page).to have_link('Registrar clientes')
  end

  scenario 'verify new client link' do
    visit(root_path)
    click_on('Registrar clientes')
    expect(page).to have_content('Listando clientes')
    expect(page).to have_link('Novo cliente')
  end

  scenario 'verify new clients form' do
    visit(customers_path)
    click_on('Novo cliente')
    expect(page).to have_content('Novo cliente')
  end

  scenario 'Register a valid client' do
    visit(new_customer_path)
    customer_name = Faker::Name.name

    fill_in('customer_name', with: customer_name)
    fill_in('customer_email', with: Faker::Internet.email)
    fill_in('customer_phone', with: Faker::PhoneNumber.phone_number)
    attach_file('customer_avatar', "#{Rails.root}/spec/fixtures/avatar.png")
    choose(option: %w[S N].sample)
    click_on('Criar cliente')

    expect(page).to have_content('Cliente cadastrado com sucesso!')
    expect(Customer.last.name).to eq(customer_name)
  end

  scenario "Don't create an invalid client" do
    visit(new_customer_path)
    click_on('Criar cliente')

    expect(page).to have_content('não pode ficar em branco')
  end

  scenario 'Mostra um cliente' do
    customer = create(:customer)

    visit(customer_path(customer.id))
    expect(page).to have_content(customer.name)
    expect(page).to have_content(customer.email)
    expect(page).to have_content(customer.phone)
  end

  scenario 'Mostra todos os clientes' do
    customer1 = create(:customer)
    customer2 = create(:customer)

    visit(customers_path)
    expect(page).to have_content(customer1.name).and have_content(customer2.name)
  end

  scenario 'Atualiza um cliente' do
    customer = create(:customer)

    new_name = Faker::Name.name
    visit(edit_customer_path(customer.id))
    fill_in('customer_name', with: new_name)
    click_on('Criar cliente')

    expect(page).to have_content('Cliente atualizado com sucesso!')
    expect(page).to have_content(new_name)
  end

  scenario 'Clica no link Mostrar' do
    customer = create(:customer)

    visit(customers_path)
    find(:xpath, '/html/body/table/tbody/tr[1]/td[2]/a').click
    expect(page).to have_content('Mostrando cliente')
  end

  scenario 'Clica no link Editar' do
    customer = create(:customer)

    visit(customers_path)
    find(:xpath, '/html/body/table/tbody/tr[1]/td[3]/a').click
    expect(page).to have_content('Editando cliente')
  end

  scenario 'Apaga um cliente', js: true do
    customer = create(:customer)

    visit(customers_path)
    find(:xpath, '/html/body/table/tbody/tr[1]/td[4]/a').click
    1.second
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content('Cliente excluído com sucesso!')
  end
end
