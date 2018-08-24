class Rails
  def Rails.root
    @root ||= Pathname.new(File.absolute_path(File.dirname(__FILE__))).join('fixtures')
  end
end