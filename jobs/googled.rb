# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require 'httparty'

SCHEDULER.every '60m', :first_in => 0 do |job|
	response = HTTParty.get('https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http%3A%2F%2Fwww.google.com%2Ftrends%2Fhottrends%2Fatom%2Fhourly')
	search_json = JSON.parse(response.body)
	entires = search_json["responseData"]["feed"]["entries"]
	search_words = entires[0]["contentSnippet"].split("\n")

	#search = Hash[(0...search_words.size).zip search_words]
	#puts search
	search = Hash.new({value: 0})

	search_words.each_with_index do |element,index|
	  search[element] = { label: element, value: index }
	end

	search.delete("") #removing the first empty value
	puts search.values
  send_event('googled', { items: search.values })
end