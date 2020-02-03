class PointsCalculator
  attr_reader :repo, :points

  PULL_COMMENT_POINTS = 1
  PULL_REVIEW_POINTS = 3
  PULL_REQUEST_POINTS = 12

  def initialize repo
    @repo = repo
    @points = Hash.new(0)
  end

  def top_ten
    sum_points.sort {|user1, user2| user2[1] <=> user1[1] }[0..9]
  end

  private

    def sum_points
      sum_comments_points
      sum_pulls_points
      sum_reviews_points

      points
    end

    def sum_pulls_points
      pulls = GitHub::PullRequestsApi.new(repo).fetch
      add_to_sum pulls, PULL_REQUEST_POINTS
    end

    def sum_reviews_points
      pulls = GitHub::PullRequestsApi.new(repo).fetch
      reviews = GitHub::ReviewsApi.new(repo).fetch pulls
      add_to_sum reviews, PULL_REVIEW_POINTS
    end

    def sum_comments_points
      comments = GitHub::CommentsApi.new(repo).fetch
      add_to_sum comments, PULL_COMMENT_POINTS
    end

    def add_to_sum entities, value
      entities.inject(points) do |hash, element|
        user_id = element[:user_id].to_s
        hash[user_id] += value
        hash
      end
    end
end
