using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

double_pump_manager := class(creative_device):

    @editable
    InputTriggerDevice : input_trigger_device = input_trigger_device{}

    @editable
    ItemRemoverDevice : item_remover_device = item_remover_device{}

    @editable
    ItemGranterDevice : item_granter_device = item_granter_device{}

    @editable
    ConditionalButtonDevice : conditional_button_device = conditional_button_device{}

    OnBegin<override>()<suspends>:void=
        InputTriggerDevice.PressedEvent.Subscribe(OnPlayerShoot)

    OnPlayerShoot(Agent:agent):void=
        if (ConditionalButtonDevice.IsHoldingItem[Agent]):
            ItemRemoverDevice.Remove(Agent)
            ItemGranterDevice.GrantItem(Agent)
