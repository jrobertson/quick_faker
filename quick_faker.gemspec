Gem::Specification.new do |s|
  s.name = 'quick_faker'
  s.version = '0.2.1'
  s.summary = 'Handy Faker wrapper for noobs too lazy to read the documentation.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/quick_faker.rb', 'data/faker.yaml']
  s.add_runtime_dependency('c32', '~> 0.3', '>=0.3.0')
  s.add_runtime_dependency('faker', '~> 2.21', '>=2.21.0')
  s.add_runtime_dependency('rxfreader', '~> 0.3', '>=0.3.3')
  s.signing_key = '../privatekeys/quick_faker.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/quick_faker'
end
