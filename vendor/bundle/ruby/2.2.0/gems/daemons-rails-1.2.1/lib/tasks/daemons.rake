require 'rake'

desc "Show status of daemons"
task :daemons => "daemons:status"

daemons_dir = Daemons::Rails.configuration.daemons_directory

namespace :daemons do
  %w[start stop status].each do |arg|
    desc "#{arg.capitalize} all daemons."
    task :"#{arg}" do
      puts `#{daemons_dir}/daemons #{arg}`
    end
  end
end

namespace :daemon do
  Dir[daemons_dir.join('*_ctl')].each do |controller|
    app_name = controller.sub(/.*\/(\w+)_ctl/, '\1')
    desc "Start #{app_name} script"
    task app_name do
      FileUtils.cd daemons_dir do
        load "#{app_name}.rb"
      end
    end

    namespace app_name do
      %w[start stop restart status].each do |arg|
        desc "#{arg.capitalize} #{app_name} daemon."
        task :"#{arg}" do
          puts `#{controller} #{arg}`
        end
      end
    end
  end
end