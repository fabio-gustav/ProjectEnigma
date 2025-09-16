using Godot;
using System;

public partial class Patrol : State
{
    Flizzard Flizzard = null;
    [Export] public Path2D Path { get; set; } = null;
    Node2D tracer = null;
    PathFollow2D PathFollow = null;

    public override void _Ready()
    {
        base._Ready();
        Flizzard = (Flizzard)GenericCharacter;
        tracer = Path.GetNode<Node2D>("./PathFollow2D/Tracer");
        PathFollow = Path.GetNode<PathFollow2D>("./PathFollow2D");
        Path.TopLevel = true;
        Path.GlobalPosition = Flizzard.GlobalPosition;
        PathFollow.ProgressRatio = Flizzard.PathStartingProgress;
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
        PathFollow.Progress += (Flizzard.Speed * (float)delta);
        Flizzard.GlobalPosition = tracer.GlobalPosition;
        return null;
    }
}
