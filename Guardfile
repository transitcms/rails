# A sample Guardfile
# More info at https://github.com/guard/guard#readme

rspec_opts = {
#  cli:            '--colour --drb --format documentation --fail-fast',
  cli:            '--colour --format documentation --fail-fast',
  version:        2,
  all_after_pass: false,
  all_on_start:   false,
  notify:         true
}

guard 'rspec', rspec_opts do
  
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/transit/(.+)\.rb})     { |m| "spec/unit/#{m[1]}_spec.rb" }

  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  # watch(%r{^spec/.+_spec\.rb$})
  # watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  # watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  # watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  # watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  # watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  # watch('spec/spec_helper.rb')                        { "spec" }
  # watch('config/routes.rb')                           { "spec/routing" }
  # watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  # 
  # # Capybara request specs
  # watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
  
end

# 
# spork_opts = {
#   cucumber: false,
#   rspec: true,
#   rspec_env: { 'RAILS_ENV' => 'test' },
#   bundler: false,
#   notify: true,
#   wait: 30
# }
# 
# guard 'spork', spork_opts do
#   watch('spec/spec_helper.rb')
# end
