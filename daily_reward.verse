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

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Print("Daily Reward Device Started")

    CanReceiveReward(Player:player) : tuple(logic, float) =
        if (Data := PlayerRewardData[Player]):
            TimeSinceLastLogin := GetSimulationElapsedTime() - Data.LastLoginTime
            return (TimeSinceLastLogin >= 24.0, TimeSinceLastLogin)
        else:
            return (true, 0.0)

    @editable
    RewardButton : button_device = button_device{}

    OnBegin<override>()<suspends>:void=
        RewardButton.InteractedWithEvent.Subscribe(OnButtonInteract)

    OnButtonInteract(Player:player):void=
        CanReward, TimeSinceLastLogin := CanReceiveReward(Player)
        if (CanReward):
            GrantReward(Player)
        else:
            Print("You can't receive a reward yet. Time remaining: {24.0 - TimeSinceLastLogin}")

    GrantReward(Player:player):void=
        if (Data := PlayerRewardData[Player]):
            TimeSinceLastLogin := GetSimulationElapsedTime() - Data.LastLoginTime
            if (TimeSinceLastLogin >= 48.0):
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
