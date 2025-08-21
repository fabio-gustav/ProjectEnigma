using Godot;
using System;

public partial class PlayerGrappling : State
{
    [Export] public State FallState { get; set; } = null;
    [Export] public State GrapplePullState { get; set; } = null;
    [Export] public State IdleState { get; set; } = null;
    [Export] public State JumpState { get; set; } = null;
    
    
    private float _fallGravity = 0.0f;
    private Vector2 _targetPosition = new Vector2(0.0f,0.0f);
    private float _ropeLength = 0.0f;
    private Sprite2D _icon = new Sprite2D();

    public override void Init()
    {
        _fallGravity = ((-2.0f * Player.JumpHeight) / (Player.FallingJumpTime * Player.FallingJumpTime)) * -1.0f;
    }

    public override void Enter()
    {
        Player._playerGrappled = true;
        _targetPosition = Player._grappleTarget.GlobalPosition;
        _ropeLength = Player.GlobalPosition.DistanceTo(_targetPosition);
    }

    public override void Exit()
    {
        Player._playerGrappled = false;
        //Player._isRiding = true;
    }

    public override State ProcessInput(InputEvent @event)
    {
        if (@event.IsActionPressed("jump"))
        {
            //Check JumpAvail?
            return JumpState;
        }

        if (@event.IsActionPressed("grapplepull"))
        {
            return GrapplePullState;
        }

        return null;
    }

    public override State PhysicsUpdate(double delta)
    {
        Player.Velocity = new Vector2(Player.Velocity.X, Player.Velocity.Y + (float)(_fallGravity * delta));
        Swing(delta);
        //Player.velocity *= 0.98;

        if (Player.IsOnFloor())
        {
            return IdleState;
        }

        return null;
    }

    private void Swing(double delta)
    {
        Vector2 radius = Player.GlobalPosition - _targetPosition;

        if (Player.Velocity.Length() < 0.01 || radius.Length() < 10)
        {
            return;
        }
        //Hell Equations
        float angle = float.Acos(radius.Dot(Player.Velocity) / (radius.Length()*Player.Velocity.Length()));
        float radialVelocity = float.Cos(angle) * Player.Velocity.Length();

        Player.Velocity += radius.Normalized() * -(radialVelocity);

        //Approximate
        if (Player.GlobalPosition.DistanceTo(_targetPosition) != _ropeLength)
        {
            Player.GlobalPosition = _targetPosition + radius.Normalized() * _ropeLength;
        }

        Player.Velocity += (_targetPosition - Player.GlobalPosition).Normalized() * (float)(delta * 15000);
        //Is 2nd condition needed?
        if (Input.IsActionPressed("right") && Player.Velocity.X > 0)
        {
            Player.Velocity += Player.Velocity.Normalized() * (float)(Player.SwingSpeed * radius.Length());
        }
        
        if (Input.IsActionPressed("right") && Player.Velocity.X < 0)
        {
            Player.Velocity += Player.Velocity.Normalized() * (float)(Player.SwingSpeed * radius.Length());
        }
    }
}
