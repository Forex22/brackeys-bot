using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# A Verse-authored creative device that awards XP to players when they damage non-player objects.
xp_device := class(creative_device):

    # The amount of XP to award the player.
    XpToAward : int = 25

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # Get all damageable objects in the world
        AllDamageableObjects := GetCreativeObjectsWithTag(damageable_object_tag{})
        for (DamageableObject : AllDamageableObjects):
            # Subscribe to the DamagedEvent for each damageable object
            DamageableObject.DamagedEvent().Subscribe(OnDamaged)

    # Event handler for when a damageable object is damaged
    OnDamaged(DamageResult : damage_result):void=
        # Get the instigator of the damage
        if (DamageInstigator := DamageResult.Instigator?):
            # Check if the instigator is a player
            if (Agent := agent[DamageInstigator]):
                # Check if the damaged object is not a player
                if (fort_character[DamageResult.Target] = false):
                    # Award the XP to the player
                    AwardXp(Agent)

    # Awards XP to the given agent
    AwardXp(Agent:agent):void=
        # This is a placeholder for the actual XP award logic.
        # You would typically use a real XP awarding device or system here.
        Print("Awarded {XpToAward} XP to player.")
