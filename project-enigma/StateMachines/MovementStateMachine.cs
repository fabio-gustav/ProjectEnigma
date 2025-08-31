using Godot;
using System;
using System.Collections.Generic;

public partial class MovementStateMachine : Node
{
    [Export] public State InitialState { get; set; } = null;

    //Dictionary of states with a key value of the state name
    private State _currentState = null;

    public void Init()
    {
        foreach (Node child in GetChildren())
        {
            if (child is State)
            {
                ((State)child).Init();
            }
        }

        if (InitialState != null)
        {
            _currentState = InitialState;
            InitialState.Enter();
        }
    }

    public void ChangeState(State newState)
    {
        GD.Print("Transition from " + _currentState.ToString() + " to " + newState.ToString());
        if (_currentState != null)
        {
            _currentState.Exit();
        }

        _currentState = newState;
        _currentState.Enter();
    }
    public void ProcessPhysics(double delta)
    {
        if (_currentState != null)
        {
            State processState = _currentState.PhysicsUpdate(delta);
            if (processState != null)
            {
                ChangeState(processState);
            }
        }
    }

    public void ProcessInput(InputEvent @event)
    {
        State processState = _currentState.ProcessInput(@event);
        if (processState != null)
        {
            ChangeState(processState);
        }
    }
    
    public void ProcessFrame(double delta)
    {
        State processState = _currentState.ProcessFrame(delta);
        if (processState != null)
        {
            ChangeState(processState);
        }
    }

}
