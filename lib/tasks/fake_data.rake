require 'faker'

desc 'create some fake data'
task fake_data: :environment do
  PROTOCOLS = ['ssh-rsa', 'ssh-dss', 'ssh-rsa1']
  ACTIVE = [true,false]
  1.upto(ENV['COUNT'].to_i) do |i|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    name = first_name + " " + last_name
    email = Faker::Internet.safe_email(name)
    username = Faker::Internet.user_name(name)
    user = User.create!(username: username,
      email: email,
      first_name: first_name,
      last_name: last_name,
      password: 'as12AS!@',
      password_confirmation: 'as12AS!@'
    )


    1.upto(3 + rand(20)) do |i|
      nickname = "#{username}@#{Faker::Lorem.word}"
      contents = "#{PROTOCOLS[rand(3)]}"
      contents += "#{Faker::Lorem.characters(255 + rand(1024)).upcase}"
      contents += "#{nickname}"
      active = ACTIVE[rand(1)]
      certificate = Certificate.create!(
        nickname: nickname,
        contents: contents,
        active: active,
        user_id: user.id
      )

      1.upto(rand(ExternalSite.all.count)) do |i|
        site = ExternalSite.all[rand(ExternalSite.all.count)]
        unless certificate.external_sites.find_by_name(site.name)
          certificate.external_sites << site
        end
      end

      user.certificates << certificate
      user.save
    end
  end
end

desc 'create some fake partner sites'
task fake_sites: :environment do
  ExternalSite.create!(name: 'CodePost')
  ExternalSite.create!(name: 'launchpad.net')
  ExternalSite.create!(name: 'GitHub')
  ExternalSite.create!(name: 'Heroku')
  ExternalSite.create!(name: 'BitBucket')
  ExternalSite.create!(name: 'CS@VT')
end

