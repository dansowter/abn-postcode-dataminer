# To collect ABN info from online.
require 'rest-client'
require 'ap'
require 'csv'

all_postcodes = CSV.read("postcode_list.csv")[0]

month_array = %w[Jan-2012 Feb-2012 Mar-2012 Apr-2012 May-2012 Jun-2012 Jul-2012 Aug-2012 Sep-2012 Oct-2012 Nov-2012 Dec-2012 n">Total]

CSV.open("output2012.csv", "wb") do |csv|

  csv << %w[postcode Jan-2012 Feb-2012 Mar-2012 Apr-2012 May-2012 Jun-2012 Jul-2012 Aug-2012 Sep-2012 Oct-2012 Nov-2012 Dec-2012 Total]
  all_postcodes.each_with_index do |postcode, i|
    page = RestClient.get "http://abr.business.gov.au/StatisticalSearchResult.aspx?Postcode="+postcode+"&Year=2012&StateOptions=1,0,0,0,0,0,0,0,0&Options=0,0,1,1"

    postcode_row = Array.new
    postcode_row << postcode
    month_array.each do |month|
      month_string = page[page.index(month)+15,5] rescue "0"
      postcode_row << month_string.scan(/\d+/)[0].to_i
    end

    checksum = 0
    postcode_row[1..12].each {|i| checksum += i }

    if checksum == postcode_row[13] 
      csv << postcode_row
      puts "Added row ##{i}, for Postcode: #{postcode}"
    else
     ap "There was a problem - some months were missing data. Check postcode #{postcode}"
    end
  end
end
