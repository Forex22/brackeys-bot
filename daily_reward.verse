using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Verse }

player_reward_data := struct<concrete>:
    LastLoginTime : float
    LoginStreak : int

daily_reward_device := class(creative_device):

    var PlayerRewardData : [player]player_reward_data = map{}

    @editable
    RewardButton : button_device = button_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        RewardButton.InteractedWithEvent.Subscribe(OnButtonInteract)

    OnButtonInteract(Agent:agent):void=
        if (Player := player[Agent]):
            CanReward, TimeSinceLastLogin := CanReceiveReward(Player)
            if (CanReward):
                GrantReward(Player)
            else:
                TimeRemaining := 86400.0 - TimeSinceLastLogin
                Print("You can't receive a reward yet. Time remaining: {TimeRemaining} seconds.")
        else:
            Print("Could not get player from agent.")


    CanReceiveReward(Player:player) : tuple(logic, float) =
        if (Data := PlayerRewardData[Player]):
            TimeSinceLastLogin := GetSimulationElapsedTime() - Data.LastLoginTime
            return (TimeSinceLastLogin >= 86400.0, TimeSinceLastLogin) # 24 hours
        else:
            return (true, 0.0)

    GrantReward(Player:player):void=
        if (Data := PlayerRewardData[Player]):
            TimeSinceLastLogin := GetSimulationElapsedTime() - Data.LastLoginTime
            if (TimeSinceLastLogin >= 172800.0): # 48 hours
                # If the player missed a day, reset the streak
                if (set PlayerRewardData[Player] = player_reward_data{LastLoginTime := GetSimulationElapsedTime(), LoginStreak := 1}):
                    Print("Reward granted to player! Streak reset to 1.")
            else:
                # If the player is on a streak, increment it
                if (set PlayerRewardData[Player] = player_reward_data{LastLoginTime := GetSimulationElapsedTime(), LoginStreak := Data.LoginStreak + 1}):
                    Print("Reward granted to player! Streak is now {Data.LoginStreak + 1}.")
        else:
            # First time reward
            if (set PlayerRewardData[Player] = player_reward_data{LastLoginTime := GetSimulationElapsedTime(), LoginStreak := 1}):
                Print("First time reward granted to player!")
