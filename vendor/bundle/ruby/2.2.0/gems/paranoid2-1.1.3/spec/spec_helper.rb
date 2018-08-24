require 'bundler'
Bundler.require

require 'minitest/autorun'

DB_FILE = 'tmp/test_db'

FileUtils.mkpath File.dirname(DB_FILE)
FileUtils.rm_f DB_FILE

ActiveRecord::Base.establish_connection adapter: 'sqlite3', :database => DB_FILE

[ 'CREATE TABLE parent_models (id INTEGER NOT NULL PRIMARY KEY, deleted_at DATETIME)',
  'CREATE TABLE paranoid_models (id INTEGER NOT NULL PRIMARY KEY, parent_model_id INTEGER, deleted_at DATETIME)',
  'CREATE TABLE featureful_models (id INTEGER NOT NULL PRIMARY KEY, deleted_at DATETIME, name VARCHAR(32))',
  'CREATE TABLE plain_models (id INTEGER NOT NULL PRIMARY KEY, deleted_at DATETIME)',
  'CREATE TABLE callback_models (id INTEGER NOT NULL PRIMARY KEY, deleted_at DATETIME)',
  'CREATE TABLE related_models (id INTEGER NOT NULL PRIMARY KEY, parent_model_id INTEGER NOT NULL, deleted_at DATETIME)',
  'CREATE TABLE employers (id INTEGER NOT NULL PRIMARY KEY, deleted_at DATETIME)',
  'CREATE TABLE employees (id INTEGER NOT NULL PRIMARY KEY, deleted_at DATETIME)',
  'CREATE TABLE jobs (id INTEGER NOT NULL PRIMARY KEY, employer_id INTEGER NOT NULL, employee_id INTEGER NOT NULL, deleted_at DATETIME)'
].each {|script| ActiveRecord::Base.connection.execute script }

require_relative 'spec_models'