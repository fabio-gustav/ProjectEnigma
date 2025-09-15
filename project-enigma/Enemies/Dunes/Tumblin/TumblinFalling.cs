using Godot;
using System;
using System.ComponentModel;

public partial class TumblinFalling : State
{

    [Export] public State TumblinJumpingState { get; set; } = null;
    Tumblin Tumblin = null;
    private float _fallGravity = 0.0f;

    public override void _Ready()
    {
        base._Ready();
        Tumblin = (Tumblin)GenericCharacter;
        _fallGravity = ((-2.0f * Tumblin.JumpHeight) / (Tumblin.FallingJumpTime * Tumblin.FallingJumpTime)) * -1.0f;
    }




    public override void Init()
    {
        
    }
        

    public override void Enter()
    {
        return;
    }

    public override State ProcessInput(InputEvent @event)
    {
        return null;
    }

    public override State PhysicsUpdate(double delta)
    {
        Tumblin.Velocity = new Vector2(float.Lerp(Tumblin.Velocity.X, (Tumblin.AirSpeed*GetInput())+Tumblin.Velocity.X, Tumblin.Acceleration*(float)delta), Tumblin.Velocity.Y + (float)(_fallGravity * delta));
        if (Tumblin.IsOnFloor())
        {
            return TumblinJumpingState;
        }
        return null;
    }


}
