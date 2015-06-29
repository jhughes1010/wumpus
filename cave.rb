class Cave
  attr_reader :roomNumber
  attr_accessor :vertices
  attr_accessor :hasBats
  attr_accessor :hasPit

  def initialize(roomNumber)
    @roomNumber = roomNumber
    @vertices = []
  end
end