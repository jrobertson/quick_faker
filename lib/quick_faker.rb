#!/usr/bin/env ruby

# file: quick_faker.rb

# description: Handy Faker wrapper for noobs too lazy to read the documentation.

require 'yaml'
require 'faker'
require 'c32'
require 'rxfreader'


class QuickFaker
  using ColouredText

  attr_reader :a, :topics

  def initialize(locale='en-GB', debug: false)

    @debug = debug
    Faker::Config.locale = locale
    s = File.join(File.dirname(__FILE__), '..', 'data', 'faker.yaml')

    a = YAML.load(File.read(s))
    @topics = a.to_h
    @a = a.flat_map(&:last)

    load_methods(a)

  end

  def lookup(s, context=nil)

    found = @h[s.to_sym]
    puts 'found: ' + found.inspect if @debug

    if found and found[0].is_a? Array

      h = found.map {|x| x.last[/[^:]+(?=\.)/].downcase.to_sym}.zip(found.map(&:first)).to_h
      if context then
        h[context.to_sym].call
      elsif h.keys.include? :name
        h[:name].call
      else
        raise 'provide context! options: ' + h.keys.map(&:to_s).join(', ') \
            + "\n   try e.g. lookup(:#{s}, :#{h.keys.first})"
      end
    elsif found
      found[0].call
    else
      puts ('*' + s.to_s + '* not found').warning
      puts ('try: ').info
      @a.grep /#{s}/i
    end
  end

  def lookup2(s)

    found = @h[s.to_sym]
    if found and found[0].is_a? Array then
      found.map(&:last)
    elsif found[0]
      found.last
    else
      puts ('*' + s.to_s + '* not found').warning
      puts ('try: ').info
      @a.grep(/#{s}/i)[/[^\.]+$/].uniq.sort
    end

  end

  def query(topic)
    @topics[topic.to_s.capitalize]
  end

  def options(s=nil)

    return query s if s

    @h.map do |key, a|
      a2 = a[0].is_a?(Array) ? a.map(&:last) : a.last
      [key, a2]
    end.sort_by(&:first)

  end

  def to_h()
    @h
  end

  private

  def load_methods(a2)

    @h = {}
    a2.each do |rawname, a|

      puts ('  reading ' + rawname + '...').info

      a.each do |mname|

        key = mname[/[^\.]+$/].to_sym
        proc1 = -> {
          Object.const_get(mname[/^[^\.]+/]).method(mname[/[^\.]+$/].to_sym).call
        }

        item = [proc1, mname]

        if @h.include? key then

          if @h[key][0].is_a? Proc then
            @h[key] = [@h[key], item]
          elsif @h[key][-1].is_a? Array
            @h[key] << item
          end

        else
          @h[key] = item
        end

      end
    end
  end

  def method_missing(method_name, *args)
    lookup(method_name, *args)
  end
end

class FakerData

  def initialize(topics=nil, filepath: '/tmp/faker.yaml')

    topics ||= %w(Address Company Date Educator Gender Hobby Name Relationship Vehicle)
    @url = 'https://raw.githubusercontent.com/faker-ruby/faker/master/doc/default/'
    @topics, @filepath = topics, filepath

  end

  def build()

    a2 = @topics.map do |rawname|

      puts rawname + '...'
      name = rawname.downcase
      url = @url + name + '.md'
      begin
        s, _ = RXFReader.read url
      rescue
        next
      end
      a = s.scan(/Faker::#{rawname}\S+/)
      a.reject! {|x| x[-1] == ':'}
      [rawname, a]

    end

    File.write @filepath, a2.compact.to_yaml
    puts 'written to ' + @filepath

  end

  # returns a list of topics
  #'
  def scrape(s)
    s.scan(/(?<=:)\w+/)
  end
end
