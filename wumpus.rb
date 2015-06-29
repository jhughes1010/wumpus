require './cave.rb'
require './cave_system.rb'

# Hunt the Wumpus
# http://en.wikipedia.org/wiki/Hunt_the_Wumpus

def main
  puts "Welcome to Hunt the Wumpus, my first Ruby project, dedicated to Hara Ra, aka Gregory Yob, the creator of this game, first published in People's Computer Company journal Vol. 2 No. 1 in 1973."
  caveSystem = CaveSystem.new()
  # for debugging:
  #caveSystem.caves.each {|cave| printf("Cave # %d connects to %d, %d, and %d\n", cave.roomNumber, cave.vertices[0].roomNumber, cave.vertices[1].roomNumber, cave.vertices[2].roomNumber)}

  wumpusHunterIsAlive = true
  wumpusIsAlive = true
  wumpusInCave = caveSystem.caves.sample

  # This will typically deposit the hunter in cave #1.  Would be nice to be more random.
  hunterInCave = caveSystem.caves.find {|cave| !cave.hasBats && !cave.hasPit && cave != wumpusInCave}

    while (wumpusHunterIsAlive && wumpusIsAlive) do
    whereAmI(hunterInCave)
    connectsTo(hunterInCave)
    whatsNearMe(hunterInCave, wumpusInCave)
    prompt = moveOrShoot
    hunterInCave, wumpusInCave, wumpusIsAlive, wumpusHunterIsAlive = processUserAction(prompt, hunterInCave, wumpusInCave, caveSystem)

    # bats snatch hunter from a bottomless pit, but may drop him into a bottomless pit!
    hunterInCave = checkForBats(hunterInCave, caveSystem)
    wumpusHunterIsAlive = checkForPit(hunterInCave)

    # if the poor guy/gal is still alive, check if he/she bumped into a Wumpus!
    if wumpusHunterIsAlive then
      wumpusInCave, wumpusHunterIsAlive = checkHunterAndWumpus(hunterInCave, wumpusInCave)
    end

  end

  if !wumpusIsAlive then printf("You got the Wumpus!\n") end
end

def whereAmI(cave)
  printf("\n\nYou are in room # %d\n", cave.roomNumber)
end

def connectsTo(cave)
  printf("Tunnels lead to rooms %d, %d, and %d\n", cave.vertices[0].roomNumber, cave.vertices[1].roomNumber, cave.vertices[2].roomNumber)
end

def whatsNearMe(cave, wumpus)
  cave.vertices.each do |cv|
    if cv.hasBats then printf("I hear the bats!\n") end
    if cv.hasPit then printf("I feel a draft!\n") end
    if cv == wumpus then printf("I smell a Wumpus!\n") end
    end
end

def moveOrShoot
  printf("(M)ove or (S)hoot ? ")
  gets
end

def processUserAction(prompt, cave, wumpus, caveSystem)
  newCave = cave
  newWumpus = wumpus
  wumpusIsDead = false
  hunterIsDead = false

  case prompt
    when "M\n"
      newCave = getValidConnectingCave(cave)
    when "S\n"
      shootAtCave = getCaveForArrow(caveSystem)
      # Minimal logic here for now
      if shootAtCave == wumpus then
        wumpusIsDead = true
      else
        printf("Miss!\n")
        newWumpus = moveWumpus(wumpus)
        newWumpus, hunterIsAlive = checkHunterAndWumpus(cave, newWumpus)
        # sort of dumb
        hunterIsDead = !hunterIsAlive
      end
    else
      printf("Please enter M for Move or S for Shoot\n")
  end

  return newCave, newWumpus, !wumpusIsDead, !hunterIsDead
end

def checkHunterAndWumpus(cave, newWumpus)
  hunterIsAlive = true

  if newWumpus == cave then
    printf("EEEK!  You bumped into a Wumpus!\n")
    hunterIsAlive = (0..1).to_a.sample == 1

    if !hunterIsAlive
      printf("Yum, munch, munch, the Wumpus has eaten you!\n")
    else
      # move the wumpus again
      newWumpus = moveWumpus(newWumpus)
    end
  end

  return newWumpus, hunterIsAlive
end

def getValidConnectingCave(cave)
  valid = false

  while !valid do
    printf("Enter the room number to move to: ")
    roomNum = Integer(gets)
    newCave = cave.vertices.find {|cv| cv.roomNumber == roomNum}

    if !newCave then
      printf("You cannot go directly to that room.\n")
    else
      valid = true
    end
  end

  newCave
end

def getCaveForArrow(caveSystem)
  printf("Enter the room number to shoot into: ")
  roomNum = Integer(gets)
  caveSystem.caves[roomNum-1]
end

# wumpus moves randomly to another adjoining cave
def moveWumpus(wumpus)
   wumpus.vertices.sample
end

# return a random cave
def superBatZap(caveSystem)
   caveSystem.caves.sample
end

def checkForBats(hunterInCave, caveSystem)
  while hunterInCave.hasBats do
    printf("Super Bat Snatch!\n")
    hunterInCave = superBatZap(caveSystem)
  end
  hunterInCave
end

def checkForPit(hunterInCave)
  alive = true
  if hunterInCave.hasPit then
    printf("YYYAAAAHHHHHH....You fell into a bottomless pit.\n")
    alive = false
  end
  alive
end

main