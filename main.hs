-- Dreidel/Sivivon game written in Haskell
-- By Leo Rudberg (LOZORD) in 2014 (with a lot of guidance from Mike Tolly)

module Main where
  import Dreidel
  import Player
  import System.Exit

  type Game = (Integer, [Player])

  init_gelt_amnt = 25
  max_num_players = 4

  getPot :: Game -> Integer
  getPot (pot, player_list) = pot

  getPlayerList :: Game -> [Player]
  getPlayerList (pot, player_list) = player_list

  updatePlayerList :: ([Player],Player) -> [Player]
  updatePlayerList(old_list, new_player) = do
    [if (getIndex(some_player) == getIndex(new_player))
        then new_player
        else some_player | some_player <- old_list]

  applyResult :: (Side, Game, Integer) -> IO Game
  applyResult (side, game, player_index)
    | side == Nun = do
      -- do nothing
      print ("Nun! (nothing happens...)")
      return game
    | side == Gimmel = do
      -- this player wins the pot!
      print ("Gimmel! " ++ (getName curr_player) ++ " won the entire pot!")
      let gelt_won = getPot game
      let new_player = ((getName curr_player), (getGelt curr_player) + gelt_won, getIndex curr_player)
      let new_game = (0, updatePlayerList((getPlayerList game), new_player))
      return new_game
    | side == Hay = do
      -- this player takes ceil(pot/2)!
      print ("Hay! " ++ (getName curr_player) ++ " won half the pot!")
      let gelt_won = ceiling(realToFrac(getPot game)/2)
      let new_player = ((getName curr_player), (getGelt curr_player) + gelt_won, getIndex curr_player)
      let new_game = ((getPot game) - gelt_won, updatePlayerList((getPlayerList game), new_player))
      return new_game
    | side == Shin = do
      -- put one gelt in the pot
      print ("Shin! " ++ (getName curr_player) ++ " throws a coin in the pot.")
      let new_player = (getName curr_player, getGelt curr_player - 1, getIndex curr_player)
      let new_game = (getPot game + 1, updatePlayerList((getPlayerList game), new_player))
      return new_game
    | otherwise = do
      print ("That's a weird dreidel!")
      return game
    where curr_player = (getPlayerList(game) !! fromIntegral(player_index))

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

  remainingPlayers :: Game -> [Player]
  remainingPlayers(game) = do
    let all_players = getPlayerList(game)
    [some_player | some_player <- all_players, getGelt(some_player) > 0]

  main :: IO ()
  -- TODO
  -- first set up the game
  -- then loop
  main = undefined --TODO

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
        game_update <- applyResult(side, game, index)
        let new_player_list = getPlayerList game_update
        let player_update = getPlayer(game_update,index)
        if getGelt player_update <= 0
          then print ("Sorry, you're out " ++ (getName player_update))
          else return ( )
        -- check if a player has won
        if (length(remainingPlayers(game_update))) == 1
          then do
            let winner = head(remainingPlayers(game_update))
            print "We have a winner!"
            printPlayers([winner])
            print ("Congrats " ++ (getName(winner)))
            print "Thanks for playing. Now go eat a latke!"
            exit <- exitSuccess :: IO a
            return exit
          else do
            print "*** POT CONTAINS ***"
            print (getPot game_update)
            printPlayers (new_player_list)
            loop (game_update, ((index + 1) `mod` (numPlayers game)))
-- end main
