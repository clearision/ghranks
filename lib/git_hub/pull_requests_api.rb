class GitHub::PullRequestsApi < GitHubApi
  private

    def fetch_data pull_requests = [], page = 1
      response = handle_get_request request_path(page)
      body = JSON.parse(response.body).with_indifferent_access

      new_items = body[:items].map do |item|
          { number: item[:number], user_id: item[:user][:login] }
        end

      if has_next_page?(response)
        fetch_data(pull_requests.concat(new_items), page+1)
      else
        pull_requests.concat(new_items)
      end
    end

    def request_path page = 1
      "/search/issues?q=repo:#{repo}+is:pr+created:>=#{date_week_ago}&page=#{page}"
    end
end
