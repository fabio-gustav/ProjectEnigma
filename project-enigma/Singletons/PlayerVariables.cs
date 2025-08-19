using Godot;
using System;

public partial class PlayerVariables : Node
{
    [Export] public int Money { get; set; } = 0;
    [Export] public int Health { get; set; } = 0;
    [Export] public int MaxHealth { get; set; } = 0;
}
