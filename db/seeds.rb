# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create initial application statuses
statuses = ['applied', 'intro', 'tech', 'culture', 'final']
statuses.each do |status_name|
  ApplicationStatus.find_or_create_by(name: status_name)
end

# Create initial tech stacks
tech_stacks = [
  'Ruby on Rails', 'JavaScript', 'React', 'Vue.js', 'Angular', 'Node.js',
  'Python', 'Django', 'Flask', 'Java', 'Spring Boot', 'C#', '.NET',
  'PHP', 'Laravel', 'WordPress', 'Go', 'Rust', 'Elixir', 'Phoenix',
  'PostgreSQL', 'MySQL', 'MongoDB', 'Redis', 'AWS', 'Docker', 'Kubernetes',
  'Git', 'GitHub', 'CI/CD', 'TDD', 'Agile', 'Scrum'
]

tech_stacks.each do |tech_name|
  TechStack.find_or_create_by(name: tech_name)
end

puts "Seeded #{ApplicationStatus.count} application statuses"
puts "Seeded #{TechStack.count} tech stacks"
