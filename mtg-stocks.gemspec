# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mtg/stocks/constants'

Gem::Specification.new do |spec|
  spec.name          = "mtg-stocks"
  spec.version       = Mtg::Stocks::VERSION
  spec.authors       = ["Matt Meng"]
  spec.email         = ["mengmatt@gmail.com"]

  spec.summary       = %q{Price scrapper for mtgstocks.com.}
  spec.description   = %q{Price scrapper for mtgstocks.com.}
  spec.homepage      = "https://github.com/mattmeng/mtg-stocks"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
