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


   private Sprite2D _grappleIcon = null;
   private StaticBody2D _grappleTarget = null;
   private RayCast2D _grappleCast = null;
   private Timer _coyoteTimer = null;
   private AnimationPlayer _playerSprite = null;
   
   public override void _Ready()
   {
      _grappleCast = GetNode<RayCast2D>("GrappleCast");
      _coyoteTimer = new Timer();
   }
}
