namespace :timekeeper do
  namespace :load do
    desc 'Load yaml version of clients'
    task clients: :environment  do
      clients = YAML.load_file("config/clients.yml")
      clients.each do |client|
        found_or_new = Client.where(client.except(:therapist_list)).first_or_create!
        found_or_new.therapist_list = client[:therapist_list]
        found_or_new.save!
      end
      puts "#{clients.length} added/updated. Client total=#{Client.count}"
    end

    desc 'Load all data'
    task all: ['db:seed',:clients] do
    end
  end

  namespace :reminders do
    desc 'Send SMS reminders for missing signatures'
    task sms: :environment do
      Therapist.all.each do |therapist|
        MissingSignatureService.new(therapist).send_smses
      end
    end
  end
end