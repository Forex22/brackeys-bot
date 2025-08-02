using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/UI }


# Enum to identify our different VFX types.
# You can customize this list with your own effects.
vfx_type := enum:
    FireAura
    IceTrail
    ElectricHands

# The main device to manage the VFX system.
# This device keeps track of which VFX each player has collected
# and ensures they are re-applied after respawning.
vfx_manager := class(creative_device):

    # In the UEFN editor, you must link each enum value above to a
    # corresponding VFX Creator Device in your level.
    @editable
    FireAuraVFX : vfx_creator_device = vfx_creator_device{}
    @editable
    IceTrailVFX : vfx_creator_device = vfx_creator_device{}
    @editable
    ElectricHandsVFX : vfx_creator_device = vfx_creator_device{}

    # A map to store the active VFX for each player.
    # The key is the player, and the value is an array of VFX types they have.
    var PlayerVFX : map(player, []vfx_type) = map{}

    OnBegin<override>()<suspends>:void=
        # Get all players and subscribe to their spawn/death events
        AllPlayers := GetPlayspace().GetPlayers()
        for (Player : AllPlayers):
            Player.EliminatedEvent().Subscribe(OnPlayerEliminated)
            if (FortCharacter := Player.GetFortCharacter[]):
                FortCharacter.SpawnedEvent().Subscribe(OnPlayerSpawn)

        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)

    OnPlayerAdded(Player:player):void=
        Player.EliminatedEvent().Subscribe(OnPlayerEliminated)
        if (FortCharacter := Player.GetFortCharacter[]):
            FortCharacter.SpawnedEvent().Subscribe(OnPlayerSpawn)

    # Called when a player is eliminated
    OnPlayerEliminated(Result:elimination_result):void=
        if:
            EliminatedPlayer := Result.EliminatingCharacter.GetAgent[]
        then:
            # The VFX are automatically removed on death, so we just need to re-apply them on spawn.
            # No action needed here on the map.
            Print("Player {EliminatedPlayer.ToString()} eliminated. Their VFX data is preserved.")

    # Called when a player spawns
    OnPlayerSpawn(SpawnedCharacter:fort_character):void=
        if (Player := SpawnedCharacter.GetAgent[]):
            # Check if this player has any stored VFX
            if (VFXList := PlayerVFX[Player]):
                # Re-apply all the VFX they had before
                Print("Player {Player.ToString()} has spawned. Re-applying {VFXList.Length} VFX.")
                for (VFX : VFXList):
                    ApplyVFX(Player, VFX)

    # A public function to be called when a player picks up a VFX
    GrantVFX(Player:player, VFX:vfx_type):void=
        # Add the VFX to the player's list, avoiding duplicates
        VFXList := if (CurrentVFX := PlayerVFX[Player]) then CurrentVFX else array{}
        if (not VFXList.Contains(VFX)):
            if (set PlayerVFX[Player] = VFXList + array{VFX}):
                Print("Granted {VFX.ToString()} to player {Player.ToString()}")
                # Apply the VFX for the first time
                ApplyVFX(Player, VFX)
        else:
            Print("Player {Player.ToString()} already has {VFX.ToString()}.")


    # Applies the actual visual effect to the player's character.
    # This uses a vfx_creator_device to spawn a new instance of the VFX
    # and attach it to the character.
    ApplyVFX(Player:player, VFX:vfx_type):void=
        if (Character := Player.GetFortCharacter[]):
            VFXCreator := GetVFXCreator(VFX)
            # Create a new instance of the VFX and attach it to the character's root.
            # The VFX object is automatically cleaned up when the character is destroyed.
            if (spawnedVFX := VFXCreator.CreateVFX(Character.GetRootComponent(), vector3.Zero, rotator.Zero)):
                Print("Successfully applied {VFX.ToString()} to {Player.ToString()}")
            else:
                Print("Failed to apply {VFX.ToString()} to {Player.ToString()}", ?Level:=log_level.Error)


    # Helper function to get the correct VFX Creator Device based on the enum value.
    GetVFXCreator(VFX:vfx_type):vfx_creator_device=
        case (VFX):
            vfx_type.FireAura => FireAuraVFX
            vfx_type.IceTrail => IceTrailVFX
            vfx_type.ElectricHands => ElectricHandsVFX
