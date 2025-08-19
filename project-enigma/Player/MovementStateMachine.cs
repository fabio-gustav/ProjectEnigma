using Godot;
using System;
using System.Collections.Generic;

public partial class MovementStateMachine : Node
{
    
    [Export] public State InitialState { get; set; } = null;

    //Dictionary of states with a key value of the state name
    private Dictionary<String,State> _states = null;
    private State _currentState = null;

    public override void _Ready()
    {
        foreach (Node child in GetChildren())
        {
            if (child is State)
            {
                _states[child.Name.ToString().ToLower()] = (State)child;
                ((State)child).StateTransition += OnChildTransition;
            }
        }

        if (InitialState != null)
        {
            _currentState = InitialState;
            InitialState.Enter();
        }
    }

    public override void _Process(double delta)
    {
        if (_currentState != null)
        {
            _currentState.Update(delta);
        }
    }

    public override void _PhysicsProcess(double delta)
    {
        if (_currentState != null)
        {
            _currentState.PhysicsUpdate(delta);
        }
    }

    public void OnChildTransition(String newStateName)
    {
        //GD.Print("Transition from " +);

        State newState = _states[newStateName.ToLower()];

        if (newState == null)
        {
            GD.Print("State Not Found");
            return;
        }

        _currentState = newState;
        newState.Enter();
    }
}
