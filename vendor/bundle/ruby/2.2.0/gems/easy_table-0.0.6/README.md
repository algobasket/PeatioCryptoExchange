# EasyTable

[![Build Status](https://travis-ci.org/cthulhu666/easy_table.png?branch=master)](https://travis-ci.org/cthulhu666/easy_table)

EasyTable provides a helper for building HTML tables in Rails applications.

It is inspired by simple_form gem: https://github.com/plataformatec/simple_form

## Installation

Add this line to your application's Gemfile:

    gem "easy_table"

And then execute:

    $ bundle

## Usage

All examples assume that You are using Haml. Please, use Haml !

### Simplest example

```haml
= table_for(@people) do |t|
  - t.column :name
  - t.column :surname
```

This produces:

```haml
%table
  %thead
    %tr
      %th name
      %th surname
  %tbody
    %tr#person-1
      %td John
      %td Doe
```

Assuming `@people` is a collection consisting of one record, person with id = 1, John Doe

### Simple example

```haml
= table_for(@people, class: 'people') do |t|
  - t.column :name, class: 'name' do |person|
    - person.name.downcase 
  - t.column :surname, class: lambda { |person| ['surname', person.surname.length > 5 && 'long'].compact } do |person|
    - person.surname.upcase
```

This produces:

```haml
%table.people
  %thead
    %tr
      %th name
      %th surname
  %tbody
    %tr#person-1
      %td.name john
      %td.surname DOE
    %tr#person-2
      %td.name alice
      %td.surname.long COOPER
```

Assuming `@people` is a collection consisting of two records:
 * person with id = 1, John Doe
 * person with id = 2, Alice Cooper

### Example with more complex table structure

```haml
= table_for(@people) do |t|
  - t.span 'personal data' do |s|
    - s.column :name
    - s.colunm :surname
  - t.span 'contact data' do |s|
    - s.column :email
    - s.column :phone
```

This produces:

```haml
%table
  %thead
    %tr
      %th{colspan: 2, scope: 'col'} personal data
      %th{colspan: 2, scope: 'col'} contact data
    %tr
      %th name
      %th surname
      %th email
      %th phone
  %tbody
    %tr#person-1
      %td John
      %td Doe
      %td john.doe@gmail.com
      %td 123456789    
```

### I18n and column headers

```yaml
en:
  easy_table:
    person: # this is matched based on controller_name.singularize
      name: 'Name'
      surname: 'Surname'
```

With following form definition

```haml
= table_for(@people) do |t|
  - t.column :name
  - t.column :surname
```

It will use 'Name' and 'Surname' as column header labels:

```haml
%table
  %thead
    %tr
      %th Name
      %th Surname
```

You can also explicitly set column header passing it as a second argument to ```column``` and ```span``` methods:

```haml
= table_for(@people) do |t|
  - t.column :name, 'Name'
  - t.column :surname, 'Surname'
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
