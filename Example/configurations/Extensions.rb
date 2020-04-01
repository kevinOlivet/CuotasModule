
require "shellwords"

#change pods envioroment
def pod_selector(pods_env)
  color(32) { puts "Current User: " + ENV["USER"] }
    function_name = "#{pods_env}_pods"

    if self.respond_to?(function_name)
      eval(function_name)
    else
      abort("The function named #{function_name} doesn't exist!")
    end
    color(32) { puts "Using #{pods_env} pods" }
  puts "--------------------------------------------------------------------------------"
end
