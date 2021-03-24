namespace :db do
  desc 'Drop, create, migrate, seed and populate sample data'
  task reset_with_sample_data: [:drop, :create, :migrate, :seed, :populate_sample_data] do
    puts 'Ready to go!'
  end

  desc 'Populates the database with sample data'
  task populate_sample_data: :environment do
    require 'faker'

    prefixes = Handle.prefixes
    repositories = Handle.repos

    num_handles = 50
    last_created_at = nil
    num_handles.times do |num|
      handle = Handle.new
      handle.prefix = prefixes.sample
      # Suffix is assigned by Handle model
      handle.url = Faker::Internet.url(host: 'example.com')
      handle.repo = repositories.sample
      handle.repo_id = "umd:#{Faker::Number.number(digits: 10)}"
      handle.description = Faker::Lorem.sentence(word_count: 3, random_words_to_add: 7) if rand > 0.25
      handle.notes = Faker::Lorem.paragraphs.join("\n\n") if rand > 0.5
      created_at = generate_created_at(num, num_handles, last_created_at)
      updated_at = Faker::Time.between(from: created_at, to: Time.now)
      last_created_at = created_at
      handle.created_at = created_at
      handle.updated_at = updated_at
      handle.save!
    end
  end

  # Generates "created_at" times over a range, to create a "nice" distribution
  # of times.
  #
  # current_index: The index of the current entry being generated
  # total_entries: The total number of entries that will be generated
  # last_created_at: The value of the last "created_at" entry, or nil
  def generate_created_at(current_index, total_entries, last_created_at)
    last_created_at = Time.new(2001, 1, 1, 0, 0, 0) if last_created_at.nil? # Midnight January 1, 2001
    now = Time.now
    difference_in_days = now - last_created_at
    percent = (current_index.to_f / total_entries) + 0.05
    latest_allowed_created_at = last_created_at + (difference_in_days * percent)
    latest_allowed_created_at = Time.now if latest_allowed_created_at > Time.now

    Faker::Time.between(from: last_created_at, to: latest_allowed_created_at)
  end
end
