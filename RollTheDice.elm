module RollTheDice exposing (Model, Msg, init, update, view, subscriptions)

import Html exposing (button, div, h1, text)
import Html.Attributes
import Html.Events exposing (onClick)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)


-- MODEL


type alias Model =
    { dieFaces : List Int }


init : ( Model, Cmd Msg )
init =
    ( Model [ 6, 4 ], Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFaces (List Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFaces (Random.list 2 (Random.int 1 6)) )

        NewFaces dieFaces ->
            ( { model | dieFaces = dieFaces }, Cmd.none )



-- VIEW


viewDieFace : Int -> Int -> Html.Html Msg
viewDieFace a dieFace =
    let
        pip : ( Int, Int ) -> Html.Html Msg
        pip ( x, y ) =
            Svg.circle
                [ cx (toString x)
                , cy (toString y)
                , r (toString 8)
                , fill "#2e2e2e"
                , stroke "#3e3e3e"
                , strokeWidth "2"
                ]
                []

        pipPositions : Int -> List ( Int, Int )
        pipPositions dieFace =
            case dieFace of
                1 ->
                    [ ( a // 2, a // 2 ) ]

                2 ->
                    [ ( a * 1 // 4, a * 3 // 4 )
                    , ( a * 3 // 4, a * 1 // 4 )
                    ]

                3 ->
                    [ ( a * 1 // 4, a * 3 // 4 )
                    , ( a * 3 // 4, a * 1 // 4 )
                    , ( a // 2, a // 2 )
                    ]

                4 ->
                    [ ( a * 1 // 4, a * 3 // 4 )
                    , ( a * 3 // 4, a * 1 // 4 )
                    , ( a * 1 // 4, a * 1 // 4 )
                    , ( a * 3 // 4, a * 3 // 4 )
                    ]

                5 ->
                    [ ( a * 1 // 4, a * 3 // 4 )
                    , ( a * 3 // 4, a * 1 // 4 )
                    , ( a * 1 // 4, a * 1 // 4 )
                    , ( a * 3 // 4, a * 3 // 4 )
                    , ( a // 2, a // 2 )
                    ]

                _ ->
                    [ ( a * 1 // 4, a * 1 // 4 )
                    , ( a * 1 // 4, a * 2 // 4 )
                    , ( a * 1 // 4, a * 3 // 4 )
                    , ( a * 3 // 4, a * 1 // 4 )
                    , ( a * 3 // 4, a * 2 // 4 )
                    , ( a * 3 // 4, a * 3 // 4 )
                    ]
    in
        Svg.g [] (List.map dot (pipPositions dieFace))


viewDie : Int -> Int -> Html.Html Msg
viewDie a dieFace =
    Svg.svg
        [ width "100"
        , height "100"
        , viewBox "0 0 100 100"
        , Html.Attributes.style [ ( "display", "block" ) ]
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
            [ ( "width", "30rem" )
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
