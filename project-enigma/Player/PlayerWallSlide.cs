using Godot;
using System;

public partial class PlayerWallSlide : State
{
    
    [Export] public State IdleState { get; set; } = null;
    [Export] public State WallJumpState { get; set; } = null;

    private Vector2 _wallNormal;
    private float _fallGravity = 0.0f;

    public override void Init()
    {
        _fallGravity = ((-2.0f * Player.JumpHeight) / (Player.FallingJumpTime * Player.FallingJumpTime)) * -1.0f;
    }
    

    public override void Enter()
    {
        _wallNormal = Player.GetFloorNormal().Rotated(1.5708f);

        Player.Velocity = -(_wallNormal * Player.Velocity.Length());
        //Player.GlobalPosition = new Vector2(Player.GlobalPosition.X, Player.GlobalPosition.Y - 11.0f);

    }

    public override State PhysicsUpdate(double delta)
    {
        Player.Velocity = new Vector2(0.0f, Player.Velocity.Y + (float)(_fallGravity * delta));

        if (Player.IsOnFloor())
        {
            //return IdleState;
        }
        
        return null;
    }
}

