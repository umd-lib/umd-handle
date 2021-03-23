namespace :db do
  desc 'Drop, create, migrate, seed and populate sample data'
  task reset_with_sample_data: [:drop, :create, :migrate, :seed, :populate_sample_data] do
    puts 'Ready to go!'
  end

  desc 'Populates the database with sample data'
  task populate_sample_data: :environment do
    require 'faker'

    prefixes = ['1903.1']
    repositories = ['fcrepo', 'fedora2', 'aspace','avalon']

    num_handles = 50
    num_handles.times do |num|
      handle = Handle.new
      handle.prefix = prefixes.sample
      handle.suffix = num.to_s
      handle.url = Faker::Internet.url(host: 'example.com')
      handle.repo = repositories.sample
      handle.repo_id = "umd:#{Faker::Number.number(digits: 10)}"
      handle.description = Faker::Lorem.sentence(word_count: 3, random_words_to_add: 7) if rand > 0.25
      handle.notes = Faker::Lorem.paragraphs.join("\n\n") if rand > 0.5
      handle.save!
    end
  end
end
