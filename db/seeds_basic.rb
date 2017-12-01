puts 'Initialize specialists'
['Endocrinology', 'Exercise physiologist', 'General Practitioner', 'Physiotherapist', 'Psychiatry'].each do |specialty|
  Specialty.find_or_create_by!(name: specialty)
end

puts 'create admin'
admin = Admin.new(email: 'admin@example.com', password: 'password')
admin.skip_confirmation!
admin.save!


puts 'Initialize db fixtures'
Rake::Task['import:db:fixtures:load_with_csv'].invoke
