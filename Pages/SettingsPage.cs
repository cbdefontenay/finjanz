namespace Finjanz.Pages;

partial class SettingsPage : Component
{
    public override VisualNode Render()
        => ContentPage(
            ScrollView(
                    Label("Settings")
                )
                .Center()
        );
}