class GitHubApi
  attr_reader :repo, :http_client

  def initialize repo
    @repo = repo

    @http_client ||= Net::HTTP.new base_url, 443
    @http_client.use_ssl = true
  end

  def fetch
    fetch_data
  end

  private

    def base_url
      'api.github.com'
    end

    def date_week_ago
      1.week.ago.strftime('%F')
    end

    def fetch_data
      raise 'Implement me!'
    end

    def handle_get_request path
      request = Net::HTTP::Get.new(path)
      request['Authorization'] = "token #{Rails.configuration.github.token}"
      response = http_client.request(request)

      return JSON.parse(response.body), response.code, has_next_page?(response)
    end

    def has_next_page? response
      response.header['Link'] =~ /rel=\"next\"/
    end
end
