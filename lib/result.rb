class Result

  attr_reader :message
  attr_accessor :data

  def initialize(status, message)
    @status = status
    @message = message
  end

  def is_success?
    return @status == 'success'
  end

  def is_warning?
    return @status == 'warning'
  end

  def is_failure?
    return @status == 'failure'
  end

end
