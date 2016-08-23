require 'net/http'
require 'json'

@client_id = "56a6aeeb-cd4a-4a7e-bb42-c84a15b80155"
@no_chicken_anywhere = true	#tragic... :'(
@date_info = ["month", "day", "year"]

# ratty request
uri = URI('https://api.students.brown.edu/dining/menu')
params = { :client_id => @client_id, :eatery => "ratty", :year => 2016, :month => 4, :day => 3 }
uri.query = URI.encode_www_form(params)
res = Net::HTTP.get_response(uri)
# if menu is available
if res.is_a?(Net::HTTPSuccess)
	@no_chicken_anywhere = false
	# puts res.body
	menu_response = JSON.parse(res.body)
	
	# print request date
	@date_info.each_with_index do |date_part, index|
		@date_info[index] = menu_response["menus"][0][date_part]
	end
	puts @date_info.join("/")

	puts "RATTY:"
	menu_response["menus"].each do |menu|
		# delete all date info
		@date_info.each do |date_part|
			menu.delete(date_part)
		end
		
		# print and delete operation time info
		
		# iterate through menu sections
	end
end


uri = URI('https://api.students.brown.edu/dining/menu')
params = { :client_id => @client_id, :eatery => "vdub", :year => 2016, :month => 4, :day => 3 }
uri.query = URI.encode_www_form(params)

if @no_chicken_anywhere
	puts "no chicken anywhere... harvest the salt of your tears for seasoning for next chicken finger friday😭😭😭"
end


# chab if using specific food API
# puts ""
# puts "NEXT SECTION"
# uri = URI('https://api.students.brown.edu/dining/find')
# params = { :client_id => @client_id, :food => "chicken fingers" }
# uri.query = URI.encode_www_form(params)
# 
# res = Net::HTTP.get_response(uri)
# puts JSON.parse(res.body)["results"][0]["eatery"]
# puts "🍗"
