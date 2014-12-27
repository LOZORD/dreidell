# DREIDELL
## A simple dreidel (sivivon, spinning top, etc.)
## game in Haskell made by Leo Rudberg in 2014
## for [Local Hack Day](localhackday.mlh.io)

The game should follow the regular rules of classic dreidel.

___To run:___
```bash
$ make run
```

# Happy Hanukah!

If `make run` doesn't work, get the Haskell compiler `ghc` and enter in your terminal:
```bash
$ make && make run
```

If you want to change any of the starting (constant) amounts,
feel free to change the source on lines 13-15.

If you want to change the names of players (I'm a noob at Haskell IO, ok?),
feel free to change the source on for the `generateName` function on line 91.

Obviously, you will need `ghc` to make these changes.

Shoutouts to [Mike Tolly](https://github.com/mtolly) and [HH Lambda](https://www.facebook.com/groups/hhlambda/) for their help!
