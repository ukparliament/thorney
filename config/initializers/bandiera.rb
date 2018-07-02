require 'bandiera/client'

BANDIERA_CLIENT = Bandiera::Client.new(ENV['BANDIERA_URL'].dup)
