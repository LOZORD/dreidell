-- Dreidel/Sivivon game written in Haskell
-- By Leo Rudberg (LOZORD) in 2014 (with a lot of guidance from Mike Tolly)

module Main where
  import Dreidel
  import Player
  type Game    = (Integer, [Player])

  init_gelt_amnt = 25
  max_num_players = 4

  getPot :: Game -> Integer
  getPot (pot, player_list) = pot

  getPlayerList :: Game -> [Player]
  getPlayerList (pot, player_list) = player_list

  applyResult :: (Side, Game, Integer) -> Game
  applyResult = undefined

  numPlayers :: Game -> Integer
  numPlayers game = toInteger (length (getPlayerList game))

  getPlayer :: (Game, Integer) -> Player
  getPlayer (game, index) = ((getPlayerList(game)) !! fromIntegral (index))

  printPlayers :: [Player] -> IO ()
  printPlayers [] = return ( )
  printPlayers (head : tail) = do
    let some_player = head
    print ("-> " ++ getName some_player)
    print ("\thas " ++ (show (getGelt some_player)) ++ "gelt")
    printPlayers tail

  main :: IO ()
  -- TODO
  main = undefined

  loop :: (Game, Integer) -> IO ()
  loop (game, index) = do
    let curr_player = getPlayerList game !! fromIntegral (index)
    -- determine if we want to skip this player
    if (getGelt curr_player) <= 0
      then do
        -- go onto the next player
        let next_player_index = (index + 1) `mod` (numPlayers(game))
        loop (game, next_player_index)
      else do
        side <- Dreidel.spin
        let game_update = applyResult(side, game, index)
        let player_update = getPlayer(game_update,index)
        if getGelt player_update <= 0
          then print ("Sorry, you're out " ++ (getName player_update))
          else return ( )
        -- check if a player has won

        -- end check if player wins
        print "*** POT CONTAINS"
        print (getPot game_update)
        printPlayers (getPlayerList game_update)
        loop (game_update, ((index + 1) `mod` (numPlayers game)))
