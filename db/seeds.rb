User.find_or_create_by!(email: ENV['APP_ADMIN_EMAIL']) do |u|
  u.password = ENV['APP_ADMIN_PASSWORD']
  u.music_league_id = ENV['ADMIN_MUSIC_LEAGUE_ID']
end
