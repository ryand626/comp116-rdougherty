namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    
    [Location].each(&:delete_all)
    
    Dir.glob(Rails.root + 'app/IPlogs/*.log') do |file|
      puts file
      File.open(file, "r") do |f|
        f.each_line do |line|
          data = line.split(',')
          Location.create(address: data[0], attack_type: data[1])
        end
      end
    end

  end
end
