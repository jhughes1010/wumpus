# Creates a cave system based on a dodecahedron, a 12 sided figure with 20 vertices, each vertex connects to 3 other vertices.
# The cave system therefore consists of 20 caves, each connecting to 3 other unique caves.
require './cave.rb'

class CaveSystem
  attr_reader :caves

  def initialize
    initializeCaveMatrix
    shuffleCaveMatrix
    initializeCaves
    initializeCaveVertices
    initializeCaveFeatures(1, 1)
  end

  # Create the array of caves
  def initializeCaves
    @caves = Array.new(20) {|n| Cave.new(n+1)}
    # or
    # @caves = Array.new
    # (1..20).each {|n| @caves.push(Cave.new(n))}
  end

  # Create an initial matrix of vertex numbers for a dodecahedron.
  def initializeCaveMatrix
    @caveMatrix = []
    @caveMatrix <<
        [ 1,  5,  4] << [ 0,  7,  2] << [ 1,  9,  3] << [ 2, 11,  4] <<
        [ 3, 13,  0] << [ 0, 14,  6] << [ 5, 16,  7] << [ 1,  6,  8] <<
        [ 7,  9, 17] << [ 2,  8, 10] << [ 9, 11, 18] << [10,  3, 12] <<
        [19, 11, 13] << [14, 12,  4] << [13,  5, 15] << [14, 19, 16] <<
        [ 6, 15, 17] << [16,  8, 18] << [10, 17, 19] << [12, 15, 18]
  end

  # shuffle the cave numbers, preserving vertices, so we get a random cave room numbers each time, but
  # still in the pattern of a dodecahedron.
  # stolen from here: stackoverflow.com/questions/4447270/java-array-with-vertices-of-dodecahedron
  def shuffleCaveMatrix
    shuffle = (0..19).to_a.sample(20)
    z = Array.new(20) {[0, 0, 0]}

    for i in 0..19 do
      vy = @caveMatrix[i]
      vz = [0, 0, 0]

      for j in 0..2 do
        vz[j] = shuffle[vy[j]]
      end

      z[shuffle[i]] = vz
    end

    @caveMatrix = z
  end

  # We want to work with objects instead of indices, so create the vertex Cave instances for each cave.
  def initializeCaveVertices
    @caveMatrix.each_with_index {|vertices, n| vertices.each {|vn| @caves[n].vertices.push(@caves[vn]) }}
  end

  # Initialize the cave system with superbats, pits, and the wumpus
  # Pits, bats, and the wumpus can all occupy the same room
  def initializeCaveFeatures(numBats, numPits)
    caves.sample(numBats).each {|cave| cave.hasBats = true}
    caves.sample(numPits).each {|cave| cave.hasPit = true}
  end
end