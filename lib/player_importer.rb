# frozen_string_literal: true

require 'csv'

class PlayerImporter
  def initialize(file)
    @file_name = file
  end

  def basic_import
    start = Time.now

    loop_file do |data|
      Player.create!(data)
    end

    Time.now - start
  end

  def transaction_import
    start = Time.now

    Player.transaction do
      loop_file do |data|
        Player.create!(data)
      end
    end

    Time.now - start
  end

  def bulk_import_hash
    start = Time.now
    player_data = []
    
    loop_file do |data|
      player_data << data
    end
    Player.import(player_data)
    Time.now - start
  end

  def bulk_import_array
    start = Time.now
    player_data = []
    headers = nil

    loop_file do |data|
      headers ||= data.keys
      player_data << data.values
    end

    Player.import headers, player_data
    Time.now - start
  end

  def loop_file_bench
    start = Time.now
    loop_file {}
    Time.now - start
  end

  def loop_file
    counter = 0
    CSV.foreach(@file_name, headers: true) do |row|
      yield row.to_hash
      counter += 1
      break if counter > 100
    end
  end

  def copy
    con = Player.connection.raw_connection

    con.copy_data "COPY players FROM STDIN WITH CSV" do
      CSV.foreach(@file_name, headers: true) do |row|
        con.put_copy_data row.fields.to_csv
      end
    end
  end
end