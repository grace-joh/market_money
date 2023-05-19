class AtmService
  def nearby_atms(lat, lon)
    get_url("/search/2/categorySearch/cash_dispensers.json?geobias=point:#{lat},#{lon}")
  end

  private

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://api.tomtom.com') do |faraday|
      faraday.params['key'] = ENV['TOMTOM_API_KEY']
    end
  end
end
