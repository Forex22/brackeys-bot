# Double Pump Script Setup Instructions

This guide will walk you through setting up the double pump script in your UEFN project.

## 1. Add the Verse Script to Your Project

1.  In the UEFN editor, open the Content Browser.
2.  Right-click and select "Verse" -> "Verse File".
3.  Name the new file `double_pump_manager.verse`.
4.  Open the newly created file and paste the following code into it:

```verse
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
```

5.  Save the file and compile the Verse code by clicking "Verse" -> "Build Verse Code" in the main menu.

## 2. Place and Configure the Devices

You will need to place the following devices in your scene:

*   **Input Trigger Device**
*   **Item Remover Device**
*   **Item Granter Device**
*   **Conditional Button Device**
*   **Double Pump Manager Device** (this is your Verse device)

1.  **Input Trigger Device:**
    *   Drag an `input_trigger_device` from the Content Browser into your scene.
    *   In the Details panel, set the **Input** to **Primary Fire**. This will make the device trigger when the player shoots.

2.  **Item Remover Device:**
    *   Drag an `item_remover_device` into your scene.
    *   In the Details panel, under **User Options**, set **Affected Items** to the shotgun you want to use for the double pump. You can also set it to "All Items" if you want to remove any item.
    *   Set **Remove from** to **Instigating Player**.

3.  **Item Granter Device:**
    *   Drag an `item_granter_device` into your scene.
    *   In the Details panel, under **User Options**, add the same shotgun you used in the Item Remover to the **Items to Grant** list.
    *   Set **Grant to** to **Instigating Player**.
    *   Set **On Grant Action** to **Keep All**.

4.  **Conditional Button Device:**
    *   Drag a `conditional_button_device` into your scene.
    *   In the Details panel, under **User Options**, add the same shotgun to the **Key Items Required** list.
    *   Set the **Interaction Text** to something like "Double Pump Enabled".

5.  **Double Pump Manager Device:**
    *   In the Content Browser, you should now see your `double_pump_manager` device. Drag it into the scene.
    *   In the Details panel, you will see the editable properties you defined in the Verse script.

## 3. Link the Devices

Now, you need to link the devices to your `double_pump_manager` device.

1.  Select the `double_pump_manager` device in your scene.
2.  In the Details panel, you will see the following properties:
    *   `Input Trigger Device`
    *   `Item Remover Device`
    *   `Item Granter Device`
    *   `Conditional Button Device`
3.  For each property, click the eyedropper icon and then select the corresponding device in your scene.

## 4. Test It Out!

You're all set! Start your game and test the double pump mechanic. When you shoot your shotgun, it should be quickly replaced with a new one, allowing you to fire again almost instantly.
