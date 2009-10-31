def per_class_params_data_path
  Puppet[:modulepath].split(/:/).each do |path|
    possible = File.expand_path(File.join(path, '..', 'data', 'class_data.yaml'))
    return possible if File.file?(possible)
  end
  nil
end

def per_class_params_variable_settings(yaml_file, klass)
  data_hash = YAML.load_file(yaml_file)
  raise ArgumentError, "Data for %s is not a hash" % klass unless data_hash.is_a?(Hash)

  path, current = klass.split(/::/), data_hash
  current = current[path.shift] || {} while !path.empty?
  current
end

Puppet::Parser::Functions.newfunction :per_class_params, :type => :statement do |args|
  klass = args[0] if args.length == 1
  klass ||= resource.title

  yaml_file = per_class_params_data_path 
  raise ArgumentError, "Could not find data file for class %s" % klass unless yaml_file
  per_class_params_variable_settings(yaml_file, klass).each {|param, value| setvar(param, value) }
end
