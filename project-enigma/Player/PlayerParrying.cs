using Godot;
using System;

public partial class PlayerParrying : State
{

    [Export] public State GrappleState { get; set; } = null;
    [Export] public State FallState { get; set; } = null;
    
    private PhysicsBody2D _parryTarget;
    private CollisionShape2D _parryCollider;
    private KinematicCollision2D _parryCollision;
    private Vector2 _reflection;
    private float _ridingJumpGravity;
    private bool _hasParried = false;
    
    public override void Init()
    {
        _ridingJumpGravity = ((-2.0f * Player.RideJumpHeight) / (Player.RideRisingJumpTime * Player.RideRisingJumpTime)) * -1.0f;
    }
    
    public override void Enter()
    {
        if (Player.ParryTarget.HasOverlappingBodies())
        {
            _parryTarget = (StaticBody2D)Player.ParryTarget.GetOverlappingBodies()[0];
        }
        //start timer
        _parryCollider = _parryTarget.GetChild<CollisionShape2D>(0);
        
    }

    public override State PhysicsUpdate(double delta)
    {

        Player.Velocity = new Vector2(Player.Velocity.X, Player.Velocity.Y + (float)(_ridingJumpGravity * delta));
        
        _parryCollision = Player.MoveAndCollide(Player.Velocity);

        if (_parryCollision != null && _parryCollision.GetCollider() == _parryCollider)
        {
            _reflection = Player.Velocity.Bounce(_parryCollision.GetNormal());
            Player.Velocity = _reflection;
            _hasParried = true;
        }

        return null;
    }
}
