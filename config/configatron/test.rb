# Override your default settings for the Test environment here.
# 
# Example:
#   configatron.file.storage = :local

configatron.arsenal.url.base = Rails.root.to_s + "/test/files/"
configatron.arsenal.url.realm = nil
configatron.arsenal.test = true

configatron.arsenal.url.character.sheet = 'char.xml'

configatron.arsenal.url.guild.info = 'guild.xml'

configatron.wowarmory.url.base = Rails.root.to_s + '/test/files/'
configatron.wowarmory.url.item.info = 'items/'

configatron.wowhead.url.base = Rails.root.to_s + '/test/files/'
configatron.wowhead.url.item.prefix = 'items/item='

configatron.onlinelist.url =  Rails.root.to_s + '/test/files/onlinelist.html'