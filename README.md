# QuickSearch

A quick search concern for ActiveRecord and Mongoid models.

[![Build Status](https://travis-ci.org/elementar/quick-search.svg?branch=master)](https://travis-ci.org/elementar/quick-search)

## Installation

Add this line to your application's Gemfile:

    gem 'quick-search'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quick-search

## Usage

`quick-search` ships with an `ActiveRecord` and a `Mongoid` adapter. Feel free to submit
a pull request for your favorite adapter.

To start using it, just add `include QuickSearch` somewhere on the model class you need.
The class will be augmented with a `quick_search` method, which can be called directly on your
model class (i.e., `User.quick_search('marge simpson')`) or chained with your scopes or another conditions
(i.e., `User.where(active: true).quick_search('homer simpson')`.

### Restricting the fields available for quick searching

By default, `quick-search` will try to match the tokens you specify on all string fields on the model.
If that's undesirable, you can restrict the fields:

    class MyModel
      include QuickSearch

      quick_search_fields :name, :address
    end

### Searching on relations (ActiveRecord only)

When using `quick-search` on ActiveRecord models, you can specify associations in which to search. They will
be automatically joined.

    class User < ActiveRecord::Base
      include QuickSearch

      has_many :pets

      quick_search_fields :name, :address, pets: [:name, parents: [:name]]
    end

### Searching on subdocuments (Mongoid only)

Using the same technique used for querying ActiveRecord relations, you can search inside Mongoid subdocuments:


    class User
      include Mongoid::Document
      include QuickSearch

      embeds_many :pets

      quick_search_fields :name, :address, pets: [:name, parents: [:name]]
    end

The Mongoid adapter will not perform queries on `has_many` or `belongs_to` relations. PR are welcome.

## How it works

A simple query like this:

    User.quick_search 'john wayne'

Generates, in ActiveRecord, the equivalent of this:

    User.where('name like :n or email like :n', n: '%john%')
        .where('name like :n or email like :n', n: '%wayne%')

And for Mongoid, the equivalent of this:

    User.where('$or' => [{name: /john/}, {email: /john/}])
        .where('$or' => [{name: /wayne/}, {email: /wayne/}])

## Contributing

1. Fork it ( http://github.com/elementar/quick-search/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
