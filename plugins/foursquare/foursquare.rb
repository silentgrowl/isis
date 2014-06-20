# Query FourSquare of Food options
require 'foursquare2'

##
#  If message contains one of TRIGGERS, plugin will query the foursquare API for 
#  food options in the specified area. The API request will take time of day, current popularity, 
#  and hours of operation into account when suggesting venues.
#
#  Optionally, if "cheap" is also in the message then the query will filter only those options
#  label in the foursquare API as Not Expensive (tier 1 prices).  If "fancy" is also in the message
#  then they results will be limited to only those places that are Expensive (tier 3 and 4 prices).
#  
##

class Foursquare < Isis::Plugin::Base
  TRIGGERS = %w(!lunch !food !hungry !dinner !breakfast)

  @@CLIENT_ID = 'CHANGEME', # Get your client_id from https://developer.foursquare.com/
  @@CLIENT_SECRET = 'CHANGEME' # Get your client_secret from https://developer.foursquare.com/

  @@localLatLng = '' # Format: '12.1234567,-120.123456'

  @@limit = 150  # Maximum number of options to return from the API.  Bot will randomly select 1 from this list
  @@radius = 400  # Search radius, in meters

  @@pricing = ""

  def respond_to_msg?(msg, speaker)
    @@pricing = msg.include?('cheap') ? '1' : nil
    @@pricing = msg.include?('fancy') ? '3,4' : @@pricing

    TRIGGERS.any? { |word| msg.include?(word) }
  end

  private

  def response_html
    output = %Q[How about... ]
    v = get_venue()
    if v.venue.url
      output += "<br><a href='#{v.venue.url}'>#{v.venue.name}</a>"
    else 
      output += "<br>#{v.venue.name}"
    end

    if v.venue.location.address
      output += "<br>#{v.venue.location.address}"
    end

    if v.venue.contact.formattedPhone
      output += "<br>#{v.venue.contact.formattedPhone}"
    end
    
    if v.venue.rating
      output += "<br>User Rating: <b>#{v.venue.rating}</b>/10"
    end

    if v.venue.price.message?
    output += "<br>(#{v.venue.price.message})"
    end

    output
  end

  def response_text
    output = %Q[How about... ]
    v = get_venue()
    output += "\n#{v.venue.name}"

    if v.venue.location.address
      output += "\n#{v.venue.location.address}"
    end

    if v.venue.contact.formattedPhone
      output += "\n#{v.venue.contact.formattedPhone}"
    end
    
    if v.venue.rating
      output += "\nUser Rating: #{v.venue.rating}/10"
    end

    if v.venue.price.message?
    output += "\n(#{v.venue.price.message})"
    end

    output
  end

  def get_venue()
    foursq = client = Foursquare2::Client.new(:client_id => @@CLIENT_ID, :client_secret => @@CLIENT_SECRET)  
    params = {
      :ll => "#{@@localLatLng}", 
      :section => "food", 
      :v => "20140101", 
      :limit => @@limit,  # num returned
      :radius => @@radius
      :price => "#{@@pricing}"
    }

    resp = foursq.explore_venues(params)
    venues = resp.groups.first.items

    venues.sample
  end

end
