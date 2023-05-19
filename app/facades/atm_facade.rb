class AtmFacade
  def find_nearby_atms(lat, lon)
    json = service.nearby_atms(lat, lon)[:results]

    json.map do |atm_data|
      Atm.new(atm_data)
    end
  end

  private

  def service
    @_service ||= AtmService.new
  end
end
