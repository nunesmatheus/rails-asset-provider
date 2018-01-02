#!/usr/bin/ruby

require 'yaml'
require 'fileutils'

def quit(error=nil)
  puts error if error
  exit 1
end

def checkout(destination, ref)
  `git clone /app.git #{destination}`
  `git --work-tree=#{destination} --git-dir=#{destination}/.git checkout -f #{ref}`
  Dir.chdir destination
end

def extract_command(command)
  return '' unless command.is_a?(Array) && command.any?
  command.join ' && '
end

begin
  from, to, branch = STDIN.gets.chomp.split " "

  checkout "/tmp/#{ARGV[0]}", to

  app_directory = "/apps/#{ENV['APPLICATION_NAME']}"
  Dir.mkdir app_directory unless Dir.exists?(app_directory)
rescue Exception => e
  quit "ERROR #{e.message}"
end
