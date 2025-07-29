using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }

# A Verse-authored creative device that can be placed in a level
no_reload_gun := class(creative_device):

    @editable
    WeaponToModify : creative_device_asset = DefaultCreativeDeviceAsset

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
