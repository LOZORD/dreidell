module Player where
  type Player = ([Char], Integer, Integer)

  getName :: Player -> [Char]
  getName (name, gelt, index) = name

  getGelt :: Player -> Integer
  getGelt (name, gelt, index) = gelt

  getIndex :: Player -> Integer
  getIndex (name, gelt, index) = index
