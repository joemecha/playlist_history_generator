# Create admin user
User.find_or_create_by!(email: ENV['APP_ADMIN_EMAIL']) do |u|
  u.password = ENV['APP_ADMIN_PASSWORD']
  u.music_league_id = ENV['ADMIN_MUSIC_LEAGUE_ID']
end

# Seed demo user
return if Rails.env.test?

demo_id = Rails.application.credentials
               .dig(:music_league, :authorized_ids)
               &.find { |id| id == "demo-music-league-id" }

return unless demo_id

User.find_or_create_by!(music_league_user_id: demo_id) do |user|
  user.email = "demo@example.com"
  user.password = ENV["DEMO_USER_PASSWORD"]
  user.password_confirmation = user.password
  user.admin = false
end

