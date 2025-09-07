using Godot;
using System;
using System.Runtime.CompilerServices;

public partial class Tumblin : CharacterBody2D
{
    [Export] public float Speed = 1000;
    [Export] public float AirSpeed { get; set; } = 0.2f;
    [Export] public float Acceleration { get; set; } = 0.25f;


    [Export] public float RisingJumpTime { get; set; } = 0.2f;
    [Export] public float FallingJumpTime { get; set; } = 0.2f;
    [Export] public float JumpHeight { get; set; } = 0.2f;

    private MovementStateMachine _stateMachine = null;

    public override void _Ready()
    {
        _stateMachine = GetNode<MovementStateMachine>("MovementStateMachine");
        _stateMachine.Init();
        base._Ready();
    }
    
    public override void _PhysicsProcess(double delta)
    {
        Velocity = new Vector2(Speed, Velocity.Y);
	    _stateMachine.ProcessPhysics(delta);
	    MoveAndSlide();
    }

}
