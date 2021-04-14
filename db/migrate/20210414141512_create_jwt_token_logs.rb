class CreateJwtTokenLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :jwt_token_logs do |t|
      t.string :token
      t.string :description

      t.timestamps
    end
  end
end
