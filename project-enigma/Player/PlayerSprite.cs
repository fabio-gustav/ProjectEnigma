using Godot;
using System;

public partial class PlayerSprite : Node2D
{
    
    public AnimatedSprite2D Head;
    public AnimatedSprite2D Body;
    public AnimatedSprite2D Arm;
    private Player _player;

    public override void _Ready()
    {
        Head = GetNode<AnimatedSprite2D>("Head");
        Body = GetNode<AnimatedSprite2D>("Body");
        Arm = GetNode<AnimatedSprite2D>("Arm");
        _player = GetParent<Player>();
    }

    public void PlayHeadAnimation(string anim)
    {
        Head.Play(anim);
    }
    
    public void PlayBodyAnimation(string anim)
    {
        Body.Play(anim);
    }

    public override void _PhysicsProcess(double delta)
    {
        if (_player.Velocity.X < 0.0f && !Head.FlipH)
        {
            Head.FlipH = true;
            Body.FlipH = true;
            Arm.FlipH = true;
        }
        else if (_player.Velocity.X >= 0.0f && Head.FlipH)
        {
            Head.FlipH = false;
            Body.FlipH = false;
            Arm.FlipH = false;
        }
    }
}
