using Godot;
using System;

public partial class PlayerParrying : State
{

    [Export] public State GrappleState { get; set; } = null;
    [Export] public State FallState { get; set; } = null;
    [Export] public State RunState { get; set; } = null;
    
    private PhysicsBody2D _parryTarget;
    private CollisionShape2D _parryCollider;
    private KinematicCollision2D _parryCollision;
    private Vector2 _reflection;
    private bool _hasParried = false;
    
    
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

        Player.Velocity = -Player.Velocity;

        return RunState;
    }
}
