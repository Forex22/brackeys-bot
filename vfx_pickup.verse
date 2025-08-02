using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }

vfx_pickup := class(creative_device):

    @editable
    VFXManager : vfx_manager = vfx_manager{}

    @editable
    Trigger : trigger_device = trigger_device{}

    @editable
    VFX_To_Grant : vfx_type = vfx_type.FireAura

    @editable
    RespawnTime : float = 5.0

    OnBegin<override>()<suspends>:void=
        Trigger.TriggeredEvent.Subscribe(OnPickupTriggered)

    OnPickupTriggered(MaybePlayer:?agent):void=
        if (Player := MaybePlayer?):
            # Grant the VFX to the player
            VFXManager.GrantVFX(Player, VFX_To_Grant)

            # Disable the trigger temporarily
            Trigger.Disable()
            Print("VFX Pickup for {VFX_To_Grant.ToString()} triggered by {Player.ToString()}. Disabling for {RespawnTime} seconds.")
            Sleep(RespawnTime)
            Trigger.Enable()
            Print("VFX Pickup for {VFX_To_Grant.ToString()} re-enabled.")
