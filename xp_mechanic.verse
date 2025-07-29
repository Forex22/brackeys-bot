using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# A Verse-authored creative device that can be placed in a level
xp_mechanic := class(creative_device):

    # Grant XP when a player hits this device
    OnHit(Agent: agent) : void=
        if (Player := player[Agent]):
            Print("Granting 10 XP to {Player.Name}")
            # In a real implementation, you would award XP here.
            # This might involve calling a function on a centralized XP manager
            # or using a device to grant the XP directly.
            # For now, we'll just print a message.
            AwardXp(Agent, 10)


    AwardXp(Agent: agent, Amount: int) : void=
        # This is a placeholder for the actual XP awarding logic.
        # You would replace this with the appropriate API calls for your project.
        Print("Awarded {Amount} XP.")
