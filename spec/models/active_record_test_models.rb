require 'active_record'
require 'quick-search'

ActiveRecord::Base.establish_connection ENV['DATABASE_URL'] || 'sqlite3::memory'
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :name
    t.integer :age
    t.timestamps
  end

  create_table :pets, force: true do |t|
    t.references :user
    t.string :name
    t.integer :age
    t.timestamps
  end
end

module ActiveRecordTestModels
  class SimpleUser < ActiveRecord::Base
    self.table_name = 'users'
    include QuickSearch

    has_many :pets, foreign_key: 'user_id'
  end

  class UserConfiguredWithJoins < ActiveRecord::Base
    self.table_name = 'users'
    include QuickSearch

    quick_search_fields :name, pets: :name

    has_many :pets, foreign_key: 'user_id'
  end

  class Pet < ActiveRecord::Base
  end

  SimpleUser.create! name: 'John' do |u|
    u.pets.build [{ name: 'Schatzi', age: 3 }, { name: 'Blume', age: 2 }, { name: 'Waldi', age: 1 }]
  end
end
