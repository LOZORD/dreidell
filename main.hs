-- Dreidel/Sivivon game written in Haskell
-- By Leo Rudberg (LOZORD) in 2014

module Main where
  data Dreidel = Nun | Gimmel | Hay | Shin deriving (Show)
  {- Player type:
      [Char]  name: the player's name
      Integer gelt: how much gelt (coins) they have
      Integer index: their corresponding index in the Game's player list
  -}
  type Player  = ([Char], Integer, Integer)
  {- Game type
      Dreidel dreidel:  the Game's dreidel (spinning top)
      Integer pot:      how much gelt is in the game's pot
      [Player] players: the list of players in the game
  type Game    = (Dreidel, Integer, [Player])

  let INIT_GELT_AMNT = 25
  let MAX_NUM_PLAYERS = 4

  {-
  sideValue :: Dreidel -> (Integer, [Char])
  sideValue Num = (0, "Nun")
  sideValue Gimmel = "
  -}

  {- spin the dreidel, arg is player number in the game
    returns a function that updates a player in some way
  -}
  spin     :: Dreidel -> Integer -> Game -> Game
  -}

  spinResult :: Dreidel -> (Player, Game)

  geltAmnt :: Player -> Integer
  geltAmnt :: (name, gelt) = value gelt

  main :: IO ()
  main
