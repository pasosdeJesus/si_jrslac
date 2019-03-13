# Minimal sample configuration file for Unicorn (not Rack) when used
# with daemonization (unicorn -D) started in your working directory.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
# See also http://unicorn.bogomips.org/examples/unicorn.conf.rb for
# a more verbose configuration using more features.

if !ENV['DIRAP'] 
  puts "Falta DIRAP"
  exit 1
end
if !ENV['PUERTOCONLOC'] 
  puts "Falta PUERTOCONLOC"
  exit 1
end

listen 2032 # by default Unicorn listens on port 8080
APP_PATH = ENV['DIRAP']
working_directory APP_PATH
worker_processes 4 # this should be >= nr_cpus
pid APP_PATH + "/tmp/pids/unicorn.pid"
stderr_path APP_PATH + "/log/unicorn.log"
stdout_path APP_PATH + "/log/unicorn.log"

