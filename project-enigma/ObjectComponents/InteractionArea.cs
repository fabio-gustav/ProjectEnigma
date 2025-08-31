using Godot;
using System;

public partial class InteractionArea : Area2D
{
    [Export] public String ActionVerb { get; set; } = "Interact";

    public override void _Ready()
    {
        BodyEntered += OnBodyEntered;
        BodyExited += OnBodyExited;
    }

    private void OnBodyEntered(Node2D body)
    {
        if (body is InteractionManager)
        {
            ((InteractionManager)body).RegisterArea(this);
        }
    }

    private void OnBodyExited(Node2D body)
    {
        if (body is InteractionManager)
        {
            ((InteractionManager)body).UnregisterArea(this);
        }
    }
}    
