using Godot;
using System;

public partial class PlayerSprite : Node2D
{
    
    public AnimatedSprite2D Top;
    public AnimatedSprite2D Bottom;
    private AnimationPlayer _animationPlayer;
    private CollisionShape2D _collider;
    private Player _player;

    public override void _Ready()
    {
        Top = GetNode<AnimatedSprite2D>("Top");
        Bottom = GetNode<AnimatedSprite2D>("Bottom");
        _animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
        _collider = GetNode<CollisionShape2D>("../Collider");
        _player = GetParent<Player>();
    }

    public void PlayAnimation(string anim)
    {
        _animationPlayer.Play(anim);
    }
    
    public override void _PhysicsProcess(double delta)
    {
        if (_player.Velocity.X < -0.0f)
        {
            //Top.FlipH = true;
            //Bottom.FlipH = true;
            Scale = new Vector2(-1, 1);
            //GD.Print("PlayerScale: " + _player.Scale);
            
        }
        if (_player.Velocity.X > 0.1f)
        {
            //Top.FlipH = false;
            //Bottom.FlipH = false;
            Scale = new Vector2(1, 1);
        }
    }
}
