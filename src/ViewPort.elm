module ViewPort exposing (CalculationSettings, RenderSettings, ViewPort, calculate, render)

import Playground exposing (Color, Screen, Shape, circle, group, moveX, moveY, rectangle)


type alias ViewPort =
    { width : Float
    , height : Float
    , left : Float
    , right : Float
    , top : Float
    , bottom : Float
    }


type alias CalculationSettings =
    { aspectRatioX : Float
    , aspectRatioY : Float
    , paddingX : Float
    , paddingY : Float
    }


calculate : CalculationSettings -> Screen -> ViewPort
calculate { aspectRatioX, aspectRatioY, paddingX, paddingY } screen =
    let
        paddedWidth =
            screen.width - paddingX

        paddedHeight =
            screen.height - paddingY

        ratio =
            min (paddedWidth / aspectRatioX) (paddedHeight / aspectRatioY)

        width =
            aspectRatioX * ratio

        height =
            aspectRatioY * ratio

        right =
            width / 2

        top =
            height / 2
    in
    { width = width
    , height = height
    , left = -right
    , right = right
    , top = top
    , bottom = -top
    }


type alias RenderSettings =
    { backgroundColor : Color
    , outlineSize : Float
    , outlineColor : Color
    }


render : RenderSettings -> ViewPort -> Shape
render { backgroundColor, outlineSize, outlineColor } viewPort =
    group
        [ rectangle outlineColor (viewPort.width + outlineSize) (viewPort.height + outlineSize)
        , rectangle backgroundColor viewPort.width viewPort.height
        ]
