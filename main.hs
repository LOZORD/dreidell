-- Dreidel/Sivivon game written in Haskell
-- By Leo Rudberg (LOZORD) in 2014 (with a lot of guidance from Mike Tolly)

module Main where
  import Dreidel
  import Player
  import System.Exit

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

  remainingPlayers :: Game -> [Player]
  remainingPlayers(game) = do
    let all_players = getPlayerList(game)
    [some_player | some_player <- all_players, getGelt(some_player) > 0]

  main :: IO ()
  -- TODO
  -- first set up the game
  -- then loop
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
