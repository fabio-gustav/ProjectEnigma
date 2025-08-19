using Godot;
using System;

public partial class AttackComponent : Area2D
{
    public Attack Attack = new Attack();

    public override void _Ready()
    {
        Attack.AttackDamage = 1;
        Attack.AttackPosition = GlobalPosition;
        Attack.KnockbackForce = new Vector2(0.0f, 0.0f);
    }

    public void OnAreaEntered(HitboxComponent area)
    {
        area.Damage(Attack);
    }

    public void OnMeleeAttack()
    {
        Monitoring = true;
    }
}
