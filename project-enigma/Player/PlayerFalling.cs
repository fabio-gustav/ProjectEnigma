using Godot;
using System;

public partial class PlayerFalling : State
{
    [Export] public State GrappleState { get; set; } = null;
    [Export] public State ParryState { get; set; } = null;
    [Export] public State IdleState { get; set; } = null;
    [Export] public State JumpState { get; set; } = null;
    [Export] public State RideState { get; set; } = null;

    private float _fallGravity = 0.0f;

    public override void Init()
    {
        _fallGravity = ((-2.0f * Player.JumpHeight) / (Player.FallingJumpTime * Player.FallingJumpTime)) * -1.0f;
    }

    public override void Enter()
    {
        if (Player._jumpAvailable)
        {
            Player._coyoteTimer.Start(Player.CoyoteTime);
        }
    }

    public override State ProcessInput(InputEvent @event)
    {
        //This feels wrong, should be checking for CoyoteTimer?
        if (@event.IsActionPressed("jump"))
        {
            if (Player._jumpAvailable)
            {
                return JumpState;
            }

            Player._jumpBuffer = true;
            Player.JumpBufferTimer.Start(Player.JumpBufferTime);
            return null;
        }
        //Can reduce computation by nesting
        if (Player.GrappleCheck() && @event.IsActionPressed("grapple"))
        {
            return GrappleState;
        }

        return null;
    }

    public override State PhysicsUpdate(double delta)
    {
        Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, Player.AirSpeed*GetInput()+Player.Velocity.X, Player.Acceleration), Player.Velocity.Y + (float)(_fallGravity * delta));

        if (Player.IsOnFloor())
        {
            //Ride State Logic goes here eventually
            return IdleState;
        }

        return null;
    }
}
