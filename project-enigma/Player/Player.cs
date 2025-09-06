using Godot;
using System;

public partial class Player : CharacterBody2D
{
   /*
	* Export Variables
	*
	* Common Movement
	*/
   [Export] public float Acceleration { get; set; } = 0.25f;
   [Export] public float RideAcceleration { get; set; } = 0.25f;
   
   
   
   
   /*
	* Jump Stuff
	*/
   [Export] public float RisingJumpTime { get; set; } = 0.2f;
   [Export] public float FallingJumpTime { get; set; } = 0.2f;
   [Export] public float JumpHeight { get; set; } = 0.2f;
   [Export] public float RideRisingJumpTime { get; set; } = 0.2f;
   [Export] public float RideFallingJumpTime { get; set; } = 0.2f;
   [Export] public float RideJumpHeight { get; set; } = 0.2f;
   [Export] public double DashDistance { get; set; } = 0.2;
   [Export] public double WallSlideGravity { get; set; } = 0.2;
   
   /*
	* Top Speeds
	*/
   [Export] public float Speed { get; set; } = 0.2f;
   [Export] public float AirSpeed { get; set; } = 0.2f;
   [Export] public float RideSpeed { get; set; } = 0.2f;
   [Export] public float RideAirSpeed { get; set; } = 0.2f;
   [Export] public double SwingSpeed { get; set; } = 0.2;
   
   /*
	* Resistance
	*/
   [Export] public float Friction { get; set; } = 0.2f;
   [Export] public double SlideFriction { get; set; } = 0.2;
   [Export] public float RideFriction { get; set; } = 0.2f;
   
   
   
   /*
	* Grapple Stuff
	*/
   [Export] public double GrapplePull { get; set; } = 0.2;
   [Export] public double GrapplePullSpeed { get; set; } = 0.2;
   
   
   /*
	* Timers and Things
	*/
   [Export] public double CoyoteTime { get; set; } = 0.2;
   [Export] public double JumpBufferTime { get; set; } = 0.1;
   [Export] public double DashCoolDown { get; set; } = 0.5;
   /*
	* Local Variables
	*/

   public bool _playerGrappled = false;
   public bool _jumpAvailable = false;
   public bool _jumpBuffer = false;


   private Texture2D _marker = GD.Load<Texture2D>("res://Player/Assets/Grapple_Point_Dot.png");
   
   private Sprite2D _grappleIcon = null;
   public Area2D _grappleTarget = null;
   private RayCast2D _grappleCast = null;
   public Timer _coyoteTimer = null;
   public Timer JumpBufferTimer = null;
   public PlayerSprite PlayerSprite = null;
   private MovementStateMachine _stateMachine = null;
   public bool IsRiding;
   
   public override void _Ready()
   {
	  _stateMachine = GetNode<MovementStateMachine>("MovementStateMachine");
	  _grappleCast = GetNode<RayCast2D>("GrappleCast");
	  _coyoteTimer = new Timer();
	  JumpBufferTimer = new Timer();
	  _coyoteTimer.Timeout += CoyoteTimeout;
	  JumpBufferTimer.Timeout += JumpBufferTimeout;
	  FloorMaxAngle = Mathf.DegToRad(80.0f);
	  FloorSnapLength = 10.0f;
	  FloorStopOnSlope = false;
	  IsRiding = false;

	  PlayerSprite = GetNode<PlayerSprite>("PlayerSprite");
	  
	  _grappleIcon = new Sprite2D();
	  _grappleIcon.Visible = false;
	  _grappleIcon.Position = GlobalPosition;
	  _grappleIcon.Texture = _marker;
	  _grappleIcon.Scale = new Vector2(0.4f, 0.4f);
	  _grappleIcon.TopLevel = true;
	  
	  //Might need deferred call here
	  AddChild(_grappleIcon);
	  AddChild(_coyoteTimer);
	  AddChild(JumpBufferTimer);
	  
	  _stateMachine.Init();
   }

   public bool GrappleCheck()
   {
	   if (_playerGrappled)
	   {
		   return false;
	   }
	   if (!_grappleCast.IsColliding())
	   {
		   _grappleTarget = null;
		   _grappleIcon.Visible = false;
		   _grappleIcon.Position = Vector2.Zero;
		   return false;
	   }
	   //GD.Print("GrappleCheck()");
	   
	  GodotObject grappleCollider = _grappleCast.GetCollider();
	  //Check for staticbody
	  //GD.Print(grappleCollider.ToString());
	  if (grappleCollider is Area2D)
	  { 
		  //GD.Print("Got Collider with ID: " + ((Area2D)grappleCollider).CollisionLayer);
		 if ( _grappleTarget != grappleCollider)
		 {
			_grappleIcon.GlobalPosition = ((Area2D)grappleCollider).GlobalPosition;
			
			_grappleIcon.Visible = true;
			if (!_playerGrappled)
			{
			   _grappleTarget = (Area2D)grappleCollider;
			}

			
		 }
	  }
	  return true;
   }

   
   
   public void CoyoteTimeout()
   {
	  _jumpAvailable = false;
   }

   private void JumpBufferTimeout()
   {
	  _jumpBuffer = false;
   }

   //private void DashCooldownTimeout()

   public Vector2 PlayerLook()
   {
	  return Input.GetVector("left", "right", "up", "down");
   }

   public void Death()
   {
	  //TODO Change signal to scene transition
	  GetNode<SignalBus>("/root/PlayerVariables").EmitSignal(SignalBus.SignalName.HealthChanged);
   }
   
   public override void _PhysicsProcess(double delta)
   {
	  _stateMachine.ProcessPhysics(delta);
	  GrappleCheck();
	  _grappleCast.LookAt((10*PlayerLook())+ Position);
	  MoveAndSlide();
   }

   public override void _Process(double delta)
   {
	  _stateMachine.ProcessFrame(delta);
   }

   public override void _UnhandledInput(InputEvent @event)
   {
	  _stateMachine.ProcessInput(@event);
   }
   
   
}
