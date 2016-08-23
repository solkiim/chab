require 'net/http'
require 'uri'
require 'json'

@client_id = "56a6aeeb-cd4a-4a7e-bb42-c84a15b80155"
@no_chicken_anywhere = true	#tragic... :'(
@date_info = ["month", "day", "year"]
@non_menu_info = @date_info.concat(["eatery", "start_hour", "start_minute", "end_hour", "end_minute"])

# do once for each supported eatery
["ratty", "vdub"].each do |eatery|
	# get all menus for the day through dining API
	uri = URI('https://api.students.brown.edu/dining/menu')
	params = { :client_id => @client_id, :eatery => eatery, :year => 2016, :month => 4, :day => 3 }
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

		# print eatery name
		puts "#{eatery.upcase}:"
		
		menu_response["menus"].each do |menu|
			# print operation time info
			puts "#{start_hour}:#{start_minute} - #{end_hour}:#{end_minute}"
			
			# delete all non-menu info
			@non_menu_info.each do |info|
				menu.delete(info)
			end
			
			# iterate through menu sections
			menu.each do |key, val_array|
				puts "#{key}-----"
				puts val_array
			end
		end
	end
end

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
