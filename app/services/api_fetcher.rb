class ApiFetcher
  include HTTParty
  base_uri ENV['EXTERNAL_API_URL']  # Access the external API URL from environment variables

  def self.fetch_data
    url = ENV['EXTERNAL_API_URL']
    response = HTTParty.get(url)
    debugger
    if response.success?
      response.parsed_response
    else
      Rails.logger.error("failes")
      []
    end
  end


  def self.send_data(data)
    #data = { "title": "foo", "body": "bar", "userId": 1 }
    response = HTTParty.post(
      ENV['EXTERNAL_API_URL'],  # External API URL from .env
      body: data.to_json,       # Data to send in JSON format
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{ENV['EXTERNAL_API_KEY']}"  # API Key in the Authorization header
      }
    )
    if response.success?
      Rails.logger.info("Successfully posted to external API: #{response.body}")
      response.parsed_response  # Returning the parsed JSON response
    else
      Rails.logger.error("Failed to post to external API. Response: #{response.code} - #{response.body}")
      []  # Return empty array in case of failure
    end
  end
end