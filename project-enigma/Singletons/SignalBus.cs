using Godot;
using System;

public partial class SignalBus : Node
{
    [Signal]
    public delegate void ChangeMoneyEventHandler(int money);
    [Signal]
    public delegate void MoneyChangedEventHandler(int money);
    
    [Signal]
    public delegate void HealthChangedEventHandler(int health);
}
