using Godot;
using System;

public partial class HitboxComponent : Area2D
{
    [Export] public HealthComponent HealthComponent { get; set; } = null;

    public void Damage(Attack attack)
    {
        if (HealthComponent != null)
        {
            HealthComponent.Damage(attack);
        }
    }
}
