Factory.define :Character do |f|
  f.user_id 1
  f.sequence(:name){|n| "TestBoon#{n}"} 
  f.rank 1
  f.realm "PvE-Realm"
  f.level 70
  f.online false
  f.last_seen 2.days.ago
  f.activity 1
  f.class_id 1
  f.race_id 1
  f.faction_id 1
  f.gender_id 1
  f.achivementpoints 100
  f.ail  200
  f.main false
end

Factory.define :Guild do |f|
  f.sequence(:name){|n| "BoonHordeNo#{n}"} 
  f.ail 200
  f.activity 1
  f.growth 1
  f.altratio 1
  f.classratio 1
  f.achivementpoints 1000
  f.rating 1
  f.realm "PvE-Realm"
  f.website("http://hordeofboons.com")
  f.description("The HordeOfBoons Guild is a horde of boons. Each member is a boon and nothing more then that. Boons are little, sick beings with no life or future! ...")
end

Factory.define :RemoteQuery do |f|
  f.priority 1
  f.efford 5
  f.action "update guild"
end

Factory.define :User do |f|
  f.sequence(:login) {|n| "user#{n}"}
  f.sequence(:email) {|n| "user#{n}@gmx.net"}
  f.password 'password'
  f.password_confirmation 'password'
  f.active true
end

Factory.define :Role do |f|
  f.name "testuser"
end