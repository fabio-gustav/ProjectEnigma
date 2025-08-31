using Godot;
using System;

public partial class State : Node
{
    protected Player Player = null;

    public override void _Ready()
    {
        Player = GetParent().GetParent<Player>();
    }
    
    public virtual void Init() {}

    public virtual void Enter() {}
    
    public virtual void Exit() {}

    public virtual State ProcessInput(InputEvent @event)
    {
        return null;
    }

    public virtual State ProcessFrame(double delta)
    {
        return null;
    }
    
    public virtual State PhysicsUpdate(double delta)
    {
        return null;
    }

    public float GetInput()
    {
        return Input.GetAxis("left", "right");
    }

    public override string ToString()
    {
        return Name;
    }
}
