using Godot;
using System;

public partial class PlayerRunning : State
{
    [Export] public State JumpState { get; set; } = null;
    [Export] public State FallState { get; set; } = null;
    [Export] public State IdleState { get; set; } = null;
    [Export] public State SlideState { get; set; } = null;
    [Export] public State ParryState { get; set; } = null;

    public override void Enter()
    {
        if (Player.IsRiding)
        {
            Player.PlayerSprite.PlayAnimation("Run");
        }
        else
        {
            Player.PlayerSprite.PlayAnimation("Run");
        }
        
    }

    public override State ProcessInput(InputEvent @event)
    {
        if (Player._jumpBuffer || @event.IsActionPressed("jump"))
        {
            Player._jumpBuffer = false;
            return JumpState;
        }

        

        if (@event.IsActionPressed("energy"))
        {
            //spend energy logic
            GetNode<SignalBus>("/root/SignalBus").EmitSignal(SignalBus.SignalName.PlayerRideStateDebug, Player.IsRiding);
            Player.IsRiding = true;
            return this;
        }

        return null;
    }

    public override State PhysicsUpdate(double delta)
    {
        if (Player.IsRiding)
        {
            //Movement for ride state
            Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, Player.RideSpeed*GetInput(), Player.RideAcceleration*(float)delta),Player.Velocity.Y);
        }
        else
        {
            Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, Player.Speed*GetInput(), Player.Acceleration*(float)delta),Player.Velocity.Y);
        }
        
        if (Input.IsActionPressed("slide"))
        {
            return SlideState;
        }
        
        if (Mathf.Abs(GetInput()) < 0.2f)
        {
            if (Player.IsRiding)
            {
                Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, 0.0f, Player.RideFriction*(float)delta),Player.Velocity.Y);
            }
            else
            {
                Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, 0.0f, Player.Friction*(float)delta),Player.Velocity.Y);
            }
            
        }

        if (!Player.IsOnFloor())
        {
            //Check is possibly redundant
            if (Player._jumpAvailable)
            {
                Player._coyoteTimer.Start(Player.CoyoteTime);
            }

            return FallState;
        }

        //Float here basically controls our deadzone
        if (Player.Velocity.Abs().X < 40.0f)
        {
            Player.IsRiding = false;
            return IdleState;
        } 
        return null;
    }
}
