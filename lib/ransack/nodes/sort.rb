module Ransack
  module Nodes
    class Sort < Node
      include Bindable

      attr_reader :name, :dir, :ransacker_args, :other_rules
      i18n_word :asc, :desc

      class << self
        def extract(context, str)
          return unless str
          attr, direction, other_rules = str.split(/\s+/,3)
          self.new(context).build(name: attr, dir: direction, other_rules: other_rules)
        end
      end

      def build(params)
        params.with_indifferent_access.each do |key, value|
          if key.match(/^(name|dir|ransacker_args|other_rules)$/)
            self.send("#{key}=", value)
          end
        end

        self
      end

      def valid?
        bound? && attr &&
        context.klassify(parent).ransortable_attributes(context.auth_object)
        .include?(attr_name)
      end

      def name=(name)
        @name = name
        context.bind(self, name)
      end

      def dir=(dir)
        dir = dir.downcase if dir
        @dir =
          if dir == 'asc'.freeze || dir == 'desc'.freeze
            dir
          else
            'asc'.freeze
          end
      end

      def ransacker_args=(ransack_args)
        @ransacker_args = ransack_args
      end

      def other_rules=(other_rules)
        @other_rules = other_rules
      end
    end
  end
end
