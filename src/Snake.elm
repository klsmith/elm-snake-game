module Snake exposing (Data, Direction(..), Snake, changeDirection, create, grow, toDataList, updateLocation)


type Snake
    = Snake BodyPart


type BodyPart
    = Body BodyPart Data
    | Tail Data


type alias Data =
    { x : Int
    , y : Int
    , dir : Direction
    }


type Direction
    = Up
    | Down
    | Left
    | Right


create : Data -> Snake
create data =
    Snake (Tail data)


grow : Snake -> Snake
grow (Snake head) =
    let
        headData =
            case head of
                Body subPart data ->
                    data

                Tail data ->
                    data
    in
    Snake (Body head (updateLocationData headData))


toDataList : Snake -> List Data
toDataList (Snake head) =
    dataListFromPart head


dataListFromPart : BodyPart -> List Data
dataListFromPart part =
    case part of
        Body subPart data ->
            data :: dataListFromPart subPart

        Tail data ->
            [ data ]


updateLocation : Snake -> Snake
updateLocation (Snake head) =
    Snake (updatePartLocation head)


updatePartLocation : BodyPart -> BodyPart
updatePartLocation part =
    case part of
        Body subPart data ->
            let
                movedSubPart =
                    updatePartLocation subPart

                redirectedSubPart =
                    changePartDirection data.dir movedSubPart

                movedData =
                    updateLocationData data
            in
            Body redirectedSubPart movedData

        Tail data ->
            Tail (updateLocationData data)


updateLocationData : Data -> Data
updateLocationData data =
    case data.dir of
        Up ->
            { data | y = data.y + 1 }

        Down ->
            { data | y = data.y - 1 }

        Left ->
            { data | x = data.x - 1 }

        Right ->
            { data | x = data.x + 1 }


changeDirection : Direction -> Snake -> Snake
changeDirection newDir (Snake head) =
    Snake (changePartDirection newDir head)


changePartDirection : Direction -> BodyPart -> BodyPart
changePartDirection newDir part =
    case part of
        Body subPart data ->
            Body subPart { data | dir = newDir }

        Tail data ->
            Tail { data | dir = newDir }
