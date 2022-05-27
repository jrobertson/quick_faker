#!/usr/bin/env ruby

# file: quick_faker.rb

# description: Handy Faker wrapper for noobs too lazy to read the documentation.

require 'yaml'
require 'faker'

class QuickFaker

  def initialize(locale='en-GB')

    Faker::Config.locale = locale
    s = File.join(File.dirname(__FILE__), '..', 'data', 'faker.yaml')
    a = YAML.load(File.read(s))

    load_methods(a)

  end

  def lookup(s, context=nil)
    found = @h[s.to_sym]
    if found[0].is_a? Array
      
      h = found.map {|x| x.last[/[^:]+(?=\.)/].downcase.to_sym}.zip(found.map(&:first)).to_h
      if context then
        h[context].call
      elsif h.keys.include? :name
        h[:name].call
      else
        raise 'provide context! options: ' + h.keys.map(&:to_s).join(', ')
      end
    else
      found[0].call
    end
  end

  def lookup2(s)

    found = @h[s.to_sym]
    if found[0].is_a? Array then
      found.map(&:last)
    else
      found.last
    end

  end

  def to_h()
    @h
  end

  private

  def load_methods(a2)

    @h = {}
    a2.each do |rawname, a|

      puts rawname + '...'

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
end

