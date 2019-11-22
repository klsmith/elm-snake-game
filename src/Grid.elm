module Grid exposing (..)

import Playground exposing (Shape, charcoal, group, move, moveX, moveY, rectangle)
import ViewPort exposing (ViewPort)


type alias Grid =
    { rows : Int
    , columns : Int
    }


type alias CellSize =
    Float


type alias Dimensions =
    ( Float, Float )


calculate : Dimensions -> CellSize -> Grid
calculate ( width, height ) cellSize =
    { rows = floor (height / cellSize)
    , columns = floor (width / cellSize)
    }


render : ViewPort -> Grid -> Shape
render viewPort grid =
    let
        columList =
            List.range 0 grid.columns

        rowList =
            List.range 0 grid.rows

        cellWidth =
            viewPort.width / toFloat grid.columns

        cellHeight =
            viewPort.height / toFloat grid.rows
    in
    group
        [ group (List.map (drawHorizonalLine viewPort cellHeight) rowList)
        , group (List.map (drawVeritcalLine viewPort cellWidth) columList)
        ]


drawHorizonalLine : ViewPort -> Float -> Int -> Shape
drawHorizonalLine viewPort cellHeight y =
    rectangle charcoal viewPort.width 1
        |> moveY (viewPort.top - (toFloat y * cellHeight))


drawVeritcalLine : ViewPort -> Float -> Int -> Shape
drawVeritcalLine viewPort cellWidth x =
    rectangle charcoal 1 viewPort.height
        |> moveX (viewPort.left + toFloat x * cellWidth)
