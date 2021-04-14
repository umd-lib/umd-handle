namespace :jwt do
  desc 'Create a JWT token'
  task :create_token, [:description] => :environment do |_t, args|
    jwt_secret = get_jwt_secret
    token = create_token(jwt_secret, args[:description])
    puts(token)
  rescue ArgumentError => e
    $stderr.puts "ERROR: #{e}"
end

  desc 'List JWT tokens'
  task :list_tokens => :environment do
    list_tokens
  end
end

# Retrieves the JWT secret, or raises an ArgumentError if not found
def get_jwt_secret
  jwt_secret = Rails.application.config.jwt_secret
  raise ArgumentError.new("JWT Secret is not defined.") unless jwt_secret.present?
  jwt_secret
end

# Creates a token using the given JWT Secret and description, and logs it
# in the JwtTokenLog table. Raises ArgumentError if an error occurs.
def create_token(jwt_secret, description)
  token = generate_token(jwt_secret, token_payload)
  log_token(token, description)
  return token
rescue ActiveRecord::RecordInvalid => e
  raise ArgumentError.new(e)
end

# Returns the payload for the JWT token.
def token_payload
  {
    role: 'rest_api',
    # issued at (iat) - time in seconds since January 1, 1970
    iat: Time.zone.now.to_i
  }
end

# Returns a JWT token created from the given JWT secret and payload
def generate_token(jwt_secret, payload)
  token = JWT.encode(payload, jwt_secret, algorithm = 'HS256')
  token
end

# Logs the token, with the given description
def log_token(token, description)
  entry = JwtTokenLog.create(token: token, description: description)
  entry.save!
end

# Prints out a list of all the issued tokens
def list_tokens
  token_log_entries = JwtTokenLog.all.order(created_at: 'asc')
  if token_log_entries.size == 0
    puts "No token log entries found!"
  else
    token_log_entries.each do |entry|
      puts "#{entry.id},#{entry.token},#{entry.description},#{entry.created_at}"
    end
  end
end
