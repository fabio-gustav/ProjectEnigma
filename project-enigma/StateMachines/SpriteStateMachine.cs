using Godot;
using System;

public partial class SpriteStateMachine : Node
{
    private Player _parent = null;

    public override void _Ready()
    {
        _parent = GetParent<Player>();
    }

    private void FlipPlayerSprite(bool flip)
    {
        if (flip)
        {
            //_parent.PlayerSprite.scale.x = -1
        }
        else
        {
            //_parent.PlayerSprite.scale.x = 1
        }
    }

    private void Aim(Vector2 position)
    {
        //TODO Fix this dogshit
        if (position.X < _parent.GlobalPosition.X)
        {
            FlipPlayerSprite(true);
        }
        else
        {
            FlipPlayerSprite(false);
        }
    }
}
