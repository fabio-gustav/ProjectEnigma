using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class InteractionManager : Area2D
{

    private List<Area2D> _activeAreas = new List<Area2D>();
    private Player _player;

    public override void _Ready()
    {
        _player = GetParent<Player>();
    }


    public void RegisterArea(Area2D area)
    {
        _activeAreas.Add(area);
    }

    public void UnregisterArea(Area2D area)
    {
        _activeAreas.Remove(area);
    }
}
