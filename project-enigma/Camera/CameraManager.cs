using Godot;
using PhantomCamera;
using System;
using System.ComponentModel;
using System.Linq;

public partial class CameraManager : Node
{
    [Export] CharacterBody2D player;


    private int current_camera_zone = 0;

    void Update_camera()
    {
        var arr = GetTree().GetNodesInGroup("Cameras");
        int camNum = 0;
        foreach (Node node in arr)
        {
            if (node != null)
            {
                if (camNum == current_camera_zone)
                {
                    node.Call("set_priority", 1); // calls a GDScript method
                }
                else
                {
                    node.Call("set_priority", 0); // calls a GDScript method
                }
                camNum++;
            }
        }
        GD.Print(current_camera_zone);
    }

    void Update_current_zone(CharacterBody2D body, int zone_a, int zone_b)
    {
        if (body.GetPath() == player.GetPath())
        {
            if (current_camera_zone == zone_a)
            {
                current_camera_zone = zone_b;
            }
            else if (current_camera_zone == zone_b)
            {
                current_camera_zone = zone_a;
            }
            Update_camera();
        }
    }

    public void OnZone01BodyEntered(CharacterBody2D body)
    {
        Update_current_zone(body, 0, 1);
    }
    public void OnZone12BodyEntered(CharacterBody2D body)
    {
        Update_current_zone(body, 1, 2);
    }
}
