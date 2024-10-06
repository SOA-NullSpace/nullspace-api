# frozen_string_literal: true

require 'http'
require 'yaml'
require 'uri'

config = YAML.safe_load_file('../config/secrets.yml')

def movie_api_url(base, parameters)
  "#{base}?#{URI.encode_www_form(parameters)}"
end

def call_movie_url(url)
  HTTP.headers('Accept' => 'application/json').get(url)
end

def get_movie_showtimes(movie_name, config)
  movie_base_url = 'https://serpapi.com/search'
  params = {
    'q' => "#{movie_name} showtimes",
    'location' => 'Hsinchu City, Taiwan',
    'api_key' => config['SERPAPI_TOKEN']
  }

  full_url = movie_api_url(movie_base_url, params)
  movie_response = call_movie_url(full_url)
  response_data = movie_response.parse

  response_data['showtimes'] || []
end

movie_name = 'Speak No Evil'
showtimes = get_movie_showtimes(movie_name, config)

showtimes_yaml = showtimes.to_yaml

directory_path = '../spec/fixtures'
file_path = "#{directory_path}/movies_showtimes.yml"
File.write(file_path, showtimes_yaml)
puts "Showtime data successfully saved to #{file_path}"
