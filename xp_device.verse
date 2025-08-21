using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# A Verse-authored creative device that awards XP to players when they damage a prop.
xp_device := class(creative_device):

    # The prop that players will damage to get XP. This can be set in the UEFN editor.
    @editable
    Prop : creative_prop = creative_prop{}

    # The amount of XP to award per hit.
    XpAmount : int = 25

    # Runs when the device is started.
    OnBegin<override>()<suspends>:void=
        # Subscribe to the DamagedEvent of the prop.
        Prop.DamagedEvent.Subscribe(OnPropDamaged)

    # This function is called when the prop is damaged.
    OnPropDamaged(DamageResult:damage_result):void=
        # Check if the damage was caused by a player.
        if (Agent := DamageResult.Instigator?):
            if (FortCharacter := fort_character[Agent]):
                if(Player := FortCharacter.GetPlayer[]):
                    # Award XP to the player.
                    AwardXp(Player)

    # Awards XP to the given player.
    AwardXp(Player:player):void=
        # In a real UEFN environment, you would use an xp_award_device to grant XP.
        # Since we cannot spawn devices or use the XP API directly here,
        # we will simulate the XP award by printing to the log.
        # In your actual project, you would replace this Print call
        # with a call to your xp_award_device.
        Print("Awarded {XpAmount} XP to player.")
