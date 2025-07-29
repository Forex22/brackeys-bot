using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Playspaces }

log_auto_reload := class(log_channel){}

auto_reload_device := class(creative_device):

    @editable
    EliminationManager : elimination_manager_device = elimination_manager_device{}

    OnBegin<override>()<suspends>:void=
        EliminationManager.EliminatedEvent.Subscribe(HandlePlayerEliminated)

    HandlePlayerEliminated(Result:elimination_result):void=
        Print("Player eliminated")
        if (EliminatingCharacter := Result.EliminatingCharacter?):
            if (EliminatingPlayer := EliminatingCharacter.GetFortCharacter[].GetPlayer[]):
                Print("Eliminating player: {EliminatingPlayer.GetName[]}")
                if (FortCharacter := EliminatingPlayer.GetFortCharacter[]):
                    for (Weapon in FortCharacter.GetWeapons[]):
                        Print("Reloading weapon")
                        Weapon.Reload()
