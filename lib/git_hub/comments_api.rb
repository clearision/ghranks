class GitHub::CommentsApi < GitHubApi
  private

    def fetch_data comments = [], page = 1
      response = handle_get_request request_path(page)
      body = JSON.parse(response.body)

      new_items = body.map do |item|
          { id: item['id'], user_id: item['user']['login'] }
        end

      if has_next_page?(response)
        fetch_data(comments.concat(new_items), page+1)
      else
        comments.concat(new_items)
      end
    end

    def request_path page = 1
      "/repos/#{repo}/issues/comments?q=is:pr&since=#{date_week_ago}&page=#{page}"
    end
end
