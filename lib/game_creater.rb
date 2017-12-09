# frozen_string_literal: true

class GameCreator
  def game_data
    Play.group(:game_id, :season_year, :game_date).select(
      :game_id, :season_year, :game_date, 
      "MAX(offense_team) team_1", "MIN(offense_team) team_2",
      "SUM(CASE WHEN is_rush THEN 1 ELSE 0 END) num_rushes",
      "SUM(CASE WHEN is_pass THEN 1 ELSE 0 END) num_passes", 
      "SUM(CASE WHEN is_touchdown THEN 1 ELSE 0 END) num_touchdowns",
      "SUM(CASE WHEN is_sack THEN 1 ELSE 0 END) num_sacks",
      "SUM(yards) total_yards"
    )
  end
end

class Team
  has_many :players
end

class Players
  belongs_to :team
end

# SELECT * FROM teams
Team.all.each do |team|
  # SELECT * FROM players WHERE user_id = ?
  team.players
  # ...
end

# SELECT * FROM teams LEFT JOIN players ... 
Team.includes(:players) do |team|
  team.players
  # ...
end

# SELECT * FROM teams INNER JOIN players ...
Team.joins(:players) do |team|
  team.players
  # ...
end

