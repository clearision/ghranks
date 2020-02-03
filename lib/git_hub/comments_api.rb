class GitHub::CommentsApi < GitHubApi
  private

    def fetch_data comments = [], page = 1
      body, code, next_page = handle_get_request request_path(page)
      return comments unless code == '200'

      new_items = body.map do |item|
          { id: item['id'], user_id: item['user']['login'] }
        end

      return comments.concat(new_items) unless next_page

      fetch_data(comments.concat(new_items), page+1)
    end

    def request_path page = 1
      "/repos/#{repo}/issues/comments?q=is:pr&since=#{date_week_ago}&page=#{page}"
    end
end
