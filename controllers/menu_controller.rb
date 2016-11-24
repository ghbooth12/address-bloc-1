require_relative '../models/address_book'

class MenuController
  attr_reader :address_book

  def initialize
    # Instead of creating a new address book object when the program launches,
    # the existing one in the database will be used.
    @address_book = AddressBook.first
  end

  def main_menu
    puts "#{@address_book.name} Address Book Selected\n#{@address_book.entries.count} entries."
    puts "0 - Switch AddressBook"
    puts "1 - View all entries"
    puts "2 - Create an entry"
    puts "3 - Search for an entry"
    puts "4 - Import entries from a CSV"
    puts "5 - Exit"
    puts "6 - TESTING PURPOSE"
    print "Enter your selection: "

    selection = gets.to_i

    case selection
      when 0
        system "clear"
        select_address_book_menu
        main_menu
      when 1
        system "clear"
        view_all_entries
        main_menu
      when 2
        system "clear"
        create_entry
        main_menu
      when 3
        system "clear"
        search_entries
        main_menu
      when 4
        system "clear"
        read_csv
        main_menu
      when 5
        puts "Good-bye!"
        exit(0)
      when 6
        system "clear"
        not_show
        main_menu
      else
        system "clear"
        puts "Sorry, that is not a valid input"
        main_menu
    end
  end

  def select_address_book_menu
    # List the available address books
    puts "Select an Address Book:"
    AddressBook.all.each_with_index do |address_book, index|
      puts "#{index + 1} - #{address_book.name}"
    end

    index = gets.chomp.to_i

    @address_book = AddressBook.find(index)
    system "clear"
    return if @address_book
    puts "Please select a valid index."
    select_address_book_menu
  end

  def view_all_entries
    @address_book.entries.each do |entry|
      system "clear"
      puts entry.to_s
      entry_submenu(entry)
    end

    system "clear"
    puts "End of entries"
  end

  def create_entry
    system "clear"
    puts "New AddressBloc Entry"
    print "Name: "
    name = gets.chomp
    print "Phone number: "
    phone = gets.chomp
    print "Email: "
    email = gets.chomp

    @address_book.add_entry(name, phone, email)

    system "clear"
    puts "New entry created"
  end

  def search_entries
    print "Search by name: "
    name = gets.chomp
    match = @address_book.find_entry(name)

    ## TEST for Selection.method_missing()
    # match = Entry.find_by_name(name)
    ## TEST for find_each()
    # Entry.find_each(batch_size: 2) {|match| puts match.to_s}
    ## TEST for find_in_batches
    # Entry.find_in_batches(batch_size: 2) do |contacts|
    #   contacts.each {|contact| puts contact.name}
    # end

    system "clear"
    if match
      puts match.to_s
      search_submenu(match)
    else
      puts "No match found for #{name}"
    end
  end

  def read_csv
    print "Enter CSV file to import: "
    file_name = gets.chomp

    if file_name.empty?
      system "clear"
      puts "No CSV file read"
      main_menu
    end

    begin
      entry_count = address_book.import_from_csv(file_name).count
      system "clear"
      puts "#{entry_count} new entries added from #{file_name}"
    rescue
      puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
      read_csv
    end
  end

  def entry_submenu(entry)
    puts "n - next entry"
    puts "d - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"

    selection = gets.chomp

    case selection
      when "n"
      when "d"
        delete_entry(entry)
      when "e"
        edit_entry(entry)
        entry_submenu(entry)
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        entry_submenu(entry)
    end
  end

  def delete_entry(entry)
    address_book.entries.delete(entry)
    puts "#{entry.name} has been deleted"
  end

  def edit_entry(entry)
    updates = {}

    print "Updated name: "
    name = gets.chomp
    updates[:name] = name unless name.empty?

    print "Updated phone number: "
    phone_number = gets.chomp
    updates[:phone_number] = phone_number unless phone_number.empty?

    print "Updated email: "
    email = gets.chomp
    updates[:email] = email unless email.empty?

    entry.update_attributes(updates)
    system "clear"
    puts "Updated entry:"
    puts Entry.find(entry.id)
  end

  def search_submenu(entry)
    puts "\nd - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"
    selection = gets.chomp

    case selection
      when "d"
        system "clear"
        delete_entry(entry)
        main_menu
      when "e"
        edit_entry(entry)
        system "clear"
        main_menu
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        puts entry.to_s
        search_submenu(entry)
    end
  end

  def not_show
    results = @address_book.entries
    # results = Entry.join(:comment).where("comment.body IS NULL")

    # results = AddressBook.joins(entry: :comment).where("entry.email IS NULL")

    # for i in results
    #   puts "#{i.name}"
    # end
    puts results
  end
end
