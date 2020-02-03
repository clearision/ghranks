class GitHub::PullRequestsApi < GitHubApi
  private

    def fetch_data pull_requests = [], page = 1
      body, code, next_page = handle_get_request request_path(page)
      return pull_requests unless code == '200'

      new_items = body['items'].map do |item|
          { number: item['number'], user_id: item['user']['login'] }
        end

      return pull_requests.concat(new_items) unless next_page

      fetch_data(pull_requests.concat(new_items), page+1)
    end

    def request_path page = 1
      "/search/issues?q=repo:#{repo}+is:pr+created:>=#{date_week_ago}&page=#{page}"
    end
end
