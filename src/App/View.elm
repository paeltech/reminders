module App.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import App.Model exposing (..)
import App.Update exposing (Msg(..))

view : Model -> Html Msg
view model =
  div []
    [ renderNav model
    , renderContent model
    ]


renderNav model =
  let
    authLink =
      case model.user of
        Received (Just user) ->
          a [ class "nav-item is-tab", onClick SignOut ] [ text <| "Sign out (" ++ user.email ++ ")" ]
        Received Nothing ->
          a [ class "nav-item is-tab", onClick SignIn ] [ text "Sign in" ]
        _ ->
          span [] []
  in
    nav [ class "nav has-shadow" ]
        [ div [ class "container" ]
            [ div [ class "nav-left" ]
                [ a [ class "nav-item", href "/" ]
                    [ text "Reminders" ]
                ]
            , span [ class "nav-toggle" ]
                [ span [] []
                , span [] []
                , span [] []
                ]
            , div [ class "nav-right nav-menu" ]
                [ authLink
                ]
            ]
        ]


renderContent model =
  let
    content =
      case model.user of
        NotAsked ->
          [ p [ class "has-text-centered" ] [ text "Initializing..." ] ]
        Loading ->
          [ p [ class "has-text-centered" ] [ text "Loading..." ] ]
        RequestFailed msg ->
          [ p [ class "has-text-centered" ] [ text msg ] ]
        Received (Just user) ->
          authUserContent model user
        Received Nothing ->
          anonUserContent
  in
    div [ class "columns" ]
      [ div [ class "column is-half is-offset-one-quarter" ] content
      ]



anonUserContent =
  [ div [ class "content is-medium" ]
     [ h1 [] [ text "Welcome to Reminders!" ]
     , p [] [ text "After signing in with your google account you will be able to easily create reminders in you google calendar by entering text into a text field. The title and time is extracted from the text using a natural language date parser. You will also see a list of all upcoming reminders." ]
     ]
  ]

authUserContent model user =
  [ Html.form []
      [ div [ class "field" ]
          [ label [ class "label" ]
              [ text "Query" ]
          , p [ class "control" ]
              [ input [ attribute "autofocus" "", class "input", placeholder "Buy milk in 2 hours", attribute "required" "", type_ "text", onInput SetQuery, value model.query]
                  []
              ]
          , p [ class "control" ]
              [ button [ class "button is-primary" ]
                  [ text "Create reminder" ]
              ]
          , p [ id "reminder-datetime" ] []
          , p [ id "reminder-relative-time" ] []
          , div [ id "reminders" ]
              [ table [ class "table" ]
                  [ thead []
                      [ tr []
                          [ th []
                              [ text "Title" ]
                          , th []
                              [ text "When" ]
                          ]
                      ]
                  , tbody []
                      [ tr []
                          [ td []
                              [ a [ href "https://www.google.com/calendar/event?eid=c3B2YjQybHRqOWRkY3NuNDNlOTU1aGV0NGsgcGV0dGVyLnJhc211c3NlbkBt" ]
                                  [ text "buy milk" ]
                              ]
                          , td []
                              [ text "in an hour" ]
                          ]
                      ]
                  ]
              ]
          ]
      ]
  ]
