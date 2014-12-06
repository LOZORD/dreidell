module Dreidel where
  import System.Random
  num_dreidel_sides = 4
  data Side = Nun | Gimmel | Hay | Shin deriving (Show)
  spin :: IO Side
  spin = do
    n <- randomIO :: IO Int
    let side = [Nun, Gimmel, Hay, Shin] !! (n `mod` num_dreidel_sides)
    return side
