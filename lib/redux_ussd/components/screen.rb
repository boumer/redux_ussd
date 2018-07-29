require 'redux_ussd/components/text'
require 'redux_ussd/components/prompt'
require 'redux_ussd/components/option'
require 'forwardable'

module ReduxUssd
  module Components
    class Screen < Base
      class Proxy
        extend Forwardable

        def initialize(screen)
          @screen = screen
        end

        def_delegator :@screen, :add_option, :option
        def_delegator :@screen, :add_push, :push
        def_delegator :@screen, :add_text, :text
        def_delegator :@screen, :add_prompt, :prompt
        def_delegator :@screen, :add_process_block, :process
        def_delegator :@screen, :state
      end

      def initialize(options = {})
        @name = options[:name]
        @block = options[:block]
        @components = []
        @store = options[:store]
      end

      def render
        @components = []
        Proxy.new(self).instance_eval(&@block)
        @components.map(&:render).join("\n")
      end

      attr_reader :process_block

      def add_option(name, options = {})
        @components.push(Option.new(
                           option_index: option_components.count + 1,
                           name: name,
                           text: options[:text]))
        @store.dispatch(type: :register_route,
                        screen: @name,
                        target: name)
      end

      def add_text(text)
        @components.push(Text.new(text: text))
      end

      def add_prompt(name, options = {})
        @components.push(Prompt.new(name: name, text: options[:text]))
        @store.dispatch(type: :register_prompt,
                        target: name)
      end

      def add_process_block(&block)
        @process_block = block
      end

      def state
        @store.state
      end

      private

      def option_components
        @components.select { |c| c.is_a?(Option) }
      end
    end
  end
end