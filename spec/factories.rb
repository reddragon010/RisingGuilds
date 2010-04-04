Factory.define :character do |f|
  f.user_id 1
  f.sequence(:name){|n| "TestBoon#{n}"} 
  f.rank 1
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
  f.talentspec1 "value for talentspec1"
  f.talentspec2 "value for talentspec2"
  f.profession1 "value for profession1"
  f.profession2 "value for profession2"
  f.main false
end

Factory.define :guild do |f|
  f.sequence(:name){|n| "BoonHordeNo#{n}"} 
  f.officer_rank 2
  f.raidleader_rank 3
  f.ail 200
  f.activity 1
  f.growth 1
  f.altratio 1
  f.classratio 1
  f.achivementpoints 1000
  f.ration 1
  f.website("http://hordeofboons.com")
  f.description("The HordeOfBoons Guild is a horde of boons. Each member is a boon and nothing more then that. Boons are little, sick beings with no life or future! ...")
end