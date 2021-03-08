class GitService
  def self.get_contributors
    response = Faraday.get("https://api.github.com/repos/Diana20920/little-esty-shop/contributors") do |req|
			req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
		end
    parsed = JSON.parse(response.body, symbolize_names: true)

    parsed.map do |contributor|
      Contributor.new(contributor)
    end
  end

  def self.get_repo_name
    response = Faraday.get("https://api.github.com/repos/Diana20920/little-esty-shop")do |req|
			req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
		end
    parsed = JSON.parse(response.body, symbolize_names: true)
    parsed[:name]
  end

  def self.get_pull_requests
    response = Faraday.get("https://api.github.com/repos/diana20920/little-esty-shop/pulls?state=all")do |req|
			req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
		end
    parsed = JSON.parse(response.body, symbolize_names: true)
    parsed.first[:number]
  end

  def self.get_commits(user_name)
    response = Faraday.get("https://api.github.com/repos/diana20920/little-esty-shop/commits?author=#{user_name}&per_page=100") do |req|
			req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
		end
    parsed = JSON.parse(response.body, symbolize_names: true)
    parsed.map do |commit|
      Commit.new(commit)
    end
  end

end
