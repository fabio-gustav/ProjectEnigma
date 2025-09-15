using Godot;
using System;

public partial class Flizzard : Enemy
{

    [Export] public float PathStartingProgress { get; set; } = 0;
    public override void _Ready()
    {
        base._Ready();
    }


    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
    }



}

