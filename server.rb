# server.rb
require 'sinatra'
require 'json'
require_relative 'scraper' # Ładujemy nasz plik ze scraperem

# Ustawiamy serwer, aby był dostępny z innych urządzeń w sieci
set :bind, '0.0.0.0'

puts "Serwer uruchomiony! Otwórz na iPhonie skrót i wyślij URL."
puts "Nasłuchuję na http://#{Socket.ip_address_list.find(&:ipv4_private?).ip_address}:4567"

# Endpoint, który będzie odbierał link z iPhone'a
post '/przepis' do
  # Ustawiamy nagłówek odpowiedzi na JSON
  content_type :json

  # Odbieramy dane wysłane z iPhone'a
  request.body.rewind
  data = JSON.parse(request.body.read)
  url = data['url']

  if url.nil? || url.empty?
    status 400 # Bad Request
    return { status: 'error', message: 'Nie podano URL' }.to_json
  end
  
  puts "Odebrano URL: #{url}"

  # Używamy naszego scrapera
  wynik = KwestiaSmakuScraper.pobierz_skladniki(url)

  # Zwracamy wynik do iPhone'a w formacie JSON
  wynik.to_json
end