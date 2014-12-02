require 'mongoid'
require 'quick-search'

module MongoidTestModels
  class SimpleUser
    include Mongoid::Document
    include QuickSearch

    embeds_many :pets, class_name: 'MongoidTestModels::SimplePet'

    field :name, type: String
    field :age, type: Integer
  end

  class SimplePet
    include Mongoid::Document

    embedded_in :simple_user

    field :name, type: String
    field :age, type: Integer
  end

  class UserConfiguredForSubdocument
    include Mongoid::Document
    include QuickSearch

    embeds_many :pets, class_name: 'MongoidTestModels::PetConfiguredForSubdocument'

    field :name, type: String
    field :age, type: Integer

    quick_search_fields :name, pets: :name
  end

  class PetConfiguredForSubdocument
    include Mongoid::Document

    embedded_in :user_configured_for_subdocument

    field :name, type: String
    field :age, type: Integer
  end

  Mongoid.load! 'spec/models/mongoid.yml', :test
  Mongoid::Config.purge!

  SimpleUser.create! name: 'John' do |u|
    u.pets.build name: 'Schatzi', age: 3
    u.pets.build name: 'Blume', age: 2
    u.pets.build name: 'Waldi', age: 1
  end

  UserConfiguredForSubdocument.create! name: 'John' do |u|
    u.pets.build name: 'Schatzi', age: 3
    u.pets.build name: 'Blume', age: 2
    u.pets.build name: 'Waldi', age: 1
  end
end