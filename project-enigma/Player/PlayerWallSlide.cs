using Godot;
using System;

public partial class PlayerWallSlide : State
{

    [Export] public State IdleState { get; set; } = null;
    [Export] public State WallJumpState { get; set; } = null;

    private Vector2 _wallNormal;
    private float _fallGravity = 0.0f;
    private Timer wallStickTimer = null;

    public override void Init()
    {
        _fallGravity = ((-2.0f * Player.JumpHeight) / (Player.FallingJumpTime * Player.FallingJumpTime)) * -1.0f;
        wallStickTimer = new Timer();
        AddChild(wallStickTimer);
        wallStickTimer.WaitTime = Player.wallStickWaitTime;//1.0f by default
        wallStickTimer.OneShot = true;
        wallStickTimer.Timeout += wallStickTimeout;
    }


    public override void Enter()
    {
        _wallNormal = Player.GetFloorNormal().Rotated(1.5708f);

        Player.Velocity = -(_wallNormal * Player.Velocity.Length());
        //Player.GlobalPosition = new Vector2(Player.GlobalPosition.X, Player.GlobalPosition.Y - 11.0f);
        Player.wallStuck = true;
        wallStickTimer.Start();

    }

    public override State PhysicsUpdate(double delta)
    {
        if (!Player.wallStuck)
        {
            Player.Velocity = new Vector2(0.00f, Player.Velocity.Y + (float)(_fallGravity * delta) - ((float)(Player.WallSlideGravity * delta) * (float)3.14));
        }
        else
        {
            Player.Velocity = new Vector2(0.00f, 0.00f);
        }   

        if (Player.IsOnFloor())
        {
            Player.wallStuck = false;
            return IdleState;
        }

        return null;
    }

    public void wallStickTimeout()
    {
        Player.wallStuck = false;
    }
}

