source "https://rubygems.org"

gem "jekyll", "~> 4.0.0"

gem "html-proofer"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima", "~> 2.5"
gem "minimal-mistakes-jekyll"

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem 'jekyll-relative-links'
  # gem 'jekyll-toc', '~> 0.13.0'
  # gem 'jekyll-extlinks'
  gem 'octopress-escape-code'
  # gem 'jekyll-include-cache'
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?
