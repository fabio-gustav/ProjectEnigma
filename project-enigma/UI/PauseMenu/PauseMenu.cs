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

    private Control activeMenu = null;
    private Control mainMenu = null;
    private Control optionsMenu = null;

    public override void _Ready()
    {
        //main pause menu
        _resume = GetNode<Button>("Menus/MainPause/Resume");
        _options = GetNode<Button>("Menus/MainPause/Options");
        _returnToTitle = GetNode<Button>("Menus/MainPause/ReturnToTitle");
        _quitGame = GetNode<Button>("Menus/MainPause/QuitGame");

        //options menu
        _optionsToMain = GetNode<Button>("Menus/OptionsMenu/optionsToMain");
        _soundSettings = GetNode<Button>("Menus/OptionsMenu/SoundSettings");
        _visualSettings = GetNode<Button>("Menus/OptionsMenu/VisualSettings");
        _controls = GetNode<Button>("Menus/OptionsMenu/Controls");
        _debug = GetNode<Button>("Menus/OptionsMenu/Debug");

        opened = false;
        selection = 0;

        mainButtons = [_resume, _options, _returnToTitle, _quitGame];
        optionsButtons = [_optionsToMain, _soundSettings, _visualSettings, _controls, _debug];
        activeButtons = mainButtons;

        menus = GetNode<Control>("Menus");
        base._Ready();
    }

    //I implemented this function stupidly, maybe fix later if it matters
    public override void _Input(InputEvent @event)
    {
        if (Input.IsActionPressed("pause"))
        {
            Swap();
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
            {
                activeButtons[selection].EmitSignal("pressed");
            }
        }
        base._Input(@event);
    }


    //Swaps whether or not game is paused
    private void Swap()
    {
        opened = !opened;
        if (opened)
        {
            SubMenu(mainButtons);
            menus.Show();
            GetTree().Paused = true;
        }
        else
        {
            menus.Hide();
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
        activeButtons[selection].AddThemeColorOverride("font_color", new Color(1, 1, 1));
        selection += upOrDown;
        activeButtons[selection].AddThemeColorOverride("font_color", new Color(1, 1, 0));
    }

    private void SubMenu(Button[] menu)
    {
        activeButtons[selection].AddThemeColorOverride("font_color", new Color(1, 1, 1));
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
        activeButtons[selection].AddThemeColorOverride("font_color", new Color(1, 1, 0));

    }



    //button functions
    private void Resume()
    {
        Swap();
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

    //options menu functions
    private void OptionsToMain()
    {
        SubMenu(mainButtons);
    }
    

}
