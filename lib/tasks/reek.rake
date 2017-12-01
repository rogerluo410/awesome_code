namespace :reek do
  # Example
  #
  #     # Reek changed files, the default compared branch is staging.
  #     ./bin/rake reek:check_changed
  #
  #     # Reek changed files, the compared branch is master
  #     ./bin/rake reek:check_changed[master]
  desc "Check code smells for changed files (based on staging)"
  task :check_changed, [:branch] do |t, args|
    branch = args[:branch] || 'staging'
    re = `git diff --name-only #{branch}`
    files = re.split("\n").delete_if { |name| !File.exist?(name) }

    puts "\nReek changed files:"
    files.each do |file|
      puts "  #{file}"
    end
    puts

    system "bundle exec reek #{files.join(' ')}"
  end
end
