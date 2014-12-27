module Player where
  type Player = (String, Integer, Integer)

  getName :: Player -> String
  getName (name, _, _) = name

  getGelt :: Player -> Integer
  getGelt (_, gelt, _) = gelt

  getIndex :: Player -> Integer
  getIndex (_, _, index) = index
