module Main exposing (..)

import Browser exposing (element)
import Grid exposing (Grid)
import Html exposing (Html, text)
import Playground exposing (..)
import ViewPort exposing (ViewPort)



-- MAIN


main =
    Playground.game render update init


type alias Memory =
    { grid : Grid
    }


init : Memory
init =
    { grid = Grid.calculate ( 640, 480 ) 16
    }


update : Computer -> Memory -> Memory
update computer memory =
    memory


render : Computer -> Memory -> List Shape
render { screen } memory =
    let
        viewPort =
            ViewPort.calculate viewPortCalculationSettings screen
    in
    [ rectangle black screen.width screen.height
    , ViewPort.render viewPortRenderSettings viewPort
    , Grid.render viewPort memory.grid
    ]


viewPortCalculationSettings : ViewPort.CalculationSettings
viewPortCalculationSettings =
    { aspectRatioX = aspectRatio.ratioX
    , aspectRatioY = aspectRatio.ratioY
    , paddingX = 64
    , paddingY = 64
    }


viewPortRenderSettings : ViewPort.RenderSettings
viewPortRenderSettings =
    { backgroundColor = black
    , outlineSize = 1
    , outlineColor = white
    }


aspectRatio : AspectRatio
aspectRatio =
    { ratioX = 640
    , ratioY = 480
    }


type alias AspectRatio =
    { ratioX : Number, ratioY : Number }
