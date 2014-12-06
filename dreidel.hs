import System.Random

module Dreidel where
  let NUM_DREIDEL_SIDES = 4
  data Side = Nun | Gimmel | Hay | Shin deriving (Show)
  spin :: IO Spin
  spin = do
    n <- random :: IO Integer
    let side = [Nun, Gimmel, Hay, Shin] !! (n `mod` NUM_DREIDEL_SIDES)
    return side
