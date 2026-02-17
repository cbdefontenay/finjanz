using System.Linq;
using CommunityToolkit.Maui.Behaviors;
using CommunityToolkit.Maui.Core;

namespace Finjanz.Pages;

partial class HomePage : Component<HomeState>
{
    public override VisualNode Render()
        => ContentPage( "Finjanz",
                ScrollView(
                    VStack(
                            Label("Cyprien!!!")
                        )
                        .VCenter()
                        .Spacing(25)
                )
            )
            .OnAppearing((sender, args) =>
                {
                    var page = (MauiControls.Page)sender!;
                    if (!page.Behaviors.OfType<StatusBarBehavior>().Any())
                    {
                        page.Behaviors.Add(new StatusBarBehavior
                            {
                                StatusBarColor = ApplicationTheme.Primary,
                                StatusBarStyle = StatusBarStyle.Default
                            }
                        );
                    }
                }
            ).Set(MauiControls.Shell.NavBarIsVisibleProperty, true);
}