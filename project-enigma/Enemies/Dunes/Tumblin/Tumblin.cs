using Godot;
using System;
using System.Runtime.CompilerServices;

public partial class Tumblin : Enemy
{

    public override void _Ready()
    {
        base._Ready();
    }

    public override void _PhysicsProcess(double delta)
    {
        Velocity = new Vector2(Speed, Velocity.Y);
        base._PhysicsProcess(delta);
    }

}
