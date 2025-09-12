using Godot;
using System;

public partial class PlayerRunning : State
{
    [Export] public State JumpState { get; set; } = null;
    [Export] public State FallState { get; set; } = null;
    [Export] public State IdleState { get; set; } = null;
    [Export] public State SlideState { get; set; } = null;
    [Export] public State ParryState { get; set; } = null;
    [Export] public State WallSlideState { get; set; } = null;

    public override void Enter()
    {
        if (Player.IsRiding)
        {
            Player.PlayerSprite.PlayAnimation("Run");
        }
        else
        {
            Player.PlayerSprite.PlayAnimation("Run");
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

        

        if (@event.IsActionPressed("energy"))
        {
            //spend energy logic
            GetNode<SignalBus>("/root/SignalBus").EmitSignal(SignalBus.SignalName.PlayerRideStateDebug, Player.IsRiding);
            Player.IsRiding = true;
            return this;
        }

        return null;
    }

    public override State PhysicsUpdate(double delta)
    {
        if (Player.IsRiding)
        {
            //AHHHHHHHH
            /*
             * When riding, do block slope calculation but Lerp to max velocity vector based on input
             */
            //Player.Rotation = Player.GetFloorAngle();
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
        
            //GD.Print(Player.RotationDegrees);
            Player.Velocity = Player.Velocity.Lerp(Player.Velocity.Abs().Normalized() * (Player.RideSpeed * GetInput()), Player.RideAcceleration*(float)delta);
            
            //Movement for ride state
            //Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, Player.RideSpeed*GetInput(), Player.RideAcceleration*(float)delta),Player.Velocity.Y);
        }
        else
        {
            Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, Player.Speed*GetInput(), Player.Acceleration*(float)delta),Player.Velocity.Y);
        }
        
        if (Input.IsActionPressed("slide"))
        {
            return SlideState;
        }
        
        
        
        if (Mathf.Abs(GetInput()) < 0.2f)
        {
            if (Player.IsRiding)
            {
                //Player.Velocity = Player.Velocity.Lerp(Vector2.Zero, Player.RideFriction);
                Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, 0.0f, Player.Friction*(float)delta),Player.Velocity.Y);
            }
            else
            {
                Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, 0.0f, Player.Friction*(float)delta),Player.Velocity.Y); 
            }
            
        }

        //GD.Print(Player.GetFloorNormal());
        if (Player.IsRiding && Player.WallCheck())
        {
            //return WallSlideState;
        }
        
        if (!Player.IsOnFloor())
        {
            //Check is possibly redundant
            if (Player._jumpAvailable)
            {
                Player._coyoteTimer.Start(Player.CoyoteTime);
            }

            return FallState;
        }

        //Float here basically controls our deadzone
        if (Player.Velocity.Abs().X < 40.0f)
        {
            Player.IsRiding = false;
            return IdleState;
        } 
        return null;
    }
}
