# Legacy wrappers retained for compatibility, but styled with Tailwind-friendly classes.
SimpleForm.setup do |config|
  config.wrappers :bootstrap, tag: 'div', class: 'mb-5', error_class: 'field-with-errors' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'mb-2 block text-sm font-medium text-slate-700'
    b.wrapper tag: 'div', class: 'mt-1' do |ba|
      ba.use :input, class: 'block w-full rounded-lg border border-slate-300 px-3 py-2 text-slate-900 shadow-sm focus:border-cyan-500 focus:outline-none focus:ring-2 focus:ring-cyan-500/30'
      ba.use :error, wrap_with: { tag: 'span', class: 'mt-2 block text-sm text-red-600' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'mt-2 text-sm text-slate-500' }
    end
  end

  config.wrappers :prepend, tag: 'div', class: 'mb-5', error_class: 'field-with-errors' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'mb-2 block text-sm font-medium text-slate-700'
    b.wrapper tag: 'div', class: 'mt-1 flex rounded-lg border border-slate-300 bg-white px-3 py-2 shadow-sm focus-within:border-cyan-500 focus-within:ring-2 focus-within:ring-cyan-500/30' do |input|
      input.use :input, class: 'w-full border-0 p-0 text-slate-900 focus:ring-0'
      input.use :hint,  wrap_with: { tag: 'span', class: 'mt-2 block text-sm text-slate-500' }
      input.use :error, wrap_with: { tag: 'span', class: 'mt-2 block text-sm text-red-600' }
    end
  end

  config.wrappers :append, tag: 'div', class: 'mb-5', error_class: 'field-with-errors' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'mb-2 block text-sm font-medium text-slate-700'
    b.wrapper tag: 'div', class: 'mt-1 flex rounded-lg border border-slate-300 bg-white px-3 py-2 shadow-sm focus-within:border-cyan-500 focus-within:ring-2 focus-within:ring-cyan-500/30' do |input|
      input.use :input, class: 'w-full border-0 p-0 text-slate-900 focus:ring-0'
      input.use :hint,  wrap_with: { tag: 'span', class: 'mt-2 block text-sm text-slate-500' }
      input.use :error, wrap_with: { tag: 'span', class: 'mt-2 block text-sm text-red-600' }
    end
  end
end

module SimpleForm
  module ActionViewExtensions
    module FormHelper
      def simple_form_for_with_default_class(record, options = {}, &block)
        options[:html] ||= {}
        options[:html][:class] ||= 'space-y-5'
        simple_form_for_without_default_class(record, options, &block)
      end
      alias_method_chain :simple_form_for, :default_class
    end
  end
end
