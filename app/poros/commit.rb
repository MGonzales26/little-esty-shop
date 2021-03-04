require 'faraday'
require 'json'
require 'pry'

class Commit
  attr_reader :id

  def initialize(data)
  	@id = data[:id]

  end
end
