require 'rails_helper'

describe 'Vendors API' do
  describe 'Get one Vendor' do
    describe 'happy path' do
      it 'returns a vendor' do
        market1 = create(:market)
        vendor1 = create(:vendor)

        create(:market_vendor, market: market1, vendor: vendor1)

        get "/api/v0/vendors/#{vendor1.id}"

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:data)

        vendor = data[:data]

        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a(String)

        expect(vendor).to have_key(:type)
        expect(vendor[:type]).to eq('vendor')

        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes]).to be_a(Hash)

        attributes = vendor[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)

        expect(attributes).to have_key(:description)
        expect(attributes[:description]).to be_a(String)

        expect(attributes).to have_key(:contact_name)
        expect(attributes[:contact_name]).to be_a(String)

        expect(attributes).to have_key(:contact_phone)
        expect(attributes[:contact_phone]).to be_a(String)

        expect(attributes).to have_key(:credit_accepted)
        expect(attributes[:credit_accepted]).to be(true).or be(false)
      end
    end

    describe 'sad path' do
      it 'returns error if Vendor does not exist' do
        false_id = 123123123123
        get "/api/v0/vendors/#{false_id}"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)

        errors = data[:errors]

        expect(errors).to be_an(Array)
        expect(errors.first[:detail]).to eq("Couldn't find Vendor with 'id'=#{false_id}")
      end
    end
  end

  describe 'Create a Vendor' do
    describe 'happy path' do
      it 'creates a vendor (status code 201)' do
        vendor_params = {
          'name': 'Buzzy Bees',
          'description': 'local honey and wax products',
          'contact_name': 'Berly Couwer',
          'contact_phone': '8389928383',
          'credit_accepted': false
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)
        created_vendor = Vendor.last

        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(created_vendor.name).to eq(vendor_params[:name])
        expect(created_vendor.description).to eq(vendor_params[:description])
        expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
        expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
        expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
      end
    end

    describe 'sad path' do
      it 'returns 400 error if any attributes are not passed' do
        vendor_params = {
          param: 'param'
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)

        errors = data[:errors]

        expect(errors).to be_an(Array)

        all_errors_message = "Validation failed: Name can't be blank, Description can't be blank, Contact name can't be blank, Contact phone can't be blank, Credit accepted is reserved"
        expect(errors.first[:detail]).to eq(all_errors_message)
      end
    end
  end

  describe 'Update a Vendor' do
    describe 'happy path' do
      it 'returns a vendor with updates' do
        vendor = create(:vendor)

        update_params = {
          "contact_name": "Kimberly Couwer",
          "credit_accepted": false
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: update_params)
        created_vendor = Vendor.last

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(created_vendor.contact_name).to eq(update_params[:contact_name])
        expect(created_vendor.credit_accepted).to eq(update_params[:credit_accepted])
      end
    end

    describe 'sad path' do
      it 'returns 404 error if vendor does not exist' do
        false_id = 123123123
        update_params = {
          "contact_name": "Kimberly Couwer",
          "credit_accepted": false
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        patch "/api/v0/vendors/#{false_id}", headers: headers, params: JSON.generate(vendor: update_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)

        errors = data[:errors]

        expect(errors).to be_an(Array)
        expect(errors.first[:detail]).to eq("Couldn't find Vendor with 'id'=#{false_id}")
      end

      it 'returns 400 error if attribute is blank' do
        vendor = create(:vendor)

        update_params = {
          "name": '',
          "description": '',
          "contact_name": '',
          "contact_phone": '',
          "credit_accepted": ''
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: update_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)

        errors = data[:errors]

        expect(errors).to be_an(Array)
        all_errors_message = "Validation failed: Name can't be blank, Description can't be blank, Contact name can't be blank, Contact phone can't be blank, Credit accepted is reserved"
        expect(errors.first[:detail]).to eq(all_errors_message)
      end
    end
  end
end
