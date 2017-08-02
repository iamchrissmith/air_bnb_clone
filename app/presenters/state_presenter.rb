class StatePresenter
  alias :read_attribute_for_serialization :send
  attr_reader :results

  def initialize(results)
    @results = results
  end
end
