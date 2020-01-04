module Main exposing (..)

import Browser exposing (element)
import Html exposing (Html, text)
import Playground exposing (..)
import Set
import Snake exposing (Snake)
import ViewPort exposing (ViewPort)



-- MAIN


main =
    Playground.game render update init


type alias Memory =
    { ticks : Int
    , snake : Snake
    }


init : Memory
init =
    { ticks = 0
    , snake =
        Snake.create
            { x = 0
            , y = 0
            , dir = Snake.Right
            }
            |> Snake.grow
            |> Snake.grow
            |> Snake.grow
    }


update : Computer -> Memory -> Memory
update computer ({ ticks, snake } as memory) =
    { memory
        | ticks = ticks + 1
        , snake = redirectSnake computer.keyboard (updateSnake ticks snake)
    }


redirectSnake : Keyboard -> Snake -> Snake
redirectSnake { keys } snake =
    if Set.member "w" keys then
        Snake.changeDirection Snake.Up snake

    else if Set.member "s" keys then
        Snake.changeDirection Snake.Down snake

    else if Set.member "a" keys then
        Snake.changeDirection Snake.Left snake

    else if Set.member "d" keys then
        Snake.changeDirection Snake.Right snake

    else
        snake


updateSnake : Int -> Snake -> Snake
updateSnake ticks snake =
    if modBy 8 ticks == 0 then
        Snake.updateLocation snake

    else
        snake


render : Computer -> Memory -> List Shape
render { screen } memory =
    let
        viewPort =
            ViewPort.calculate viewPortCalculationSettings screen
    in
    [ rectangle black screen.width screen.height
    , ViewPort.render viewPortRenderSettings viewPort
    , renderSnake viewPort memory.snake
    ]


renderSnake : ViewPort -> Snake -> Shape
renderSnake viewPort snake =
    group (List.map (renderSnakeData viewPort) (Snake.toDataList snake))


renderSnakeData : ViewPort -> Snake.Data -> Shape
renderSnakeData viewPort snakeData =
    let
        width =
            viewPort.width / gamePort.width

        height =
            viewPort.height / gamePort.height
    in
    group
        [ rectangle black width height
        , rectangle white (width - 1) (height - 1)
        ]
        |> move ((width * toFloat snakeData.x) - (width / 2)) ((height * toFloat snakeData.y) + (height / 2))


gamePort =
    { width = 40
    , height = 30
    }


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
