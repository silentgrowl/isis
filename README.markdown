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
1. Run `bundle install` to install dependencies
1. Copy `config.yml.example` to `config.yml`
1. Edit `config.yml` to include your HipChat or Campfire credentials, and
   choose plugins to enable
1. Launch Isis in foreground:  
    `bin/isis`  
   or launch daemonized:  
    `bin/isis-daemon start`  

### Plugins
TODO: about plugins
