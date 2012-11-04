require "builder"

set :layout, :article

activate :directory_indexes

set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true
set :markdown_engine, :redcarpet

# Build-specific configuration
configure :build do
	# For example, change the Compass output style for deployment
	activate :minify_css

	# Minify Javascript on build
	activate :minify_javascript
end
