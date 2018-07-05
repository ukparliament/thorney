module ComponentSerializer
  class HintComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a hint component. In the front-end, this is a span element with the class of hint.
    #
    # @param [String] content a translation block that is evaluated in the front-end
    def initialize(content)
      @content = content
    end

    private

    def name
      'span'
    end

    def data
      {
        display: {
          data: [
            {
              component: 'hint'
            }
          ]
        },
        content: @content
      }
    end
  end
end
