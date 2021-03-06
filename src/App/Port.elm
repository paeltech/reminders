port module App.Port exposing (..)

import App.Model exposing (..)


-- Incoming ports


port draft : (Maybe Draft -> msg) -> Sub msg


port listRemindersSuccess : (List Reminder -> msg) -> Sub msg


port listRemindersFailed : (String -> msg) -> Sub msg


port createReminderSuccess : (Reminder -> msg) -> Sub msg


port createReminderFailed : (String -> msg) -> Sub msg


port getUserSuccess : (Maybe User -> msg) -> Sub msg


port getUserFailed : (String -> msg) -> Sub msg



-- Outgoing ports


port listReminders : Bool -> Cmd msg


port createReminder : Draft -> Cmd msg


port parseQuery : String -> Cmd msg


port getUser : Bool -> Cmd msg


port signIn : Bool -> Cmd msg


port signOut : Bool -> Cmd msg
