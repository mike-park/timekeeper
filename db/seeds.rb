# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end

puts 'THERAPISTS'
password = 'password1'
users = {
    SW: { email: 'a@example.com', name: 'A Name', password: password, password_confirmation: password },
    DK: { email: 'b@example.com', name: 'B Name', password: password, password_confirmation: password },
    SS: { email: 'c@example.com', name: 'C Name', password: password, password_confirmation: password },
    HZ: { email: 'd@example.com', name: 'D Name', password: password, password_confirmation: password },
    BZ: { email: 'e@example.com', name: 'E Name', password: password, password_confirmation: password },
}
therapists = {
    SW: { first_name: 'A', last_name: 'A', category: 'GO' },
    DK: { first_name: 'B', last_name: 'B', category: 'HP' },
    SS: { first_name: 'C', last_name: 'C', category: 'LO' },
    HZ: { first_name: 'D', last_name: 'D', category: 'PT' }
}
bank = { bank: 'Sparkasse GT', blz: '415 500 10', konto_nr: '123 567' }
t = []
therapists.each_with_index do |(abbrv, attrs), i|
  t[i] = Therapist.find_or_create_by_abbrv(attrs.merge(abbrv: abbrv).merge(bank))
  user = User.find_or_create_by_email(users[abbrv].merge(therapist_id: t[i].id))
  puts "therapist & user: #{t[i].full_name}"
end
User.find_or_create_by_email(users[:BZ].merge(therapist_id: t[3].id))

puts 'EVENT CATEGORIES'
categories = [
    { abbrv: 'ET', title: 'Einzel-therapie', color: '#099', price: 1},
    { abbrv: 'GT', title: 'Gruppen-therapie', color: '#006363', price: 2 },
    { abbrv: 'IG', title: 'IFF-Gespräche', color: '#f00', price: 3 },
    { abbrv: 'EG', title: 'Eingangs-gespräch', color: '#a60000', price: 4 },
    { abbrv: 'EGF', title: 'Eltern-gespräch (FuB)', color: '#ff7373', price: 5 },
    { abbrv: 'ED', title: 'Eingangs-diagnostik (vertiefende)', color: '#9fee00', price: 6 },
    { abbrv: 'VD', title: 'Verlaufs-diagnostik', color: '#86b32d', price: 7 },
    { abbrv: 'AD', title: 'Abschluss-diagnostik', color: '#679b00', price: 8 }
]

therapist_list = therapists.keys.map(&:to_s).join(',')
categories.each_with_index do |attrs, i|
  ec = EventCategory.find_or_create_by_abbrv(attrs.except(:price).merge(sort_order: i))
  ecp = EventCategoryPrice.find_or_create_by_event_category_id(event_category_id: ec.id, title: 'As of 1.1.2013',
                                                               price: attrs[:price], therapist_list: therapist_list)
  puts "cat: #{ec.title} #{ecp.price}"
end


puts 'ADMIN USER'
password = 'password2'
sw = Therapist.find_by_abbrv('SW')
user = User.find_or_create_by_email name: 'Admin User', email: 'admin@example.com', password: password, password_confirmation: password, therapist_id: sw.id
puts 'admin: ' << user.name
user.add_role :admin


puts 'CLIENTS'
clients = [
    { first_name: 'Bob', last_name: 'Springfield', dob: Date.yesterday, therapist_list: 'SW,DK' },
    { first_name: 'Sally', last_name: 'Field', dob: Date.today, therapist_list: 'SS,HZ' },
    { first_name: 'Alice', last_name: 'Gündren', dob: Date.tomorrow, therapist_list: 'DK,SS' }
]
c = []
clients.each_with_index do |attrs, i|
  c[i] = Client.find_or_create_by_last_name(attrs)
  puts "client: #{c[i].full_name}"
end

puts 'EVENTS'
events = [
    { occurred_on: Date.yesterday, therapist_id: t[0].id, client_id: c[0].id, event_category_id: EventCategory.first.id },
    { occurred_on: Date.today, therapist_id: t[2].id, client_id: c[1].id, event_category_id: EventCategory.all[1].id },
    { occurred_on: Date.tomorrow, therapist_id: t[3].id, client_id: c[2].id, event_category_id: EventCategory.last.id }
]
events.each do |event|
  [0,7,7].each do |offset|
    event[:occurred_on] -= offset
    unless Event.where(event).first
      e = Event.create(event)
      puts "event: #{e.client.full_name} on #{e.occurred_on}"
    end
  end
end
