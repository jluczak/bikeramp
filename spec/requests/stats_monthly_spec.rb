require 'rails_helper'

describe 'monthly stats', type: :request do
  subject { get '/stats/monthly' }

  let(:json_response) { JSON.parse(response.body) }
  let(:current_month) { DateTime.current.strftime('%m') }

  let!(:current_trip_with_different_price) { FactoryBot.create(:trip, created_at: "2019-#{current_month}-02", price: "2.0") }
  let!(:current_trip_with_different_distance) { FactoryBot.create(:trip, created_at: "2019-#{current_month}-02", distance: "100.0") }
  let!(:current_trip_with_different_day) { FactoryBot.create(:trip, created_at: "2019-#{current_month}-27") }
  let!(:trip_from_last_month) { FactoryBot.create(:trip, created_at: 1.month.ago) }

  it 'returns 200 status code' do
    subject
    expect(response).to have_http_status(200)
  end

  it 'returns only days where trips were made' do
    subject
    expect(json_response[0]).to include({ "day" => "2019-#{current_month}-02" })
    expect(json_response[1]).to include({ "day" => "2019-#{current_month}-27" })
  end

  it 'returns only days from current month' do
    subject
    expect(json_response.count).to eq(2)
  end

  it 'returns total distance grouped by day' do
    subject
    expect(json_response[0]).to include({ "total_distance" => "898.76" })
    expect(json_response[1]).to include({ "total_distance" => "798.76" })
  end

  it 'returns total price grouped by day' do
    subject
    expect(json_response[0]).to include({ "total_price" => "6.65" })
    expect(json_response[1]).to include({ "total_price" => "4.65" })
  end

  it 'returns average distance grouped by day' do
    subject
    expect(json_response[0]).to include({ "avg_ride" => "449.38" })
    expect(json_response[1]).to include({ "avg_ride" => "798.76" })
  end

  it 'returns average price grouped by day' do
    subject
    expect(json_response[0]).to include({ "avg_price" => "3.325" })
    expect(json_response[1]).to include({ "avg_price" => "4.65" })
  end
end