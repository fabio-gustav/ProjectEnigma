using Godot;
using System;

public partial class PlayerSliding : State
{
    
    [Export] public State JumpState { get; set; } = null;
    [Export] public State RunState { get; set; } = null;
    [Export] public State FallState { get; set; } = null;
    public override void Enter()
    {
        GD.Print("Sliding");
        Player._jumpAvailable = true;
        //Player.PlayerSprite.PlayBodyAnimation("Slide");
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
        Player._jumpAvailable = true;
        Player._coyoteTimer.Stop();
        return null;
    }
}
