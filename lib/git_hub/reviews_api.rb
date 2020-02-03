class GitHub::ReviewsApi < GitHubApi
  def fetch pull_requests
    pull_requests.inject([]) do |arr, pull_request|
      arr.concat fetch_data(pull_request[:number])
    end
  end

  private

    def fetch_data pull_request_id, reviews = [], page = 1
      body, code, next_page = handle_get_request request_path(pull_request_id, page)
      return reviews unless code == '200'

      new_items = body.select do |item|
          item['submitted_at'] >= date_week_ago
        end.map do |item|
          { id: item['id'], user_id: item['user']['login'] }
        end

      return reviews.concat(new_items) unless next_page

      fetch_data(pull_request_id, reviews.concat(new_items), page+1)
    end

    def request_path pull_request_id, page = 1
      "/repos/#{repo}/pulls/#{pull_request_id}/reviews?page=#{page}"
    end
end
