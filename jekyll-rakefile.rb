require "html_compressor"
require 'html-proofer'

##############
#   Build    #
##############

# Generate the site
# Minify, optimize, and compress

desc "build the site"
task :build do
  system "bundle exec jekyll build --incremental"
  system "bundle exec rake minify_html" #Minify our HTML
end

##############
#   Develop  #
##############

# Useful for development
# It watches for chagnes and updates when it finds them

desc "Watch the site and regenerate when it changes"
task :watch do
  system "bundle exec jekyll serve --watch"
end

################
#   Validate   #
################

# Validate HTML , and missing image alt tags

task :htmlproofer do
  Rake::Task['build'].invoke
  puts 'Running html proofer...'.yellow.bold
  HTMLProofer.check_directory('./_site', allow_hash_href: true,
                                        # ignore missing image alt tags
                                         alt_ignore: [/.*/],
                                        #  ignore _site/custom_404.html, _site/custom_50x.html, _site/search.html
                                         file_ignore: [/custom|search/],
                                        # only check links for 404s
                                         only_4xx: true,
                                        # ignore _site/reference b/c API links aren't generated during build; they're generated dynamically by tocify.js when opening page in browser
                                         url_ignore: [/reference/]
                                         ).run
end

##############
#   Deploy   #
##############

# Deploy the site
# Ping / Notify after site is deployed

desc "deploy the site"
task :deploy do
  system "bundle exec s3_website push"
  system "bundle exec rake notify" #ping google/bing about our sitemap updates
end

##############
#   Minify   #
##############

desc "Minify HTML"
task :minify_html do
  puts "## Minifying HTML"
  compressor = HtmlCompressor::HtmlCompressor.new
  Dir.glob("_site/**/*.html").each do |name|
    puts "Minifying #{name}"
    input = File.read(name)
    output = File.open("#{name}", "w")
    output << compressor.compress(input)
    output.close
  end
end

##############
#   Notify   #
##############

# Ping Google and Yahoo to let them know you updated your site

site = "www.YOUR-URL.com"

desc 'Notify Google of the new sitemap'
task :sitemapgoogle do
  begin
    require 'net/http'
    require 'uri'
    puts '* Pinging Google about our sitemap'
    Net::HTTP.get('www.google.com', '/webmasters/tools/ping?sitemap=' + URI.escape('#{site}/sitemap.xml'))
  rescue LoadError
    puts '! Could not ping Google about our sitemap, because Net::HTTP or URI could not be found.'
  end
end

desc 'Notify Bing of the new sitemap'
task :sitemapbing do
  begin
    require 'net/http'
    require 'uri'
    puts '* Pinging Bing about our sitemap'
    Net::HTTP.get('www.bing.com', '/webmaster/ping.aspx?siteMap=' + URI.escape('#{site}/sitemap.xml'))
  rescue LoadError
    puts '! Could not ping Bing about our sitemap, because Net::HTTP or URI could not be found.'
  end
end

desc "Notify various services about new content"
task :notify => [:sitemapgoogle, :sitemapbing] do
end
