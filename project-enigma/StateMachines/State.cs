using Godot;
using System;

public partial class State : Node
{
    private Player _player = null;
    
    [Signal]
    public delegate void StateTransitionEventHandler(String newState);

    public override void _Ready()
    {
        _player = GetParent().GetParent<Player>();
    }

    public void Enter() {}
    
    public void Exit() {}
    
    public void Update(double delta) {}
    
    public void PhysicsUpdate(double delta) {}
    
}
