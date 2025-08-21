using Godot;
using System;

public partial class PlayerRunning : State
{
    [Export] public State JumpState { get; set; } = null;
    [Export] public State WalkState { get; set; } = null;
    [Export] public State FallState { get; set; } = null;
    [Export] public State IdleState { get; set; } = null;
    [Export] public State RideState { get; set; } = null;
    [Export] public State SlideState { get; set; } = null;
    [Export] public State ParryState { get; set; } = null;

    public override State ProcessInput(InputEvent @event)
    {
        if (Player._jumpBuffer || @event.IsActionPressed("jump"))
        {
            Player._jumpBuffer = false;
            return JumpState;
        }

        if (@event.IsActionPressed("slide"))
        {
            return SlideState;
        }

        return null;
    }

    public override State PhysicsUpdate(double delta)
    {
        Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, Player.Speed*GetInput(), Player.Acceleration),Player.Velocity.Y);

        if (GetInput() == 0.0)
        {
            Player.Velocity = new Vector2(float.Lerp(Player.Velocity.X, 0.0f, Player.Friction),Player.Velocity.Y);
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
        
          /*
           * if abs(parent.velocity.x) < parent.walk_speed:
		    #legs.stop()
		    #arm.stop()
		    return walk_state
	        if abs(parent.velocity.x) > parent.run_speed - 400:
		    ##legs.stop()
		    ##arm.stop()
		    #return surf_state
           */
      return null;
    }
}
