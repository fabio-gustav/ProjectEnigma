using Godot;
using System;

public partial class TumblinJumping : State
{
    [Export] public State TumblinFallingState { get; set; } = null;
    public Tumblin Tumblin = null;

    private float _jumpVelocity = 0.0f;
    private float _jumpGravity = 0.0f;

    public override void _Ready()
    {
        base._Ready();
        Tumblin = (Tumblin)GenericCharacter;
        _jumpVelocity = ((2.0f * Tumblin.JumpHeight) / Tumblin.RisingJumpTime) * -1.0f;
        _jumpGravity = ((-2.0f * Tumblin.JumpHeight) / (Tumblin.RisingJumpTime * Tumblin.RisingJumpTime)) * -1.0f; 
        
    }



    public override void Init()
    {
        
    }
        

    public override void Enter()
    {
        Tumblin.Velocity = new Vector2(Tumblin.Velocity.X, _jumpVelocity);
    }

    public override void Exit()
    {
        _jumpGravity = ((-2.0f * Tumblin.JumpHeight) / (Tumblin.RisingJumpTime * Tumblin.RisingJumpTime)) * -1.0f;
    }

    public override State ProcessInput(InputEvent @event)
    {
        return null;
    }

    public override State PhysicsUpdate(double delta)
    {
        Tumblin.Velocity = new Vector2(float.Lerp(Tumblin.Velocity.X, (Tumblin.AirSpeed*GetInput())+Tumblin.Velocity.X, Tumblin.Acceleration*(float)delta), Tumblin.Velocity.Y + (float)(_jumpGravity * delta));
        
        if (Tumblin.Velocity.Y >= 0.0f)
        {
            return TumblinFallingState;
        }
        return null;
    }
}
