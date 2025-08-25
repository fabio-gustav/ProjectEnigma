using Godot;
using System;
using System.Runtime.CompilerServices;


public partial class PauseMenu : Control
{

    private Control menus = null;
    //Local Variables for Buttons
    private Button _resume = null;
    private Button _options = null;
    private Button _returnToTitle = null;
    private Button _quitGame = null;

    private Button _optionsToMain = null; //back button
    private Button _soundSettings = null;
    private Button _visualSettings = null;
    private Button _controls = null;
    private Button _debug = null;


    //flags
    private bool opened = false;
    private int selection = 0;

    //traversal arrays
    private Button[] mainButtons = null;
    private Button[] optionsButtons = null;
    private Button[] activeButtons = null;


    public override void _Ready()
    {
        //main pause menu
        _resume = GetNode<Button>("%Resume");
        _options = GetNode<Button>("%Options");
        _returnToTitle = GetNode<Button>("%ReturnToTitle");
        _quitGame = GetNode<Button>("%QuitGame");

        //options menu
        _optionsToMain = GetNode<Button>("%optionsToMain");
        _soundSettings = GetNode<Button>("%soundSettings");
        _visualSettings = GetNode<Button>("%visualSettings");
        _controls = GetNode<Button>("%Controls");
        _debug = GetNode<Button>("%Debug");


        opened = false;
        selection = 0;

        mainButtons = [_resume, _options, _returnToTitle, _quitGame];
        optionsButtons = [_optionsToMain, _soundSettings, _visualSettings, _controls, _debug];

        activeButtons = mainButtons;

        base._Ready();
    }



    public override void _Process(double delta)
    {
        if (Input.IsActionJustPressed("pause"))
        {
            swap();
        }
        if (opened)
        {
            if (Input.IsActionJustPressed("up"))
            {
                Select(-1);
            }
            if (Input.IsActionJustPressed("down"))
            {
                Select(1);
            }
            if (Input.IsActionJustPressed("jump"))
            {//temporary button, change later
                activeButtons[selection].ButtonPressed = true;
            }
        }

        base._Process(delta);
    }


    //swaps whether or not game is paused
    private void swap()
    {
        opened = !opened;
        if (opened)
        {
            SubMenu(mainButtons);
            menus.Visible = true;
            GetTree().Paused = true;
        }
        else
        {
            menus.Visible = false;
            GetTree().Paused = false;
        }
    }

    //aids in selecteing buttons
    private void Select(int upOrDown)
    {
        if (selection == 0 && upOrDown == -1)
        {
            return;
        }
        if (selection == activeButtons.Length - 1 && upOrDown == 1)
        {
            return;
        }
        //need to add color selection
        selection += upOrDown;
        //need to add color selection
    }

    private void SubMenu(Button[] menu)
    {
        //need to add color selection
        selection = 0;
        foreach (Button b in activeButtons)
        {
            b.Hide();
        }
        activeButtons = menu;
        foreach (Button b in activeButtons)
        {
            b.Show();
        }
        //need to add color selection

    }



    //button functions
    private void Resume()
    {
        swap();
    }

    private void Options()
    {
        SubMenu(optionsButtons);
    }

    private void ReturnToTitle()
    {
        //do later
    }
    

    private void QuitGame()
    {
        GetTree().Quit();
    }

}
