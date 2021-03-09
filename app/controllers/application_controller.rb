class ApplicationController < ActionController::Base
  # before_action :application, :usernames

  def application
    @repo_name ||= GitService.get_repo_name
    @contributors ||= GitService.get_contributors
    @pull_requests ||= GitService.get_pull_requests
    @commits = usernames
  end

  def usernames
    array = ['mgonzales26']
    array.each_with_object({}) do |username, commits|
      commits[username] = GitService.get_commits(username).count
    end
  end
end
