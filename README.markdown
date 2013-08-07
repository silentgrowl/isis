# Isis
### Chat bot for HipChat and Campfire

### Features
- HipChat and Campfire support
- Supports both HTML output (through API) and room presence & text output (through XMPP) in HipChat
- Multi-room support
- Plugin support, see Plugins wiki page for writing new plugins
- Comes with many plugins with which to entertain yourself

### Requirements
- Ruby 1.9+ or JRuby 1.7+

### Setup
1. Clone repository
1. Run `bundle install` to install dependencies
1. Copy `config.yml.example` to `config.yml`
1. Edit `config.yml` to include your HipChat or Campfire credentials, and
   choose plugins to enable
1. Launch Isis in foreground:  
    `bin/isis`  
   or launch daemonized:  
    `bin/isis-daemon start`  

### Included Plugins
- Animals Being Jerks
  - command: !animalsbeingjerks (or !abj)
  - posts random image from [Animals Being Dicks](http://animalsbeingdicks.com)
- Awkward Family Photos
  - command: say "awkward" in a line of chat
  - posts random image from [Awkward Family Photos](http://awkwardfamilyphotos.com)
- Bash
  - command: !bash
  - posts random "top quote" from [bash.org](http://bash.org)
- Cat Facts
  - command: !catfacts
  - posts random cat fact
- Compliment
  - command: !compliment <user-name>
  - @-messages a random compliment to user-name
- Computer History
  - command: !computerhistory
  - posts today's ["This Day in Computer History"](http://www.computerhistory.org/tdih/) from the [Computer History Museum](http://www.computerhistory.org)
- DailyKitten
  - command: !dailykitten
  - posts today's kitten from [dailykitten.com](http://dailykitten.com)
- DailyPuppy
  - command: !dailypuppy
  - posts today's puppy from [dailypuppy.com](http://dailypuppy.com)
- DefProgramming
  - command: !defprogramming (or !defp)
  - posts random quote from [defprogramming.com](http://defprogramming.com)
- DesignMilk
  - command: !designmilk (or !dm)
  - lists the latest posts on [Design Milk](http://design-milk.com)
- Domain
  - command: !domain <domain-name>
  - Performs whois lookup to see if domain-name is registered or not, provides either registration info or direct link to Dynadot's domain registration page
- EpicFail
  - command: say "fail" in a line of chat
  - posts random image from [epicfail.com](http://epicfail.com)
- Excuses
  - command: !excuse (or !excuses)
  - posts random excuse from [Developer Excuses](http://developerexcuses.com) or [BOFH Excuses](http://bofh.gotblah.com/)
- Nietzsche Family Circus
  - command: !familycircus (or !nfc), or say "nietzsche" in a line of chat
  - posts comic from [Nietzsche Family Circus](http://nietzschefamilycircus.com)
- FML
  - command: !fml
  - posts random story from fmylife.com
- Garfield Minus Garfield
  - command: !garfieldminusgarfield (or !garfield or !gmg), or say "garfield" in a line of chat
  - posts random comic from [Garfield Minus Garfield](http://garfieldminusgarfield.net)
- HackADay
  - command: !hackaday
  - lists latest posts on [Hack A Day](http://hackaday.com)
- HackerNews
  - command: !hackernews (or !hn)
  - lists top posts on [HackerNews](http://news.ycombinator.com)
- Insult
  - command: !insult <user-name>
  - @-messages a random insult to <user-name>
- IsUp
  - command: !isup <domain>
  - checks if website at <domain> is online, via [isup.me](http://isup.me)
- KittenWar
  - command: !kittenwar
  - posts kitten vs. kitten from [kittenwar.com](http://www.kittenwar.com)
- LikeABoss
  - command: say "like a boss/baus/bau5" in a line of chat
  - posts a "Like a Boss" GIF
- LOLCats
  - command: !lolcat
  - posts a random LOLCat from [icanhas.cheezburger.com](http://icanhas.cheezburger.com/lolcats)
- Lynda
  - command: !lynda
  - lists the latest tutorials on [Lynda.com](http://lynda.com)
- MissionStatement
  - command: !missionstatement
  - posts a randomly generated mission statement
- PennyArcade
  - command: !pennyarcade (or !pa)
  - posts the latest Penny Arcade comic
- PizzaGifs
  - command: say "pizza" in a line of chat
  - posts a random pizza GIF from [Animated Pizza GIFs](http://animatedpizzagifs.com)
- RubyFlow
  - command: !rubyflow (or !rf)
  - lists the latest posts on [RubyFlow](http://rubyflow.com)
- Scheduler
  - see Scheduler wiki page
- SmashingMagazine
  - command: !smashingmagazine (or !smashing)
  - lists the latest posts on [Smashing Magazine](http://smashingmagazine.com)
- Stock Ticker
  - command: !stockticker (or !stocks or !ticker)
  - configuration: symbols.csv file in stockticker/ plugin folder
  - Prints latest stock quotes of symbols listed in symbols.csv file
- ThatsWhatSheSaid
  - command: say a line of rather suggestive text
  - responds to certain lines of text with an exclamation of, "That's what she said!". Very juvenile.
- Uptime
  - command: !uptime
  - Prints the uptime of the current bot connection
- Weather
  - command: !weather
  - configuration: weather.csv file in weather/ plugin folder
  - Displays current and forecasted weather for the ZIP codes listed in weather.csv
- WebDesignLedger
  - command: !webdesignledger (or !wdl)
  - Lists latest week's posts on [Web Design Ledger](http://webdesignledger.com)
- XKCD
  - command: !xkcd new or !xkcd random
  - Posts a new or random [xkcd](http://xkcd.com) comic
