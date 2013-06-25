#!/usr/bin/env ruby

require 'erb'


def main(option)
  classname = option[:classname]
  capitalized_classname = classname.map{|w| w.capitalize}.join("")
  upcased_classname = classname.map{|w| w.upcase}.join("_")
  downcased_classname = classname.map{|w| w.downcase}.join("_")
  namespace = option[:namespace]

  raise "#{capitalized_classname}.hpp already exists." if File.exist? capitalized_classname+".hpp"
  File.open("#{capitalized_classname}.hpp", "w"){|f|
    f.write ERB.new(File.open("hpp.erb", "r").read).result(binding)
  }
  puts "Generated #{capitalized_classname}.hpp"  

  raise "#{capitalized_classname}.cpp already exists." if File.exist? capitalized_classname+".cpp"
  File.open("#{capitalized_classname}.cpp", "w"){|f|
    f.write ERB.new(File.open("cpp.erb", "r").read).result(binding)
  }
  puts "Generated #{capitalized_classname}.cpp"

  raise "#{capitalized_classname}Test.cpp already exists." if File.exist? capitalized_classname+"Test.cpp"
  File.open("#{capitalized_classname}Test.cpp", "w"){|f|
    f.write ERB.new(File.open("test.erb", "r").read).result(binding)
  }
  puts "Generated #{capitalized_classname}Test.cpp"

  if option[:main]
    raise "#{capitalized_classname}Main.cpp already exists." if File.exist? capitalized_classname+"Main.cpp"
    File.open("#{capitalized_classname}Main.cpp", "w"){|f|
      f.write ERB.new(File.open("main.erb", "r").read).result(binding)
    }
    puts "Generated #{capitalized_classname}Main.cpp"
  end
end

def parse_option(argv)
  require 'optparse'
  option = {}
  opt = OptionParser.new
  opt.on("-n [namespace]", "--namespace"){|v| option[:namespace] = v.split("::")}
  opt.on("-m", "--main"){|v| option[:main] = true}
  opt.on("-c classname", "--classname"){|v| option[:classname] = v.split("_")}
  opt.parse! argv
  option
end

if __FILE__ == $0
  option = parse_option ARGV
  main option
end
