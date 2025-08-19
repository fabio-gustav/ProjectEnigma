using Godot;
using System;

public partial class Player : CharacterBody2D
{
   /*
    * Export Variables
    */
   [Export] public double CoyoteTime { get; set; } = 0.2;
   [Export] public double JumpBufferTime { get; set; } = 0.1;
   [Export] public double DashCoolDown { get; set; } = 0.5;
   [Export] public double Acceleration { get; set; } = 0.25;
   
   [Export] public double JumpHeight { get; set; } = 0.2;
   
   [Export] public double RisingJumpTime { get; set; } = 0.2;
   [Export] public double FallingJumpTime { get; set; } = 0.2;
   [Export] public double AirSpeed { get; set; } = 0.2;
   [Export] public double AirResistance { get; set; } = 0.2;
   [Export] public double DashDistance { get; set; } = 0.2;
   [Export] public double Speed { get; set; } = 0.2;
   [Export] public double Friction { get; set; } = 0.2;
   [Export] public double SwingSpeed { get; set; } = 0.2;
   [Export] public double SlideFriction { get; set; } = 0.2;
   [Export] public double GrapplePull { get; set; } = 0.2;
   [Export] public double WallSlideGravity { get; set; } = 0.2;
   [Export] public double GrapplePullSpeed { get; set; } = 0.2;

   /*
    * Local Variables
    */

   private bool _playerGrappled = false;
   private bool _jumpAvailable = false;
   private bool _jumpBuffer = false;


   private Texture2D _marker = GD.Load<Texture2D>("res://Player/Sprites/Grapple_Point_Dot.png");
   
   private Sprite2D _grappleIcon = null;
   private StaticBody2D _grappleTarget = null;
   private RayCast2D _grappleCast = null;
   private Timer _coyoteTimer = null;
   public AnimationPlayer PlayerSprite = null;
   
   public override void _Ready()
   {
      _grappleCast = GetNode<RayCast2D>("GrappleCast");
      _coyoteTimer = new Timer();

      FloorMaxAngle = Mathf.DegToRad(80.0f);
      FloorSnapLength = 10.0f;
      FloorStopOnSlope = false;

      _grappleIcon = new Sprite2D();
      _grappleIcon.Visible = false;
      _grappleIcon.Position = GlobalPosition;
      _grappleIcon.Texture = _marker;
      _grappleIcon.Scale = new Vector2(0.4f, 0.4f);
      //Might need deferred call here
      AddSibling(_grappleIcon);
   }

   private void grapple_check()
   {
      _playerGrappled = true;
      GodotObject grappleCollider = _grappleCast.GetCollider();
      //Check for staticbody
      if (grappleCollider is StaticBody2D)
      {
         if (((StaticBody2D)grappleCollider).CollisionLayer == 1 && _grappleTarget != grappleCollider)
         {
            _grappleIcon.Position = ((StaticBody2D)grappleCollider).Position;
            _grappleIcon.Visible = true;
            if (!_playerGrappled)
            {
               _grappleTarget = (StaticBody2D)grappleCollider;
            }
         }
         else if (!_playerGrappled)
         {
            _grappleTarget = null;
            _grappleIcon.Visible = false;
         }
      }
   }

   private void CoyoteTimeout()
   {
      _jumpAvailable = false;
   }

   private void JumpBufferTimeout()
   {
      _jumpBuffer = false;
   }

   //private void DashCooldownTimeout()

   private Vector2 PlayerLook()
   {
      return Input.GetVector("Left", "Right", "Up", "Down");
   }

   public void Death()
   {
      //TODO Change signal to scene transition
      GetNode<SignalBus>("/root/PlayerVariables").EmitSignal(SignalBus.SignalName.HealthChanged);
   }
   
   public override void _PhysicsProcess(double delta)
   {
      grapple_check();
      _grappleCast.LookAt((10*PlayerLook())+GlobalPosition);
      MoveAndSlide();
   }
   
   
}
