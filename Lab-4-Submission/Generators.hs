module Generators where

import DataTypes
import Test.QuickCheck
import Data.List
import System.Random

-- Generates a field cell
cell :: Gen (Maybe Bool)
cell = frequency
         [(7, return Nothing),
          (3, return (Just True))]

-- An instance for generating Arbitrary Field
instance Arbitrary Field where
  arbitrary =
    do rows <- sequence [ sequence [ cell | j <- [0..9] ] | i <- [0..9] ]
       return (Field rows)

-- Generates random model
rModel :: Gen Model
rModel = frequency
      [(1, return AircraftCarrier),
       (1, return Battleship),
       (1, return Submarine),
       (1, return Destroyer),
       (2, return PatrolBoat)]

instance Arbitrary Model where
  arbitrary = rModel

-- Generates random alignment
rAlignment :: Gen Alignment
rAlignment = elements [Vertical, Horizontal]

instance Arbitrary Alignment where
  arbitrary = rAlignment

-- Generates random field coordinates
rCoord :: Gen (Int, Int)
rCoord = do
  x <- choose (0,9)
  y <- choose (0,9)
  return (x,y)

-- Generates a random boat
rBoat :: Gen Boat
rBoat = do
  m <- rModel
  c <- rCoord
  a <- rAlignment
  return (Boat m c a)

instance Arbitrary Boat where
	arbitrary = rBoat

-- Generates a fleet
rFleet :: Gen Fleet
rFleet = do
  b1 <- rBoat
  b2 <- rBoat
  b3 <- rBoat
  b4 <- rBoat
  b5 <- rBoat
  b6 <- rBoat
  return (Fleet [b1,b2,b3,b4,b5,b6])

instance Arbitrary Fleet where
	arbitrary = rFleet

instance Arbitrary StdGen where
  arbitrary = do n <- arbitrary
                 return (mkStdGen n)