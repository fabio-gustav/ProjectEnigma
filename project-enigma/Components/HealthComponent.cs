using Godot;
using System;

public partial class HealthComponent : Node
{
    [Export] public int MaxHealth { get; set; } = 3;

    public override void _Ready()
    {
        //Set up Health with player variables
        GetNode<PlayerVariables>("/root/PlayerVariables").Health = MaxHealth;
        GetNode<PlayerVariables>("/root/PlayerVariables").MaxHealth = MaxHealth;
        //Emit current health to update UI
        GetNode<SignalBus>("/root/SignalBus").EmitSignal(SignalBus.SignalName.HealthChanged);
    }

    public void Damage(Attack attack)
    {
        GetNode<PlayerVariables>("/root/PlayerVariables").Health -= attack.AttackDamage;
        GetNode<SignalBus>("/root/SignalBus").EmitSignal(SignalBus.SignalName.HealthChanged);
        if (GetNode<PlayerVariables>("/root/PlayerVariables").Health <= 0)
        {
            ((Player)GetParent()).Death();
        }
    }
}
