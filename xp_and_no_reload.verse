using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Fortnite.com/Items }

# A Verse-authored creative device that can be placed in a level
xp_and_no_reload := class(creative_device):

    @editable
    WeaponToGrant : item_spawner_device = item_spawner_device{}

    # Grant XP and the weapon when a player hits this device
    OnHit(Agent: agent) : void=
        if (Player := player[Agent]):
            Print("Granting 10 XP to {Player.Name}")
            AwardXp(Agent, 10)
            WeaponToGrant.SpawnItem(Agent)

    AwardXp(Agent: agent, Amount: int) : void=
        # This is a placeholder for the actual XP awarding logic.
        Print("Awarded {Amount} XP.")

    OnBegin<override>()<suspends>:void=
        AllPlayers := GetPlayspace().GetPlayers()
        for (Player : AllPlayers):
            if (FortCharacter := Player.GetFortCharacter[]):
                FortCharacter.WeaponFiredEvent().Subscribe(OnWeaponFired)

    OnWeaponFired(InPlayer:player, InWeapon:fort_item_definition):void=
        if (WeaponName := InWeapon.GetDisplayName[]):
            if (WeaponName = "Enhanced Surge SMG"):
                if (FortCharacter := InPlayer.GetFortCharacter[]):
                    if (Weapon := FortCharacter.GetCurrentWeapon[]):
                        Weapon.SetMagazineAmmo(Weapon.GetMagazineCapacity())
