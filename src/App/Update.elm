module App.Update exposing (..)

import App.Model exposing (..)
import App.Port as Port
import RemoteData exposing (RemoteData(..))
import Time exposing (Time)


type Msg
    = SetQuery String
    | SignIn
    | SignOut
    | GetUserSuccess (Maybe User)
    | GetUserFailed String
    | ListRemindersSuccess (List Reminder)
    | ListRemindersFailed String
    | SetDraft (Maybe Draft)
    | ToggleRelativeDate
    | ToggleRightMenuOnMobile
    | CreateReminder
    | CreateReminderSuccess Reminder
    | CreateReminderFailed String
    | ResetCreateReminderError
    | PeriodicTasks Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetQuery query ->
            { model | query = query } ! [ Port.parseQuery query ]

        SignIn ->
            { model | showRightMenuOnMobile = False } ! [ Port.signIn True ]

        SignOut ->
            { model | showRightMenuOnMobile = False } ! [ Port.signOut True ]

        GetUserSuccess user ->
            case user of
                Just _ ->
                    { model | user = Success user, reminders = Loading } ! [ Port.listReminders True ]

                Nothing ->
                    { model | user = Success user } ! []

        GetUserFailed error ->
            { model | user = Failure error } ! []

        ListRemindersSuccess reminders ->
            { model | reminders = Success reminders } ! []

        ListRemindersFailed error ->
            { model | reminders = Failure error } ! []

        SetDraft draft ->
            { model | draft = draft, createReminderError = Nothing } ! []

        ToggleRelativeDate ->
            { model | showRelativeDate = not model.showRelativeDate } ! []

        ToggleRightMenuOnMobile ->
            { model | showRightMenuOnMobile = not model.showRightMenuOnMobile } ! []

        CreateReminder ->
            case Maybe.map validateDraft model.draft of
                Just (Ok draft) ->
                    model ! [ Port.createReminder draft ]

                _ ->
                    model ! []

        CreateReminderSuccess reminder ->
            let
                newReminders =
                    case model.reminders of
                        Success reminders ->
                            Success (reminders ++ [ reminder ])
                                |> RemoteData.map (List.sortBy .startDate)

                        _ ->
                            Success [ reminder ]
            in
            { model | query = "", draft = Nothing, reminders = newReminders } ! []

        CreateReminderFailed error ->
            { model | createReminderError = Just error } ! []

        ResetCreateReminderError ->
            { model | createReminderError = Nothing } ! []

        PeriodicTasks time ->
            case model.user of
                Success (Just user) ->
                    model ! [ Port.listReminders True, Port.parseQuery model.query ]

                _ ->
                    model ! []
