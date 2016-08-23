require 'net/http'
require 'uri'
require 'json'
require_relative 'string.rb'

# instance setup
@no_chicken_anywhere = true	#tragic... :'(
@date_info = ["month", "day", "year"]
@non_menu_info = @date_info + ["eatery", "start_hour", "start_minute", "end_hour", "end_minute", "meal"]
@date_printed = false

# API setup
@client_id = "56a6aeeb-cd4a-4a7e-bb42-c84a15b80155"
@uri = URI('https://api.students.brown.edu/dining/menu')

# do once for each supported eatery
["ratty", "vdub"].each do |eatery|
	eatery_ch_entries = ""
	
	# get all menus for the day through dining API
	params = { :client_id => @client_id, :eatery => eatery, :year => 2016, :month => 4, :day => 8 }
	@uri.query = URI.encode_www_form(params)
	res = Net::HTTP.get_response(@uri)

	# if menu is available
	if res.is_a?(Net::HTTPSuccess)
		menu_response = JSON.parse(res.body)

		unless @date_printed
			# print request date
			@date_info.each_with_index do |date_part, index|
				@date_info[index] = menu_response["menus"][0][date_part]
			end
			puts @date_info.join("/").bold
			@date_printed = true
		end
		
		menu_response["menus"].each do |menu|
			menu_ch_entries = ""
			
			# print operation info
			operation_info = "#{menu["meal"]}\n"
			if (menu["start_hour"]/12 < 1) then operation_info << "#{menu["start_hour"]}:#{menu["start_minute"]/10}0am" else operation_info <<  "#{menu["start_hour"]%12}:#{menu["start_minute"]/10}0pm" end
			if (menu["end_hour"]/12 < 1) then operation_info <<  "-#{menu["end_hour"]}:#{menu["end_minute"]/10}0am" else operation_info <<  "-#{menu["end_hour"]%12}:#{menu["end_minute"]/10}0pm" end
			
			# delete all non-menu info
			@non_menu_info.each do |info|
				menu.delete(info)
			end
			
			# iterate through menu sections
			menu.each do |key, entree_array|
				section_ch_entrees = ""
				entree_array.each do |entree|
					if entree.include? "chicken"
						@no_chicken_anywhere = false
						section_ch_entrees << " 🍗  #{entree}\n"
					end
				end
				
				# if the menu section has any entries
				unless section_ch_entrees.empty?
					menu_ch_entries << "---#{key}---\n"
					menu_ch_entries <<  section_ch_entrees
				end
			end
			
			# if the operation time has any entries
			unless menu_ch_entries.empty?
				eatery_ch_entries << "#{operation_info}\n".cyan
				eatery_ch_entries << "#{menu_ch_entries}\n\n"
			end
		end
	end
	
	# if the eatery has any entries
	unless eatery_ch_entries.empty?
		puts "#{eatery.upcase}:".bg_cyan.bold
		puts eatery_ch_entries
	end
end

if @no_chicken_anywhere
	puts "no chicken anywhere... harvest the salt of your tears for seasoning for next chicken finger friday😭"
end
