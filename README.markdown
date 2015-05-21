# Isis
### Chat bot for Slack, HipChat and Campfire

### Features
- [Slack](http://slack.com), [HipChat](http://hipchat.com) and [Campfire](http://campfirenow.com) support
- Supports both HTML output (through API) and room presence & text output (through XMPP) in HipChat
- Multi-room support
- Plugin support, see Plugins wiki page for writing new plugins

### Requirements
- Ruby 1.9+ or JRuby 1.7+

### Setup
1. Clone repository
1. Selectively enable/disable plugins by commenting/uncommenting them out of the Gemfile
1. Run `bundle install` to install dependencies
1. Copy `config/isis.yml.example` to `config/isis.yml`
1. Edit `isis.yml` to include your Slack, HipChat or Campfire credentials
1. Launch Isis in foreground:  
    `bin/isis`  
   or launch daemonized:  
    `bin/isis-daemon start`  

### Plugins
Plugins are now bundled as Gems. 

* [Animals Being Jerks](https://github.com/silentgrowl/isis-plugin-animalsbeingjerks)
* [bash.org Quotes](https://github.com/silentgrowl/isis-plugin-bash)
* [BBC World News](https://github.com/silentgrowl/isis-plugin-bbcworldnews)
* [Cat Facts](https://github.com/silentgrowl/isis-plugin-catfacts)
* [Clients From Hell](https://github.com/silentgrowl/isis-plugin-clientsfromhell)
* [Compliment](https://github.com/silentgrowl/isis-plugin-compliment)
* [Day in Computer History](https://github.com/silentgrowl/isis-plugin-computerhistory)
* [Daily Kitten](https://github.com/silentgrowl/isis-plugin-dailykitten)
* [Daily Puppy](https://github.com/silentgrowl/isis-plugin-dailypuppy)
* [Def Programming](https://github.com/silentgrowl/isis-plugin-defprogramming)
* [Design Milk](https://github.com/silentgrowl/isis-plugin-designmilk)
* [Devops Reactions](https://github.com/silentgrowl/isis-plugin-devopsreactions)
* [Domain Registration Check](https://github.com/silentgrowl/isis-plugin-domain)
* [Excuses](https://github.com/silentgrowl/isis-plugin-excuses)
* [HackerNews](https://github.com/silentgrowl/isis-plugin-hackernews)
* [Insult](https://github.com/silentgrowl/isis-plugin-insult)
* [Is Up?](https://github.com/silentgrowl/isis-plugin-isup)
* [Lynda.com New Releases](https://github.com/silentgrowl/isis-plugin-lynda)
* [Mission Statement Generator](https://github.com/silentgrowl/isis-plugin-missionstatement)
* [Nietzsche Family Circus](https://github.com/silentgrowl/isis-plugin-familycircus)
* [Pizza GIFs](https://github.com/silentgrowl/isis-plugin-pizzagifs)
* [RubyFlow](https://github.com/silentgrowl/isis-plugin-rubyflow)
* [Scheduler](https://github.com/silentgrowl/isis-plugin-scheduler)
* [Stock Ticker](https://github.com/silentgrowl/isis-plugin-stockticker)
* [Uptime](https://github.com/silentgrowl/isis-plugin-uptime)
* [Weather](https://github.com/silentgrowl/isis-plugin-weather)
* [Web Design Ledger](https://github.com/silentgrowl/isis-plugin-webdesignledger)
* [xkcd](https://github.com/silentgrowl/isis-plugin-xkcd)
