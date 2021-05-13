namespace :handle do
  desc 'Import CSV file'
  task :csv_import, [:file_path] => :environment do |_t, args|
    import_csv_file(args[:file_path])
  rescue ArgumentError => e
    $stderr.puts "ERROR: #{e}"
    $stderr.puts "Usage: rails handle:csv_import[file_path]"
  end
end

# Retrieves the JWT secret, or raises an ArgumentError if not found
def import_csv_file(file_path)
  puts "Importing handles from #{file_path}"
  raise ArgumentError.new("file_path is not provided.") unless file_path.present?
  # load the csv file
  # for each row
  #   check if prefix/suffix combination exists
  #     log and skip if yes
  #   import otherwise
  CSV.foreach(file_path, headers: true) do |row|
    handle = Handle.find_by(suffix: row['suffix'], prefix: row['prefix'])
    if handle.present?
      puts "Handle #{row['prefix']}/#{row['suffix']} already exists! Skipping."
      next
    end
    puts "Importing handle: #{row['prefix']}/#{row['suffix']}"
    handle = Handle.new(row.to_hash)
    puts "Import failed for #{row['prefix']}/#{row['suffix']}: #{handle.errors.full_messages}!" unless handle.save
  end
end
