require 'faraday'
require 'json'
require 'pry'

class PullRequest
  attr_reader :number

  def initialize(data)
  	@id = data[:id]
  end
end
