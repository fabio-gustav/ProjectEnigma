using Godot;
using System;
using System.Runtime.CompilerServices;

public partial class Enemy : CharacterBody2D
{
    [Export] public float Speed = 2048;
    [Export] public float AirSpeed { get; set; } = 1024.0f;
    [Export] public float Acceleration { get; set; } = 9.0f;


    [Export] public float RisingJumpTime { get; set; } = 0.4f;
    [Export] public float FallingJumpTime { get; set; } = 0.5f;
    [Export] public float JumpHeight { get; set; } = 512f;

    public MovementStateMachine StateMachine = null;

    public override void _Ready()
    {
        StateMachine = GetNode<MovementStateMachine>("MovementStateMachine");
        StateMachine.Init();
        base._Ready();
    }
    
    public override void _PhysicsProcess(double delta)
    {
	    StateMachine.ProcessPhysics(delta);
	    MoveAndSlide();
    }

}

