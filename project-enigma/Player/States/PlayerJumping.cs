using Godot;
using System;

public partial class PlayerJumping : State
{
    [Export] public State GrappleState { get; set; } = null;
    [Export] public State ParryState { get; set; } = null;
    [Export] public State FallState { get; set; } = null;

    private float _jumpVelocity = 0.0f;
    private float _jumpGravity = 0.0f;
    private float _ridingJumpVelocity = 0.0f;
    private float _ridingJumpGravity = 0.0f;

    public override void Init()
    {
        _jumpVelocity = ((2.0f * Player.JumpHeight) / Player.RisingJumpTime) * -1.0f;
        _jumpGravity = ((-2.0f * Player.JumpHeight) / (Player.RisingJumpTime * Player.RisingJumpTime)) * -1.0f;
        _ridingJumpVelocity = ((2.0f * Player.RideJumpHeight) / Player.RideRisingJumpTime) * -1.0f;
        _ridingJumpGravity = ((-2.0f * Player.RideJumpHeight) / (Player.RideRisingJumpTime * Player.RideRisingJumpTime)) * -1.0f;
        
    }

    public override void Enter()
    {
        //Player.ParryAvailable = true

        if (Player.IsRiding)
        {
            Player.Velocity = new Vector2(Player.Velocity.X, _ridingJumpVelocity);
        }
        else
        {
            Player.Velocity = new Vector2(Player.Velocity.X, _jumpVelocity);
        }
        
        Player._jumpAvailable = false;
        if (Player.IsRiding)
        {
            Player.PlayerSprite.PlayAnimation("RideJump");
        }
        else
        {
            Player.PlayerSprite.PlayAnimation("Jump");
        }
    }

    public override void Exit()
    {
        //Player.Velocity = new Vector2(Player.Velocity.X, 0.0f);
        _jumpGravity = ((-2.0f * Player.JumpHeight) / (Player.RisingJumpTime * Player.RisingJumpTime)) * -1.0f;
        _ridingJumpGravity = ((-2.0f * Player.RideJumpHeight) / (Player.RideRisingJumpTime * Player.RideRisingJumpTime)) * -1.0f;
    }

    public override State ProcessInput(InputEvent @event)
    {
        //fix this name later
        //GD.Print(Player.GrappleCheck());
        if (Player.GrappleCheck() && @event.IsActionPressed("grapple"))
        {
            return GrappleState;
        }

        return null;
    }

    public override State PhysicsUpdate(double delta)
    {

        if (Player.IsRiding)
        {
            //float.Lerp(Player.Velocity.X, Mathf.Clamp((Player.RideAirSpeed*GetInput())+Player.Velocity.X,-Player.RideSpeed,Player.RideSpeed), Player.RideAcceleration)
            Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, (Player.RideAirSpeed*GetInput())+Player.Velocity.X, Player.RideAcceleration*(float)delta), Player.Velocity.Y + (float)(_jumpGravity * delta));
        }
        else
        {
            //float.Lerp(Player.Velocity.X, Mathf.Clamp((Player.AirSpeed*GetInput())+Player.Velocity.X,-Player.Speed,Player.Speed), Player.Acceleration)
            Player.Velocity = new Vector2(Player.Velocity.X + Player.AirSpeed*GetInput(), Player.Velocity.Y + (float)(_jumpGravity * delta));
        }
        //Acceleration needs to be fixed, also I'm getting rid of AirResistance because it is dumb and stupid
        
        if (Player.Velocity.Y >= 0.0f)
        {
            return FallState;
        }

        if (!Input.IsActionPressed("jump"))
        {

            if (Player.IsRiding)
            {
                _ridingJumpGravity = ((-6.0f * Player.RideJumpHeight) / (Player.RideRisingJumpTime * Player.RideRisingJumpTime)) * -1.0f;  
            }
            else
            {
                _jumpGravity = ((-6.0f * Player.JumpHeight) / (Player.RisingJumpTime * Player.RisingJumpTime)) * -1.0f;
            }
            //We achieve jump cutting by just tripling gravity. We should make this better at some point
            
        }

        return null;
    }
}
