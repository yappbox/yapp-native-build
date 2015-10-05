#!/usr/bin/env ruby
require 'aws-sdk'
require 'fileutils'
extend FileUtils

NGINX='nginx-1.8.0'
HOME=ENV['HOME']
PREFIX="#{HOME}/#{NGINX}-build"

puts 'Download nginx'
system "wget http://nginx.org/download/#{NGINX}.tar.gz"
system "wget http://nginx.org/download/#{NGINX}.tar.gz.asc"

puts 'Importing public keys'
Dir['keys/*'].each {|f| `gpg --import #{f}` }

puts 'Verify download'
system "gpg #{NGINX}.tar.gz.asc"
abort 'verify failed' unless $?.success?

puts 'Build nginx'
system "tar xvzf #{NGINX}.tar.gz"

mkdir_p PREFIX

cd NGINX do
  system "./configure --prefix='#{PREFIX}' && make && make install"
  abort 'build failed' unless $?.success?
end

system "tar cvzf #{NGINX}-build.tar.gz #{PREFIX}/"

s3 = Aws::S3::Resource.new(region:'us-west-2')
obj = s3.bucket(ENV['BUILD_BUCKET']).object("#{NGINX}-build.tar.gz")
obj.upload_file("#{NGINX}-build.tar.gz")
