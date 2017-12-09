# frozen_string

require 'csv'

class PlayerUpserter
  def initialize(file)
    @file_name = file
  end

  def naive_upsert
    start = Time.now

    loop_file do |row|
      player = Player.find_or_initialize_by(
        first_name: row["first_name"], last_name: row["last_name"],
        birth_date: row["birth_date"]
      )

      player.update!(row)
    end

    Time.now - start
  end

  def transaction_upsert
    start = Time.now
    Player.transaction do
      loop_file do |row|
        player = Player.find_or_initialize_by(
          first_name: row["first_name"], last_name: row["last_name"],
          birth_date: row["birth_date"]
        )

        player.update!(row)
      end
    end

    Time.now - start
  end

  def upsert_gem
    start = Time.now

    connection = Player.connection

    Upsert.batch(connection, :players) do |upsert|
      loop_file do |row|
        upsert.row(
          row.slice("first_name", "last_name", "birth_date"),
          row
        )
      end
    end

    Time.now - start
  end

  def import_gem
    start = Time.now

    data = []
    loop_file do |row|
      data << row
    end

    Player.import data, on_duplicate_key_update: data
    Time.now - start
  end

  def random_delete
    ids = Player.ids.sample(2_000)
    Player.where(id: ids).delete_all
  end

  def loop_file
    counter = 0
    CSV.foreach(@file_name, headers: true) do |row|
      yield row.to_hash
      counter += 1
      break if counter > 100
    end
  end 
end