class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :birth_city
      t.string :birth_state
      t.string :birth_country
      t.date :birth_date
      t.string :college
      t.string :draft_team
      t.string :draft_round
      t.string :draft_pick
      t.string :draft_year
      t.string :position
      t.string :height
      t.string :weight
      t.date :death_date
      t.date :death_city
      t.string :death_state
      t.string :death_country
      t.string :year_start
      t.string :year_end
      t.timestamps
    end
  end
end
