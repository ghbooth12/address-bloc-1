require_relative 'entry'
require "csv"
require "bloc_record/base"

class AddressBook < BlocRecord::Base  # Inherit from the base class
  attr_reader :entries

  # Instance variables are now determined from the database table,
  # we no longer need initialize or a declaration for @entries.
  # def initialize
  #   @entries = []
  # end

  def add_entry(name, phone_number, email)
    Entry.create(address_book_id: self.id, name: name, phone_number: phone_number, email: email)
  end

  def import_from_csv(file_name)
    # Implementation goes here
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
    end
  end
end
