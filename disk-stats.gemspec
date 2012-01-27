Gem::Specification.new do |s|
  s.name = 'disk-stats'
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Edward Muller"]
  s.date = "2012-01-26"
  s.description = 'Some stuff for dealing with /proc/diskstats'
  s.email = "edward@heroku.com"
  s.extra_rdoc_files = [
    "LICENSE.txt"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "Rakefile",
    "VERSION",
    "disk-stats.gemspec",
    "lib/disk-stats.rb",
    "test/helper.rb",
    "test/test_disk_stats.rb"
  ]
  s.homepage = "http://github.com/freeformz/disk-stats"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = 'Some stuff for dealing with /proc/diskstats'

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1.rc"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.1.rc"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.1.rc"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
