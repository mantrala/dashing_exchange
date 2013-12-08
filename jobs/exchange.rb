# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require 'rubygems'
require 'mechanize'

standard_poor = dow_jones = nasdaq = apple = 0.0

SCHEDULER.every '10s', :first_in => 0 do |job|

	lastSP = standard_poor
	lastDowJones = dow_jones
	lastNasdaq = nasdaq
	lastApple = apple

	agent = Mechanize.new
	page = agent.get('https://www.google.com/finance')
	apple_page = agent.get('https://www.google.com/finance?q=AAPL')

	full_table = page.parser.xpath("//table[@id='sfe-mktsumm']//tr")
	apple = apple_page.search('#ref_22144_l').inner_text

	standard_poor = full_table.xpath("//span[@id='ref_626307_l']").inner_text
	dow_jones = full_table.xpath("//span[@id='ref_983582_l']").inner_text
	nasdaq = full_table.xpath("//span[@id='ref_13756934_l']").inner_text

  send_event('sandp', { current: standard_poor, last: lastSP })
  send_event('dowjones', { current: dow_jones, last: lastDowJones })
  send_event('nasdaq', { current: nasdaq, last: lastNasdaq })
  send_event('apple', { current: apple, last: lastApple })
end