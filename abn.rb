# To collect ABN info from online.
require 'rest-client'
require 'ap'
require 'csv'

all_postcodes = CSV.read("postcode_list.csv")[0]

month_array = %w[Jan-2011 Feb-2011 Mar-2011 Apr-2011 May-2011 Jun-2011 Jul-2011 Aug-2011 Sep-2011 Oct-2011 Nov-2011 Dec-2011 n">Total]

CSV.open("output.csv", "wb") do |csv|

  csv << %w[postcode Jan-2011 Feb-2011 Mar-2011 Apr-2011 May-2011 Jun-2011 Jul-2011 Aug-2011 Sep-2011 Oct-2011 Nov-2011 Dec-2011 Total]
  all_postcodes.each do |postcode|
    page = RestClient.get "http://abr.business.gov.au/StatisticalSearchResult.aspx?Postcode="+postcode+"&Year=2011&StateOptions=1,0,0,0,0,0,0,0,0&Options=0,0,1,1"

    postcode_row = Array.new
    postcode_row << postcode
    month_array.each do |month|
      month_string = page[page.index(month)+15,5] rescue "0"
      postcode_row << month_string.scan(/\d+/)[0].to_i
    end

    checksum = 0
    postcode_row[1..12].each {|i| checksum += i }

    if checksum == postcode_row[13] 
      then 
          csv << postcode_row
      else ap "There was a problem"
    end
  end
end
