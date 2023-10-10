class FlightSerializer
  include JSONAPI::Serializer

  def initialize(flight, options = nil)
    super
    @error_message = options[:error_message]
    @status = options[:status]
  end

  attributes :distance

  has_many :routes do |object|
    Route.where(flights: object)
  end

  meta do |_, params|
    {
      status: params[:status],
      error_message: params[:error_message]
    }
  end
end
