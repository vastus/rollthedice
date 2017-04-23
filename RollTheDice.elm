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


viewDieDots : Int -> Int -> Int -> Html.Html Msg
viewDieDots w h dieFace =
    let
        dot : ( Int, Int ) -> Html.Html Msg
        dot ( x, y ) =
            Svg.circle
                [ cx (toString x)
                , cy (toString y)
                , r (toString 8)
                , fill "#2e2e2e"
                , stroke "#3e3e3e"
                , strokeWidth "2"
                ]
                []

        ratio : Int -> Int
        ratio a =
            a * 1 // 3

        dotPositions : Int -> List ( Int, Int )
        dotPositions dieFace =
            case dieFace of
                1 ->
                    [ ( w // 2, h // 2 ) ]

                2 ->
                    [ ( w * 1 // 4, h * 3 // 4 )
                    , ( w * 3 // 4, h * 1 // 4 )
                    ]

                3 ->
                    [ ( w * 1 // 4, h * 3 // 4 )
                    , ( w * 3 // 4, h * 1 // 4 )
                    , ( w // 2, h // 2 )
                    ]

                4 ->
                    [ ( w * 1 // 4, h * 3 // 4 )
                    , ( w * 3 // 4, h * 1 // 4 )
                    , ( w * 1 // 4, h * 1 // 4 )
                    , ( w * 3 // 4, h * 3 // 4 )
                    ]

                5 ->
                    [ ( w * 1 // 4, h * 3 // 4 )
                    , ( w * 3 // 4, h * 1 // 4 )
                    , ( w * 1 // 4, h * 1 // 4 )
                    , ( w * 3 // 4, h * 3 // 4 )
                    , ( w // 2, h // 2 )
                    ]

                _ ->
                    [ ( w * 1 // 4, h * 1 // 4 )
                    , ( w * 1 // 4, h * 2 // 4 )
                    , ( w * 1 // 4, h * 3 // 4 )
                    , ( w * 3 // 4, h * 1 // 4 )
                    , ( w * 3 // 4, h * 2 // 4 )
                    , ( w * 3 // 4, h * 3 // 4 )
                    ]
    in
        Svg.g [] (List.map dot (dotPositions dieFace))


viewDie : Int -> Int -> Int -> Html.Html Msg
viewDie w h dieFace =
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
            , width (toString w)
            , height (toString h)
            , rx "15"
            , ry "15"
            , fill "#fea"
            ]
            []
        , viewDieDots w h dieFace
        ]


view : Model -> Html.Html Msg
view model =
    let
        die =
            viewDie 80 80
    in
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
            , div [] (List.map die model.dieFaces)
            ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
