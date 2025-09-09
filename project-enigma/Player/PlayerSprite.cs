using Godot;
using System;

public partial class PlayerSprite : Node2D
{
    
    public AnimatedSprite2D Top;
    public AnimatedSprite2D Bottom;
    private Player _player;

    public override void _Ready()
    {
        Top = GetNode<AnimatedSprite2D>("Top");
        Bottom = GetNode<AnimatedSprite2D>("Bottom");
        _player = GetParent<Player>();
    }

    public void PlayAnimation(string anim)
    {
        Top.Play(anim);
        Bottom.Play(anim);
    }
    
    public override void _PhysicsProcess(double delta)
    {
        if (_player.Velocity.X < 0.0f && !Top.FlipH)
        {
            Top.FlipH = true;
            Bottom.FlipH = true;
            
        }
        else if (_player.Velocity.X >= 0.0f && Top.FlipH)
        {
            Top.FlipH = false;
            Bottom.FlipH = false;
            
        }
    }
}
