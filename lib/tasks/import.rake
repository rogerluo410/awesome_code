require 'csv'


namespace :import do
  namespace :db do
    namespace :fixtures do
      desc "Load csv fixtures into the current environment's database. 
            Load specific fixtures using FIXTURES=x,y"
      task :load_with_csv => :environment do
        fixtures_dir = Rails.root.join('db/fixtures').to_s
        fixtures = [
          'pharmacies'
        ]

        fixtures.each do |fixture|
          p "> loading #{fixture}.csv"
          klass = fixture.singularize.camelize.safe_constantize

          file_path = File.join(fixtures_dir, "#{fixture}.csv")
           
          CSV.foreach(file_path, {headers: :true}) do |row|
            klass.find_or_create_by!(row.to_h) 
          end if klass.present? and File.exists? file_path
        end
      end
    end
  end
end
