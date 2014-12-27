-- Dreidel/Sivivon game written in Haskell
-- By Leo Rudberg (LOZORD) in 2014 (with a lot of guidance from Mike Tolly)

module Main where
  import Dreidel
  import Player
  import System.Exit
  import Data.Char (isSpace)

  type Game = (Integer, [Player])

  init_gelt_amnt = 25
  max_num_players = 4

  getPot :: Game -> Integer
  getPot (pot, player_list) = pot

  getPlayerList :: Game -> [Player]
  getPlayerList (pot, player_list) = player_list

  trim :: String -> String
  trim = f . f
    where f = reverse . dropWhile isSpace

  updatePlayerList :: ([Player],Player) -> [Player]
  updatePlayerList(old_list, new_player) = do
    [if (getIndex(some_player) == getIndex(new_player))
        then new_player
        else some_player | some_player <- old_list]

  applyResult :: (Side, Game, Integer) -> IO Game
  applyResult (side, game, player_index)
    | side == Nun = do
      -- do nothing
      putStrLn ("Nun! (nothing happens...)")
      return game
    | side == Gimmel = do
      -- this player wins the pot!
      putStrLn ("Gimmel! " ++ (getName curr_player) ++ " won the entire pot!")
      let gelt_won = getPot game
      let new_player = ((getName curr_player), (getGelt curr_player) + gelt_won, getIndex curr_player)
      let new_game = (0, updatePlayerList((getPlayerList game), new_player))
      return new_game
    | side == Hay = do
      -- this player takes ceil(pot/2)!
      putStrLn ("Hay! " ++ (getName curr_player) ++ " won half the pot!")
      let gelt_won = ceiling(realToFrac(getPot game)/2)
      let new_player = ((getName curr_player), (getGelt curr_player) + gelt_won, getIndex curr_player)
      let new_game = ((getPot game) - gelt_won, updatePlayerList((getPlayerList game), new_player))
      return new_game
    | side == Shin = do
      -- put one gelt in the pot
      putStrLn ("Shin! " ++ (getName curr_player) ++ " throws a coin in the pot.")
      let new_player = (getName curr_player, getGelt curr_player - 1, getIndex curr_player)
      let new_game = (getPot game + 1, updatePlayerList((getPlayerList game), new_player))
      return new_game
    | otherwise = do
      putStrLn ("That's a weird dreidel!")
      return game
    where curr_player = (getPlayerList(game) !! fromIntegral(player_index))

  numPlayers :: Game -> Integer
  numPlayers game = toInteger (length (getPlayerList game))

  getPlayer :: (Game, Integer) -> Player
  getPlayer (game, index) = ((getPlayerList(game)) !! fromIntegral (index))

  printPlayers :: [Player] -> IO ()
  printPlayers [] = return ( )
  printPlayers (some_player : tail) = do
    putStrLn ("-> " ++ getName some_player)
    putStrLn ("\thas " ++ (show (getGelt some_player)) ++ "gelt")
    printPlayers tail

  isInGame :: Player -> Bool
  isInGame player = getGelt(player) > 0

  remainingPlayers :: Game -> [Player]
  remainingPlayers game = filter isInGame currentPlayers
    where currentPlayers = getPlayerList game

  askName :: IO String
  askName = do
    putStrLn "Please enter your name"
    putStrLn "Or if no other players, enter 'x'"
    getLine

  generateName :: Integer -> String
  generateName i
    | i == 0 = "Alice"
    | i == 1 = "Bob"
    | i == 2 = "Carol"
    | i == 3 = "DreidelBot"
    | i == 4 = "Ernesto"


  --FIXME
  buildPlayers :: [Player] -> [Player]
  buildPlayers list = do
    let curr_length = length(list)
    if (curr_length < max_num_players)
      then do
        --name <- askName
        let name = generateName $ fromIntegral curr_length
        if length name == 1 && head name == 'x'
          then list
          else if (null name) -- the empty string
            then buildPlayers list
            else buildPlayers(list++[(name, init_gelt_amnt, fromIntegral curr_length)])
      else list
  --buildPlayers list = undefined

  placeAntes :: Game -> Game
  placeAntes game = undefined

  main :: IO ()
  -- first set up the game
  -- then loop
  main = do
    putStrLn "Welcome to Dreidell, the forefront technology in Hanukkah games."
    putStrLn "Everytime a new round begins, each player puts in 1 gelt."
    putStrLn "Otherwise, the rules should be the same as classic dreidel."
    let the_players = buildPlayers([])
    let the_game = (init_gelt_amnt, the_players)
    loop(the_game, 0)

  loop :: (Game, Integer) -> IO ()
  loop (game, index) = do
    -- if it's a new round, players who are still in put 1 gold in the pot
    let isAnteRound = (index `mod` (fromIntegral (length $ getPlayerList game))) == 0
    --if isAnteRound then do putStrLn "*\tNEW ROUND\t*" else do putStrLn "(not a new round)"
    let game' = if isAnteRound then (placeAntes game) else game
    let curr_player = getPlayerList game' !! fromIntegral (index)
    -- determine if we want to skip this player
    if (getGelt curr_player) <= 0
      then do
        -- go onto the next player
        let next_player_index = (index + 1) `mod` (numPlayers(game))
        loop (game', next_player_index)
      else do
        putStrLn ((getName(curr_player)) ++ ", press enter to spin the virtual dreidel!")
        s <- getLine
        side <- Dreidel.spin
        game_update <- applyResult(side, game', index)
        let new_player_list = getPlayerList game_update
        let player_update = getPlayer(game_update,index)
        if getGelt player_update <= 0
          then putStrLn ("Sorry, you're out " ++ (getName player_update))
          else return ( )
        -- check if a player has won
        if (length(remainingPlayers(game_update))) == 1
          then do
            let winner = head(remainingPlayers(game_update))
            putStrLn "We have a winner!"
            printPlayers([winner])
            putStrLn ("Congrats " ++ (getName(winner)))
            putStrLn "Thanks for playing. Now go eat a latke!"
            exit <- exitSuccess :: IO a
            return exit
          else do
            putStrLn "*** POT CONTAINS ***"
            print (getPot game_update)
            printPlayers (new_player_list)
            loop (game_update, ((index + 1) `mod` (numPlayers game_update)))
-- end main
