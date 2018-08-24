module EasyTable
  module Components
    module Base
      def translate(key)
        controller = @template.controller_name
        I18n.t("easy_table.#{controller.singularize}.#{key}", default: key.to_s)
      end
    end
  end
end