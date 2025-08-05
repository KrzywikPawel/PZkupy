require 'nokogiri'
require 'open-uri'

# URL jako argument
url = ARGV[0]

if url.nil?
  puts "Użycie: ruby skladniki.rb <URL do przepisu>"
  exit
end

puts "🔗 Pobieram stronę: #{url}"

begin
  html = URI.open(url)
rescue => e
  puts "❌ Błąd podczas pobierania strony: #{e.message}"
  exit
end

doc = Nokogiri::HTML(html)

ingredients = doc.css('div.field-name-field-skladniki li').map(&:text).map(&:strip)

if ingredients.empty?
  puts "⚠️ Nie znaleziono składników. Sprawdź, czy struktura strony się nie zmieniła."
else
  puts "\n📋 Składniki z przepisu:\n\n"
  ingredients.each_with_index do |ingredient, index|
    puts "#{index + 1}. #{ingredient}"
  end
end