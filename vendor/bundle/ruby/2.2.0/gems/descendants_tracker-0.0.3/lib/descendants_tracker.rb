# encoding: utf-8

# Module that adds descendant tracking to a class
module DescendantsTracker

  # @private
  def self.extended(descendant)
    setup(descendant)
  end
  private_class_method :extended

  # @return [Array]
  #
  # @private
  def self.setup(descendant)
    descendant.instance_variable_set('@descendants', [])
  end
  private_class_method :extended

  # Return the descendants of this class
  #
  # @example
  #   descendants = ParentClass.descendants
  #
  # @return [Array<Class>]
  #
  # @api public
  def descendants
    @descendants
  end

  # Add the descendant to this class and the superclass
  #
  # @param [Class] descendant
  #
  # @return [self]
  #
  # @api private
  def add_descendant(descendant)
    ancestor = superclass
    if ancestor.respond_to?(:add_descendant)
      ancestor.add_descendant(descendant)
    end
    descendants.unshift(descendant)
    self
  end

private

  # Hook called when class is inherited
  #
  # @param [Class] descendant
  #
  # @return [self]
  #
  # @api private
  def inherited(descendant)
    super
    DescendantsTracker.setup(descendant)
    add_descendant(descendant)
  end

end # module DescendantsTracker
