namespace :lint do
  desc "Run RuboCop linting (check only)"
  task check: :environment do
    puts "Running RuboCop linting..."
    system("bundle exec rubocop")
  end

  desc "Run RuboCop and auto-fix issues"
  task fix: :environment do
    puts "Running RuboCop with auto-fix..."
    system("bundle exec rubocop -a")
  end

  desc "Run RuboCop and auto-fix all possible issues"
  task "fix-all": :environment do
    puts "Running RuboCop with aggressive auto-fix..."
    system("bundle exec rubocop -A")
  end

  desc "Run all linting tools"
  task all: :environment do
    puts "Running all linting tools..."
    puts "\n=== RuboCop ==="
    system("bundle exec rubocop")
    puts "\n=== Brakeman (Security) ==="
    system("bundle exec brakeman --no-pager")
  end
end

# Alias for convenience
task lint: "lint:check"
task "lint-fix": "lint:fix"
