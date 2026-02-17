namespace Finjanz.Shell;

public class MainShell : Component
{
    public override VisualNode Render()
        => Shell(
                TabBar(
                    ShellContent("Home")
                        .Icon("dotnet_bot.png")
                        .RenderContent(() => new HomePage()),
                    ShellContent("Einstellungen")
                        .Icon("dotnet_bot.png")
                        .RenderContent(() => new SettingsPage())
                )
            )
            // This sets the top bar background color
            .Set(MauiControls.Shell.BackgroundColorProperty, ApplicationTheme.Primary)
            // This sets the Title text color to White (assuming Primary is dark)
            .Set(MauiControls.Shell.TitleColorProperty, ApplicationTheme.White);
    // // This sets the color of the back button and icons in the bar
    // .Set(MauiControls.Shell.ForegroundColorProperty, ApplicationTheme.White)
    // // Optional: Sets the color of the TabBar at the bottom
    // .Set(MauiControls.Shell.TabBarBackgroundColorProperty, ApplicationTheme.White)
    // .Set(MauiControls.Shell.TabBarTitleColorProperty, ApplicationTheme.Primary)
    // .Set(MauiControls.Shell.TabBarUnselectedColorProperty, ApplicationTheme.Gray500);
}