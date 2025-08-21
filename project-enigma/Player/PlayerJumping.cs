using Godot;
using System;

public partial class PlayerJumping : State
{
    [Export] public State GrappleState { get; set; } = null;
    [Export] public State ParryState { get; set; } = null;
    [Export] public State FallState { get; set; } = null;

    private float _jumpVelocity = 0.0f;
    private float _jumpGravity = 0.0f;

    public override void Init()
    {
        _jumpVelocity = ((2.0f * Player.JumpHeight) / Player.RisingJumpTime) * -1.0f;
        _jumpGravity = ((-2.0f * Player.JumpHeight) / (Player.RisingJumpTime * Player.RisingJumpTime)) * -1.0f;
    }

    public override void Enter()
    {
        //Player.ParryAvailable = true
        Player.Velocity = new Vector2(Player.Velocity.X, Player.Velocity.Y + _jumpVelocity);
        Player._jumpAvailable = false;
    }

    public override void Exit()
    {
        Player.Velocity = new Vector2(Player.Velocity.X, 0.0f);
    }

    public override State ProcessInput(InputEvent @event)
    {
        //fix this name later
        if (Player.GrappleCheck() && @event.IsActionPressed("grapple"))
        {
            return GrappleState;
        }

        return null;
    }

    public override State PhysicsUpdate(double delta)
    {
        //Acceleration needs to be fixed, also I'm getting rid of AirResistance because it is dumb and stupid
        Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, Player.AirSpeed*GetInput(), Player.Acceleration), Player.Velocity.Y + (float)(_jumpGravity * delta));

        if (Player.Velocity.Y >= 0.0f)
        {
            return FallState;
        }

        if (!Input.IsActionPressed("jump"))
        {
            _jumpGravity = ((-6.0f * Player.JumpHeight) / (Player.RisingJumpTime * Player.RisingJumpTime)) * -1.0f;
        }

        return null;
    }
}
