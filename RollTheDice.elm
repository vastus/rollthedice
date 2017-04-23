module RollTheDice exposing (Model, Msg, init, update, view, subscriptions)

import Html exposing (button, div, h1, text)
import Html.Attributes
import Html.Events exposing (onClick)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)


-- MODEL


type alias Model =
    { dieCount : Int
    , dieFaces : List Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 5 [ 1, 2, 3, 4, 5 ], Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFaces (List Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFaces (Random.list model.dieCount (Random.int 1 6)) )

        NewFaces dieFaces ->
            ( { model | dieFaces = dieFaces }, Cmd.none )



-- VIEW


pipView : ( Int, Int ) -> Html.Html Msg
pipView ( x, y ) =
    Svg.circle
        [ cx (toString x)
        , cy (toString y)
        , r (toString 8)
        , fill "#2e2e2e"
        , stroke "#3e3e3e"
        , strokeWidth "2"
        ]
        []


viewDieFace : Int -> Int -> Html.Html Msg
viewDieFace a dieFace =
    let
        position : Int -> Int -> Int -> ( Int, Int )
        position a col row =
            ( a * (col + 1) // 4, a * (row + 1) // 4 )

        pos : Int -> Int -> ( Int, Int )
        pos =
            position a

        pipPositions : Int -> List ( Int, Int )
        pipPositions dieFace =
            case dieFace of
                1 ->
                    [ pos 1 1 ]

                2 ->
                    [ pos 0 2
                    , pos 2 0
                    ]

                3 ->
                    [ pos 0 2
                    , pos 1 1
                    , pos 2 0
                    ]

                4 ->
                    [ pos 0 0
                    , pos 0 2
                    , pos 2 0
                    , pos 2 2
                    ]

                5 ->
                    [ pos 0 0
                    , pos 2 0
                    , pos 1 1
                    , pos 0 2
                    , pos 2 2
                    ]

                _ ->
                    [ pos 0 0
                    , pos 0 1
                    , pos 0 2
                    , pos 2 0
                    , pos 2 1
                    , pos 2 2
                    ]
    in
        Svg.g [] (List.map pipView (pipPositions dieFace))


viewDie : Int -> Int -> Html.Html Msg
viewDie a dieFace =
    Svg.svg
        [ width "100"
        , height "100"
        , viewBox "0 0 100 100"
        , onClick Roll
        ]
        [ rect
            [ x "0"
            , y "0"
            , width (toString a)
            , height (toString a)
            , rx "15"
            , ry "15"
            , fill "#fea"
            ]
            []
        , viewDieFace a dieFace
        ]


view : Model -> Html.Html Msg
view model =
    div
        [ Html.Attributes.style
            [ ( "width", "20rem" )
            , ( "margin", "2rem auto" )
            , ( "font-family", "sans-serif" )
            ]
        ]
        [ h1
            [ Html.Attributes.style [ ( "user-select", "none" ) ] ]
            [ Html.text "Roll the dice" ]
        , div [] (List.map (viewDie 80) model.dieFaces)
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
