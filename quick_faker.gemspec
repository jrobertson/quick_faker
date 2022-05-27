Gem::Specification.new do |s|
  s.name = 'quick_faker'
  s.version = '0.1.0'
  s.summary = 'Handy Faker wrapper for noobs too lazy to read the documentation.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/quick_faker.rb', 'data/faker.yaml']
  s.add_runtime_dependency('faker', '~> 2.21', '>=2.21.0')
  s.signing_key = '../privatekeys/quick_faker.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/quick_faker'
end
