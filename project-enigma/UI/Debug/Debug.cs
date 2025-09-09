using Godot;
using System;

public partial class Debug : Control
{

    private Control optionsMenu = null;
    bool rideState = false;

    TextEdit _DebugText = null;
    public override void _Ready()
    {
        //main pause menu
        SignalBus s = GetNode<SignalBus>("/root/SignalBus");
        _DebugText = GetNode<TextEdit>("TextEdit");
        s.PlayerStateChangeDebug += debugText;
        s.PlayerRideStateDebug += RideState;

        base._Ready();
    }

    public void debugText(State currentState)
    {
        _DebugText.Text = "Current Player State: " + currentState + "\nIn Ride State?: " + rideState;
    }

    public void RideState(bool riding)
    {
        rideState = riding;
    }

    







    
}
