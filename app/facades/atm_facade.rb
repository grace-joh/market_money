class AtmFacade
  def find_nearby_atms(lat, lon)
    json = service.nearby_atms(lat, lon)[:results]

    json.map do |atm_data|
      {
        name: atm_data[:poi][:name],
        address: atm_data[:address][:freeformAddress],
        lat: atm_data[:position][:lat],
        lon: atm_data[:position][:lon],
        distance: (atm_data[:dist] / 1609.344)
      }
    end
  end

  private

  def service
    @_service ||= AtmService.new
  end
end
