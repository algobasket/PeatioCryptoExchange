module StructuredWarnings
  # The Warner class implements a very simple interface. It simply formats
  # a warning, so it is more than just the message itself. This default
  # warner uses a format comparable to warnings emitted by rb_warn including
  # the place where the "thing that caused the warning" resides.
  class Warner
    #  Warner.new.format(DeprecationWarning, "more info..", caller)
    #     # => "demo.rb:5 : more info.. (DeprecationWarning)"
    def format(warning, message, stack)
      "#{stack.shift} : #{message} (#{warning})"
    end
  end
end
