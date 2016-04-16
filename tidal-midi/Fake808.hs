module Sound.Tidal.Fake808 where

import Sound.Tidal.Stream (makeI, makeF)

import Sound.Tidal.MIDI.Control
import Control.Applicative

fake808 :: ControllerShape
fake808 = ControllerShape { params = [ ],
                         duration = ("dur", 0.05),
                         velocity = ("vel", 0.5),
                         latency = 0.1
                       }

osc808 = toOscShape fake808

drum8 = (makeI osc808 "note") . (noteN <$>)

noteN :: String -> Int
noteN "bd"  = 36
noteN "bd1" = 27
noteN "bd2" = 35
noteN "rm"  = 37
noteN "sn"  = 38
noteN "lt"  = 43
noteN "ht"  = 50
noteN "ch"  = 42
noteN "oh"  = 46
noteN "cp"  = 39
noteN "cl"  = 75
noteN "ag"  = 67
noteN "cr"  = 49
noteN "cr1" = 51
noteN "cr2" = 52
noteN "ri"  = 53
noteN _ = 0
