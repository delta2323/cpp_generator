#!/usr/bin/env ruby

require 'erb'

def to_lower_camel(tokens, delimiter)
  return "" if tokens.empty
  ret = tokens.dup
  ret[0].downcase!
  ret[1..-1].each{|t| t.capitalize!}
  ret.join(delimiter)
end

def to_upper_camel(tokens, delimiter)
  tokens.map{|t| t.capitalize}.join(delimiter)
end

def to_snake(tokens, delimiter="_")
  tokens.map{|t| t.downcase}.join(delimiter)
end

def convert(tokens, convention_type)
  if convention_type == :upper_camel || convention_type == :camel
    return to_upper_camel tokens, ""
  elsif convention_type == :lower_camel
    return to_lower_camel tokens, ""
  elsif convention_type == :snake_camel
    return to_snake tokens, "_"
  else
    raise "Unsupporeted contention type=#{convention_type}"
  end
end

def generate(source_file, template_file, classname, namespace)
  upcased_classname = classname.upcase
  raise "#{source_file} already exists." if File.exist? source_file
  File.open(source_file, "w"){|f|
    f.write ERB.new(File.open(template_file, "r").read).result(binding)
  }
  puts "Generated #{source_file}"
end

def main(option)
  sourcefile_prefix = convert option[:classname], option[:source_convention]
  classname = convert option[:classname], option[:class_convention]
  namespace = option[:namespace]

  generate "#{sourcefile_prefix}.hpp", "hpp.erb", classname, option[:namespace]
  generate "#{sourcefile_prefix}.cpp", "cpp.erb", classname, option[:namespace]

  test_tokens = option[:classname].dup
  test_tokens << "test"
  testfile_prefix = convert test_tokens, option[:source_convention]
  generate "#{testfile_prefix}.cpp", "test.erb", classname, option[:namespace]

  if option[:main]
    main_tokens = option[:classname].dup
    main_tokens << "main"
    mainfile_prefix = convert main_tokens, option[:source_convention]
    generate "#{mainfile_prefix}.cpp", "main.erb", classname, option[:namespace]
  end
end

def parse_option(argv)
  require 'optparse'
  option = {}
  option[:source_convention] = :upper_camel
  option[:class_convention] = :upper_camel

  opt = OptionParser.new
  opt.on("-c classname", "--classname classname", "classname (separated by underscore(_), e.g. hoge_fuga)"){|v|
    option[:classname] = v.split("_")
  }
  opt.on("-n [namespace]", "--namespace [namespace]", "namespace (e.g. hoge::fuga) [=]"){|v|
    option[:namespace] = v.split("::")
  }
  opt.on("-m", "--main", "if true, generate main file [=false]"){|v| option[:main] = true}
  opt.on("-s convention", "--source-convention type", /(camel|upper_camel|lower_camel|snake)/, "specify naming convention type of source files (one of camel/upper_case/lower_camel/snake) [=upper_camel]"){|v| 
    option[:source_convention] = v.to_sym
  }
  opt.on("-C convention", "--class-convention type", /(camel|upper_camel|lower_camel|snake)/, "specify naming convention type of class name (one of camel/upper_camel/lower_camel/snake) [=upper_camel]"){|v|
    option[:class_convention] = v.to_sym
  }
  opt.parse! argv
  option
end

if __FILE__ == $0
  option = parse_option ARGV
  main option
end
