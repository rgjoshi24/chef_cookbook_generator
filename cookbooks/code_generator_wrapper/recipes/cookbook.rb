#
# Cookbook:: code_generator_wrapper
# Recipe:: cookbook
#
# Copyright:: 2019, The Authors, All Rights Reserved.
#

context = ChefCLI::Generator.context
context.enable_workflow = false

include_recipe 'code_generator::cookbook'

cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)
files_dir = File.join(cookbook_dir, 'files')
directory files_dir do
  recursive true
end

# metadata.rb - customize this template
edit_resource(:template, "#{cookbook_dir}/metadata.rb") do
  cookbook 'code_generator_wrapper'
  source 'metadata.rb.erb'
end

# .foodcritic
cookbook_file "#{cookbook_dir}/.foodcritic" do
  source 'dot_foodcritic'
end

# .rubocop.yml
cookbook_file "#{cookbook_dir}/.rubocop.yml" do
  source 'dot_rubocop.yml'
end

# kitchen.yml - customize this template
edit_resource(:template, "#{cookbook_dir}/.kitchen.yml") do
  cookbook 'code_generator_wrapper'
  source 'kitchen.yml.erb'
  # no longer needs to be a hidden file, so remove the dot
  path "#{cookbook_dir}/kitchen.yml"
end

generated_cookbook_name = context.cookbook_name
template "#{cookbook_dir}/#{generated_cookbook_name}.rb" do
  variables(generated_cookbook_name: generated_cookbook_name)
  source 'CookbookNamePolicyfile.rb.erb'
end

template "#{cookbook_dir}/Policyfile.rb" do
  variables(generated_cookbook_name: generated_cookbook_name)
  source 'Policyfile.rb.erb'
end

template "#{cookbook_dir}/build-pipeline.yml" do
  source 'build-pipeline.yml.erb'
end

# edit_resource(:template, "#{cookbook_dir}/#{context.cookbook_name}.rb") do
#   cookbook 'code_generator_wrapper'
#   source 'Policyfile.rb.erb'
#   # no longer needs to be a hidden file, so remove the dot
#   path "#{cookbook_dir}/#{context.cookbook_name}.rb"
# end
