module StructuredWarnings
  # This module encapsulates the extensions to Object, that are introduced
  # by this library.
  module Kernel

    # :call-seq:
    #   warn(message = nil)
    #   warn(warning_class, message)
    #   warn(warning_instance)
    #
    # This method provides a +raise+-like interface. It extends the default
    # warn in ::Kernel to allow the use of structured warnings.
    #
    # Internally it uses the StructuredWarnings::warner to format a message
    # based on the given warning class, the message and a stack frame.
    # The return value is passed to super, which is likely the implementation
    # in ::Kernel. That way, it is less likely, that structured_warnings
    # interferes with other extensions.
    #
    # It the warner return nil or an empty string the underlying warn will not
    # be called. That way, warnings may be transferred to other devices without
    # the need to redefine ::Kernel#warn.
    #
    # Just like the original version, this method does not take command line
    # switches or verbosity levels into account. In order to deactivate all
    # warnings use <code>Warning.disable</code>.
    #
    #   warn "This is an old-style warning" # This will emit a StandardWarning
    #
    #   class Foo
    #     def bar
    #       warn DeprecationWarning, "Never use bar again, use beer"
    #     end
    #     def beer
    #       "Ahhh"
    #     end
    #   end
    #
    #   warn Warning.new("The least specific warning you can get")
    #
    def warn(*args)
      first = args.shift
      if first.is_a? Class and first <= Warning
        warning = first
        message = args.shift

      elsif first.is_a? Warning
        warning = first.class
        message = first.message

      else
        warning = StandardWarning
        message = first.to_s
      end

      unless args.empty?
        raise ArgumentError,
              "wrong number of arguments (#{args.size + 2} for 2)"
      end

      if warning.active?
        output = StructuredWarnings.warner.format(warning, message, caller(1))
        super(output) unless output.nil? or output.to_s.empty?
      end
    end
  end
end
