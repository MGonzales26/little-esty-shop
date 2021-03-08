class HolidayService

  def self.get_holidays
    response = Faraday.get("https://date.nager.at/Api/v2/NextPublicHolidays/us")
    JSON.parse(response.body, symbolize_names: true)
  end
end