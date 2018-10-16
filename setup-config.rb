#!/usr/bin/env ruby

require 'liquid'

common_vars = Hash.new.tap do |h|
  env_vars = %w(home user 
rails_home passenger_pid_file delayed_job_pid_file
nginx_target_dir nginx2_target_dir nginx_server_names
nginx_digest_users_file
aws_bucket_name aws_region 
monit_contact monit_mailserver )
  env_vars.each do |var|
    h[var] = ENV[var.upcase]
  end
end

Dir.chdir(File.join(ENV['HOME'], 'bin/etc')) do 
  Dir['*.liquid'].each do |template_file|
    template = Liquid::Template.parse(File.read(template_file))
    target = template_file.sub(/\.liquid$/, '')
    File.open(target, 'w') do |f|
      f.puts template.render!(common_vars, strict_variables: true)
    end
  end
end
