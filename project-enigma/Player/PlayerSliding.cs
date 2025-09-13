using Godot;
using System;

public partial class PlayerSliding : State
{
    
    [Export] public State JumpState { get; set; } = null;
    [Export] public State RunState { get; set; } = null;
    [Export] public State FallState { get; set; } = null;
    
    private float _fallGravity = 0.0f;
    
    public override void Init()
    {
        _fallGravity = ((-2.0f * Player.JumpHeight) / (Player.FallingJumpTime * Player.FallingJumpTime)) * -1.0f;
    }
    
    public override void Enter()
    {
        //GD.Print("Sliding");
        Player._jumpAvailable = true;
        if (Player.IsRiding)
        {
            Player.PlayerSprite.PlayAnimation("Slide");
        }
        else
        {
            Player.PlayerSprite.PlayAnimation("Slide");
        }
    }

    public override void Exit()
    {
        Player.PlayerSprite.Rotation = 0.0f;
    }

    public override State ProcessInput(InputEvent @event)
    {
        if (Player._jumpBuffer || @event.IsActionPressed("jump"))
        {
            Player._jumpBuffer = false;
            return JumpState;
        }

        return null;
    }

    public override State PhysicsUpdate(double delta)
    {

        Vector2 floorNormal = Player.GetFloorNormal();
        Player.PlayerSprite.Rotation = Player.GetFloorAngle() * -Player.PlayerSprite.Top.Scale.Y;
        //GD.Print("Floor: " + (floorNormal.X < 0).ToString());
        //GD.Print("Flip: " + Player.Scale.Y);
        if (floorNormal.X < 0 && Player.PlayerSprite.Top.Scale.Y > 0)
        {
            Player.PlayerSprite.Rotation = Player.GetFloorAngle() * -Player.Scale.Y;
        }
        else
        {
            Player.PlayerSprite.Rotation = Player.GetFloorAngle() * Player.Scale.Y;
        }
            
        Player.ApplyFloorSnap();
        
        if (!Input.IsActionPressed("slide"))
        {
            return RunState;
        }
        
        if (!Player.IsOnFloor())
        {
            //This should only be needed in fall state, but I'm going to test before I delete it
            if (Player._jumpAvailable)
            {
                Player._coyoteTimer.Start(Player.CoyoteTime);
            }
            return FallState;
        }
        
        Player.PlayerLook();
        Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, 0.0f, Player.SlideFriction),Player.Velocity.Y);
        Player.Velocity = new Vector2(Player.Velocity.X + Player.GetFloorNormal().X, Player.Velocity.Y + (float)(_fallGravity*30 * delta) + Player.GetFloorNormal().Y);
        //Player.Velocity = Player.Velocity + (_fallGravity * (float)delta) * Player.GetFloorNormal().Normalized();
        GD.Print(Player.Velocity);
        Player._jumpAvailable = true;
        Player._coyoteTimer.Stop();
        return null;
    }
}
