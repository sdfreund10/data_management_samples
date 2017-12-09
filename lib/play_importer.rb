# frozen_string_literal: true
require "csv"
class PlayImporter
  def initialize(file_name)
    @file_name = file_name
  end

  def non_batch_import
    # 45,951 records
    # => 137.225724

    start = Time.now
    play_data = []

    loop_file do |data|
      play_data << data
    end

    Play.import play_data
    Time.now - start
  end

  def batch_import
    # 45,951 records
    # => 105.4464

    start = Time.now
    play_data = []

    loop_file do |data|
      play_data << data
      if $. % 1_000 == 0
        Play.import play_data
        play_data = []
      end
    end

    Play.import play_data
    Time.now - start
  end

  def loop_file
    CSV.foreach(@file_name, headers: true) do |row|
      yield transform_keys(row)
    end
  end

  def transform_keys(row)
    row.to_hash.delete_if { |k, v| k.nil? || v.nil? }.transform_keys do |k|
      k.underscore.to_sym
    end
  end
end