require 'rails_helper'

describe DistanceCalculator do
  subject do
    described_class.new(
      Geokit::Geocoders::GoogleGeocoder,
      start_address,
      destination_address
    )
  end

  context 'with valid params', vcr: { cassette_name: 'requests/trip_create_polish' } do
    describe 'with Polish address' do
      let(:start_address) { 'Plac Europejski 2, Warszawa, Polska' }
      let(:destination_address) { 'Leszno 15, Warszawa, Polska' }

      let(:returned_distance) { subject.call }

      it 'returns distance from geocoder' do
        expect(returned_distance.round(2)).to eq(798.76)
      end
    end

    describe 'with English address', vcr: { cassette_name: 'requests/trip_create_english' } do
      let(:start_address) { 'Lambeth, London SE1 7PB, UK' }
      let(:destination_address) { 'Trafalgar Square, Charing Cross, London WC2N 5DN, UK' }

      let(:returned_distance) { subject.call }

      it 'returns distance from geocoder' do
        expect(returned_distance.round(2)).to eq(787.84)
      end
    end
  end

  context 'with invalid params', vcr: { cassette_name: 'requests/trip_create_failure_both_addresses_invalid' } do
    let(:start_address) { 'lskfshkvsn' }
    let(:destination_address) { 'sckhkuvcsj' }

    let(:returned_errors) { subject.call[:errors] }

    it 'raises error with corresponding messages' do
      expect { subject.call }.to raise_error do |error|
        expect(error).to be_a(AddressNotFound)
        expect(error.messages).to eq [
          start_address: ['Could not find address'],
          destination_address: ['Could not find address']
        ]
      end
    end
  end
end
