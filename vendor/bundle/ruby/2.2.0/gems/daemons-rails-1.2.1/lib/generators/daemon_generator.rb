require 'rails/generators'
require 'daemons/rails'

class DaemonGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  argument :daemon_name, :type => :string, :default => "application"

  def generate_daemon
    daemons_dir = Daemons::Rails.configuration.daemons_directory

    unless File.exists?(Rails.root.join(daemons_dir, 'daemons'))
      copy_file "daemons", daemons_dir.join('daemons')
      chmod daemons_dir.join('daemons'), 0755
    end

    template "script.rb", daemons_dir.join("#{file_name}.rb")
    chmod daemons_dir.join("#{file_name}.rb"), 0755

    template "script_ctl", daemons_dir.join("#{file_name}_ctl")
    chmod daemons_dir.join("#{file_name}_ctl"), 0755

    unless File.exists?(Rails.root.join("config", "daemons.yml"))
      copy_file "daemons.yml", "config/daemons.yml"
    end
  end
end