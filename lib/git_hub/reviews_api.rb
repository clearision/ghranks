class GitHub::ReviewsApi < GitHubApi
  def fetch pull_requests
    pull_requests.inject([]) do |arr, pull_request|
      arr.concat fetch_data(pull_request[:number])
    end
  end

  private

    def fetch_data pull_request_id, reviews = [], page = 1
      response = handle_get_request request_path(pull_request_id, page)
      body = JSON.parse(response.body)

      new_items = body.select do |item|
          item['submitted_at'] >= date_week_ago
        end.map do |item|
          { id: item['id'], user_id: item['user']['login'] }
        end

      if has_next_page?(response)
        get_reviews(reviews.concat(new_items), page+1)
      else
        reviews.concat(new_items)
      end
    end

    def request_path pull_request_id, page = 1
      "/repos/#{repo}/pulls/#{pull_request_id}/reviews?page=#{page}"
    end
end
