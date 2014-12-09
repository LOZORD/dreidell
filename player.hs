module Player where
  type Player = (String, Integer, Integer)

  getName :: Player -> String
  getName (name, gelt, index) = name

  getGelt :: Player -> Integer
  getGelt (name, gelt, index) = gelt

  getIndex :: Player -> Integer
  getIndex (name, gelt, index) = index
