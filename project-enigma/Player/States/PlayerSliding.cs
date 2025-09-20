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

        Player.FloorStopOnSlope = false;
    }

    public override void Exit()
    {
        Player.FloorStopOnSlope = true;
        Player.PlayerSprite.Rotation = 0.0f;
        Player.IsRiding = false;
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
        //Player.PlayerSprite.Rotation = Player.GetAvgFloorAngle() * -Player.PlayerSprite.Top.Scale.Y;
        //GD.Print(Player.GetAvgFloorAngle());
        //GD.Print("Flip: " + Player.Scale.Y);
        //&& Player.PlayerSprite.Top.Scale.Y > 0
        if (floorNormal.X < 0)
        {
            Player.PlayerSprite.Rotation = Player.GetAvgFloorAngle();
        }
        else
        {
            Player.PlayerSprite.Rotation = Player.GetAvgFloorAngle();
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


        //GD.Print(Player.GetAvgFloorAngle());
        Player.PlayerLook();
        //Needs to be in both directions
        //Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, 0.0f, Player.SlideFriction),Player.Velocity.Y);
        Player.Velocity += float.Sin(Player.GetAvgFloorAngle())*(float)(_fallGravity * delta) * Vector2.FromAngle(Player.GetAvgFloorAngle());
        //Player.Velocity = new Vector2(Player.Velocity.X + float.Sin(Player.GetFloorAngle()*(float)(_fallGravity * delta)), Player.Velocity.Y + float.Cos(Player.GetFloorAngle()*(float)(_fallGravity * delta)));
        //Player.Velocity = Player.Velocity + (_fallGravity * (float)delta) * Player.GetFloorNormal().Normalized();
        //GD.Print(Player.Velocity);
        Player._jumpAvailable = true;
       
        Player._coyoteTimer.Stop();
        return null;
    }
}
