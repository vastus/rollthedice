module Main exposing (..)

import Html
import RollTheDice exposing (Model, Msg, init, update, view, subscriptions)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
