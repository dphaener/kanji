module Kanji
  module InstanceDefine
    def instance_define(*args)
      args.each do |arg|
        define_method "#{arg}" do |value|
          instance_variable_set("@_#{arg}", value)
        end
      end
    end
  end
end
