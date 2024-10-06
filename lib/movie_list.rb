# frozen_string_literal: true

require 'http'
require 'yaml'

config = YAML.safe_load_file('../config/secrets.yml')

def movie_api_url(base, parameters)
  "#{base}?#{URI.encode_www_form(parameters)}"
end

def call_movie_url(config, url)
  HTTP.headers('Accept' => 'application/json',
               'Authorization' => "Bearer #{config['TMDB_API_TOKEN']}").get(url)
end

movie_base_url = 'https://api.themoviedb.org/3/movie/now_playing'
params = {
  'region' => 'TW'
}

full_url = movie_api_url(movie_base_url, params)
movie_response = call_movie_url(config, full_url)
movies = movie_response.parse

movies_yaml = movies.to_yaml

File.write('../spec/fixtures/movies_results.yml', movies_yaml)
puts 'Movie data saved to movies_results.yml'
