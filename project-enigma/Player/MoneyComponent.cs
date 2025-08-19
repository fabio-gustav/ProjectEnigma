using Godot;
using System;

public partial class MoneyComponent : Node
{
    [Export] public int Money { get; set; } = 0;
    const int Maxmoney = 9999;

    public override void _Ready()
    { 
        GetNode<SignalBus>("/root/SignalBus").ChangeMoney += Transaction;
    }


    private void Transaction(int newMoney)
    {
        if (Money + newMoney < Maxmoney && Money + newMoney > 0)
        {
            Money += newMoney;
            GetNode<PlayerVariables>("/root/PlayerVariables").Money = Money;
            GetNode<SignalBus>("/root/SignalBus").EmitSignal(SignalBus.SignalName.MoneyChanged);
        }
        else
        {
            GD.Print("No");
        }
        
    }
    

}
