class ValidationError < StandardError
  def initialize(msg="ValidationError")
    super
  end
end