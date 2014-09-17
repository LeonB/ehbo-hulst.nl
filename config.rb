###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Sprockets
###

# Set default locale to :nl
activate :i18n, :mount_at_root => :nl

sprockets.append_path File.join root, 'vendor'

###
# Page options, layouts, aliases and proxies
###

ignore "/contactpersonen/*"
ignore "/info/*"
ignore "/lessen/*"
ignore "/nieuws/*"

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Uses .env in the root of the project
activate :dotenv

set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true
set :markdown_engine, :redcarpet

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Make images smaller
  activate :imageoptim

  # Doesn't work for now because of https://github.com/middleman/middleman-minify-html/issues/6
  activate :minify_html,
    :remove_input_attributes => false

  # Enable cache buster
  activate :asset_hash

  # pre-gzip files
  activate :gzip, :exts => %w(.js .css .html .htm .json .rss .xml)

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method   = :ftp
  deploy.host     = ENV['DEPLOY_HOST']
  deploy.path     = ENV['DEPLOY_PATH']
  deploy.user     = ENV['DEPLOY_USER']
  deploy.password = ENV['DEPLOY_PASSWORD']
  # deploy.port  = 5309 # ssh port, default: 22
  deploy.clean = true
  # deploy.flags = '-rltgoDvzO --no-p --del' # add custom flags, default: -avz
end

# activate :directory_indexes

activate :middleman_simple_thumbnailer

# activate :thumbnailer,
#   :dimensions => {
#     :thumb => '100x',
#     :small => '200x',
#     :medium => '400x300'
#   },
#   :include_data_thumbnails => true,
#   :namespace_directory => %w(contactpersonen stories/fotos)

helpers do
  def nav_link(name, url, options={})
    options = {
      class: "mainlevel",
      active_if: url,
      page: current_page.url,
    }.update options
    a = options.delete(:active_if)
    active = Regexp === a ? current_page.url =~ a : current_page.url == a
    options[:id] = "active_menu" if active

    link_to name, url, options
  end

  require 'pathname'

  def sub_pages(dir)
    dir = Pathname.new(dir).cleanpath.to_s
    sitemap.resources.select do |resource|
      next if not resource.path.start_with?(dir + '/')
      next if resource.data.published == false
      true
    end
  end

  def images(dir)
    dir = Pathname.new(dir).cleanpath.to_s
    sitemap.resources.select do |resource|
      resource.path.start_with?(dir + '/')
    end
  end
end
