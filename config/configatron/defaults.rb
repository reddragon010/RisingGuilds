# Put all your default configatron settings here.

configatron.version = 'v0.9.0 beta'

configatron.guilds.roles = ["member", "raidleader", "officer", "leader"]

configatron.arsenal.url.base = 'http://arsenal.rising-gods.de/'
configatron.arsenal.url.realm = 'r='

configatron.arsenal.url.character.sheet = 'character-sheet.xml'
configatron.arsenal.url.character.name = 'cn='

configatron.arsenal.url.guild.info = 'guild-info.xml'
configatron.arsenal.url.guild.name = 'gn='

configatron.wowarmory.url.base = 'http://eu.wowarmory.com/'
configatron.wowarmory.url.item.info = 'item-info.xml'
configatron.wowarmory.url.item.itemid = 'i='

configatron.wowhead.url.base = 'http://www.wowhead.com/'
configatron.wowhead.url.item.prefix = 'item='
configatron.wowhead.url.item.suffix = '&xml'

configatron.realms = {
  'PvE-Realm' => {
    :status_url => 'http://www.rising-gods.de/external/MaNGOSstats_pve/stats.xml'},
  'PvP-Realm' => {
    :status_url => 'http://www.rising-gods.de/external/MaNGOSstats/stats.xml'}
}

#Notifier *Config*
configatron.notifier.default_url = 'localhost:3000'

#raidplanner
configatron.raidplanner.status = {'Not Available' => 1, 'Available' => 2}
configatron.raidplanner.status_manager = {'Not Available' => 1, 'Available' => 2, 'Confirmed' => 3}
configatron.raidplanner.roles = ['Range','Meele', 'Heal', 'Tank']
configatron.raidplanner.classes = ["warrior","paladin","hunter","rogue","priest","dk","shaman","mage","warlock","druid"]
configatron.raidplanner.class_id_names = {"warrior" => 1, "paladin" => 2, "hunter" => 3, "rogue" => 4,  "priest" => 5, "dk" => 6, "shaman" => 7, "mage" => 8, "warlock" => 9, "druid" => 11} 

#guild serials password
configatron.guilds.serial_salt = "ChangeMe-seriously!!-CHANGEMEEE"