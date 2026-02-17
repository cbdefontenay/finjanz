namespace Finjanz.Resources.Styles;

class ApplicationTheme : Theme
{
    public static Color Primary { get; } = Color.FromRgba(142, 107, 245, 255); // #8E6BF5
    public static Color PrimaryDark { get; } = Color.FromRgba(188, 170, 249, 255); // #BCAAF9
    public static Color PrimaryDarkText { get; } = Color.FromRgba(26, 20, 46, 255);
    public static Color Secondary { get; } = Color.FromRgba(85, 146, 229, 255); // #5592E5
    public static Color SecondaryDarkText { get; } = Color.FromRgba(212, 226, 248, 255);
    public static Color Tertiary { get; } = Color.FromRgba(193, 125, 149, 255); // #C17D95
    public static Color Error { get; } = Color.FromRgba(255, 84, 73, 255); // #FF5449

    public static Color White { get; } = Colors.White;
    public static Color Black { get; } = Colors.Black;
    public static Color Magenta { get; } = Color.FromRgba(193, 125, 149, 255);
    public static Color MidnightBlue { get; } = Color.FromRgba(20, 24, 45, 255);
    public static Color OffBlack { get; } = Color.FromRgba(25, 25, 25, 255);
    public static Color OffWhite { get; } = Color.FromRgba(248, 247, 255, 255);

    public static Color Gray100 { get; } = Color.FromRgba(238, 238, 242, 255);
    public static Color Gray200 { get; } = Color.FromRgba(220, 220, 228, 255);
    public static Color Gray300 { get; } = Color.FromRgba(180, 180, 190, 255);
    public static Color Gray400 { get; } = Color.FromRgba(140, 140, 155, 255);
    public static Color Gray500 { get; } = Color.FromRgba(100, 100, 115, 255);
    public static Color Gray600 { get; } = Color.FromRgba(60, 60, 75, 255);
    public static Color Gray900 { get; } = Color.FromRgba(30, 30, 35, 255);
    public static Color Gray950 { get; } = Color.FromRgba(15, 15, 20, 255);

    protected override void OnApply()
    {
        ActivityIndicatorStyles.Default = _ =>
            _.Color(IsLightTheme ? Primary : PrimaryDark);

        IndicatorViewStyles.Default = _ => _
            .IndicatorColor(IsLightTheme ? Gray200 : Gray600)
            .SelectedIndicatorColor(IsLightTheme ? Primary : PrimaryDark);

        BorderStyles.Default = _ => _
            .Stroke(IsLightTheme ? Gray200 : Gray600)
            .StrokeShape(new Rectangle())
            .StrokeThickness(1);

        BoxViewStyles.Default = _ => _
            .BackgroundColor(IsLightTheme ? Gray950 : Gray200);

        ButtonStyles.Default = _ => _
            .TextColor(IsLightTheme ? White : PrimaryDarkText)
            .BackgroundColor(IsLightTheme ? Primary : PrimaryDark)
            .FontFamily("OpenSansRegular")
            .FontSize(14)
            .BorderWidth(0)
            .CornerRadius(8)
            .Padding(14, 10)
            .MinimumHeightRequest(44)
            .MinimumWidthRequest(44)
            .VisualState("CommonStates", "Disable", MauiControls.Button.TextColorProperty,
                IsLightTheme ? Gray400 : Gray500)
            .VisualState("CommonStates", "Disable", MauiControls.Button.BackgroundColorProperty,
                IsLightTheme ? Gray200 : Gray600);

        CheckBoxStyles.Default = _ => _
            .Color(IsLightTheme ? Primary : PrimaryDark)
            .MinimumHeightRequest(44)
            .MinimumWidthRequest(44)
            .VisualState("CommonStates", "Disable", MauiControls.CheckBox.ColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        DatePickerStyles.Default = _ => _
            .TextColor(IsLightTheme ? Gray900 : White)
            .BackgroundColor(Colors.Transparent)
            .FontFamily("OpenSansRegular")
            .FontSize(14)
            .MinimumHeightRequest(44)
            .MinimumWidthRequest(44)
            .VisualState("CommonStates", "Disable", MauiControls.DatePicker.TextColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        EditorStyles.Default = _ => _
            .TextColor(IsLightTheme ? Black : White)
            .BackgroundColor(Colors.Transparent)
            .FontFamily("OpenSansRegular")
            .FontSize(14)
            .PlaceholderColor(IsLightTheme ? Gray300 : Gray500)
            .MinimumHeightRequest(44)
            .MinimumWidthRequest(44)
            .VisualState("CommonStates", "Disable", MauiControls.Editor.TextColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        EntryStyles.Default = _ => _
            .TextColor(IsLightTheme ? Black : White)
            .BackgroundColor(Colors.Transparent)
            .FontFamily("OpenSansRegular")
            .FontSize(14)
            .PlaceholderColor(IsLightTheme ? Gray300 : Gray500)
            .MinimumHeightRequest(44)
            .MinimumWidthRequest(44)
            .VisualState("CommonStates", "Disable", MauiControls.Entry.TextColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        ImageButtonStyles.Default = _ => _
            .Opacity(1)
            .BorderColor(Colors.Transparent)
            .BorderWidth(0)
            .CornerRadius(0)
            .MinimumHeightRequest(44)
            .MinimumWidthRequest(44)
            .VisualState("CommonStates", "Disable", MauiControls.ImageButton.OpacityProperty, 0.5);

        LabelStyles.Default = _ => _
            .TextColor(IsLightTheme ? Black : White)
            .BackgroundColor(Colors.Transparent)
            .FontFamily("OpenSansRegular")
            .FontSize(14)
            .VisualState("CommonStates", "Disable", MauiControls.Label.TextColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        LabelStyles.Themes["Headline"] = _ => _
            .TextColor(IsLightTheme ? MidnightBlue : White)
            .FontSize(32)
            .HorizontalOptions(MauiControls.LayoutOptions.Center)
            .HorizontalTextAlignment(TextAlignment.Center);

        LabelStyles.Themes["SubHeadline"] = _ => _
            .TextColor(IsLightTheme ? MidnightBlue : White)
            .FontSize(24)
            .HorizontalOptions(MauiControls.LayoutOptions.Center)
            .HorizontalTextAlignment(TextAlignment.Center);

        PickerStyles.Default = _ => _
            .TextColor(IsLightTheme ? Gray900 : White)
            .TitleColor(IsLightTheme ? Gray900 : Gray200)
            .BackgroundColor(Colors.Transparent)
            .FontFamily("OpenSansRegular")
            .FontSize(14)
            .MinimumHeightRequest(44)
            .MinimumWidthRequest(44)
            .VisualState("CommonStates", "Disable", MauiControls.Picker.TextColorProperty,
                IsLightTheme ? Gray300 : Gray600)
            .VisualState("CommonStates", "Disable", MauiControls.Picker.TitleColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        ProgressBarStyles.Default = _ => _
            .ProgressColor(IsLightTheme ? Primary : PrimaryDark)
            .VisualState("CommonStates", "Disable", MauiControls.ProgressBar.ProgressColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        RadioButtonStyles.Default = _ => _
            .BackgroundColor(Colors.Transparent)
            .TextColor(IsLightTheme ? Black : White)
            .FontFamily("OpenSansRegular")
            .FontSize(14)
            .MinimumHeightRequest(44)
            .MinimumWidthRequest(44)
            .VisualState("CommonStates", "Disable", MauiControls.RadioButton.TextColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        RefreshViewStyles.Default = _ => _
            .RefreshColor(IsLightTheme ? Primary : PrimaryDark);

        SearchBarStyles.Default = _ => _
            .TextColor(IsLightTheme ? Gray900 : White)
            .PlaceholderColor(Gray500)
            .CancelButtonColor(Gray500)
            .BackgroundColor(Colors.Transparent)
            .FontFamily("OpenSansRegular")
            .FontSize(14)
            .MinimumHeightRequest(44)
            .MinimumWidthRequest(44)
            .VisualState("CommonStates", "Disable", MauiControls.SearchBar.TextColorProperty,
                IsLightTheme ? Gray300 : Gray600)
            .VisualState("CommonStates", "Disable", MauiControls.SearchBar.PlaceholderColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        ShadowStyles.Default = _ => _
            .Radius(15)
            .Opacity(0.3f)
            .Brush(IsLightTheme ? Black : White)
            .Offset(new Point(5, 5));

        SliderStyles.Default = _ => _
            .MinimumTrackColor(IsLightTheme ? Primary : PrimaryDark)
            .MaximumTrackColor(IsLightTheme ? Gray200 : Gray600)
            .ThumbColor(IsLightTheme ? Primary : PrimaryDark)
            .VisualState("CommonStates", "Disable", MauiControls.Slider.MinimumTrackColorProperty,
                IsLightTheme ? Gray300 : Gray600)
            .VisualState("CommonStates", "Disable", MauiControls.Slider.MaximumTrackColorProperty,
                IsLightTheme ? Gray300 : Gray600)
            .VisualState("CommonStates", "Disable", MauiControls.Slider.ThumbColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        SwipeItemStyles.Default = _ => _
            .BackgroundColor(IsLightTheme ? White : Black);

        SwitchStyles.Default = _ => _
            .OnColor(IsLightTheme ? Primary : PrimaryDark)
            .ThumbColor(White)
            .VisualState("CommonStates", "Disable", MauiControls.Switch.OnColorProperty,
                IsLightTheme ? Gray300 : Gray600)
            .VisualState("CommonStates", "Disable", MauiControls.Switch.ThumbColorProperty,
                IsLightTheme ? Gray300 : Gray600)
            .VisualState("CommonStates", "On", MauiControls.Switch.OnColorProperty, IsLightTheme ? Secondary : Gray600)
            .VisualState("CommonStates", "On", MauiControls.Switch.ThumbColorProperty,
                IsLightTheme ? Primary : PrimaryDark)
            .VisualState("CommonStates", "Off", MauiControls.Switch.ThumbColorProperty,
                IsLightTheme ? Gray400 : Gray500);

        TimePickerStyles.Default = _ => _
            .TextColor(IsLightTheme ? Gray900 : White)
            .BackgroundColor(Colors.Transparent)
            .FontFamily("OpenSansRegular")
            .FontSize(14)
            .MinimumHeightRequest(44)
            .MinimumWidthRequest(44)
            .VisualState("CommonStates", "Disable", MauiControls.TimePicker.TextColorProperty,
                IsLightTheme ? Gray300 : Gray600);

        TitleBarStyles.Default = _ => _
            .MinimumHeightRequest(32)
            .VisualState("TitleActiveStates", "TitleBarTitleActive", MauiControls.TitleBar.BackgroundColorProperty,
                Colors.Transparent)
            .VisualState("TitleActiveStates", "TitleBarTitleActive", MauiControls.TitleBar.ForegroundColorProperty,
                IsLightTheme ? Black : White)
            .VisualState("TitleActiveStates", "TitleBarTitleInactive", MauiControls.TitleBar.BackgroundColorProperty,
                IsLightTheme ? White : Black)
            .VisualState("TitleActiveStates", "TitleBarTitleInactive", MauiControls.TitleBar.ForegroundColorProperty,
                IsLightTheme ? Gray400 : Gray500);

        PageStyles.Default = _ => _
            .Padding(0)
            .BackgroundColor(IsLightTheme ? OffWhite : OffBlack);

        ShellStyles.Default = _ => _
            .Set(MauiControls.Shell.BackgroundColorProperty, IsLightTheme ? OffWhite : OffBlack)
            .Set(MauiControls.Shell.ForegroundColorProperty, IsLightTheme ? Black : SecondaryDarkText)
            .Set(MauiControls.Shell.TitleColorProperty, IsLightTheme ? Black : SecondaryDarkText)
            .Set(MauiControls.Shell.DisabledColorProperty, IsLightTheme ? Gray200 : Gray950)
            .Set(MauiControls.Shell.UnselectedColorProperty, IsLightTheme ? Gray400 : Gray300)
            .Set(MauiControls.Shell.NavBarHasShadowProperty, false)
            .Set(MauiControls.Shell.TabBarBackgroundColorProperty, IsLightTheme ? White : Black)
            .Set(MauiControls.Shell.TabBarForegroundColorProperty, IsLightTheme ? Primary : Secondary)
            .Set(MauiControls.Shell.TabBarTitleColorProperty, IsLightTheme ? Primary : Secondary)
            .Set(MauiControls.Shell.TabBarUnselectedColorProperty, IsLightTheme ? Gray500 : Gray400);

        NavigationPageStyles.Default = _ => _
            .Set(MauiControls.NavigationPage.BarBackgroundColorProperty, IsLightTheme ? OffWhite : OffBlack)
            .Set(MauiControls.NavigationPage.BarTextColorProperty, IsLightTheme ? Gray900 : White)
            .Set(MauiControls.NavigationPage.IconColorProperty, IsLightTheme ? Primary : PrimaryDark);

        TabbedPageStyles.Default = _ => _
            .Set(MauiControls.TabbedPage.BarBackgroundColorProperty, IsLightTheme ? White : Gray950)
            .Set(MauiControls.TabbedPage.BarTextColorProperty, IsLightTheme ? Primary : White)
            .Set(MauiControls.TabbedPage.UnselectedTabColorProperty, IsLightTheme ? Gray400 : Gray600)
            .Set(MauiControls.TabbedPage.SelectedTabColorProperty, IsLightTheme ? Primary : PrimaryDark);
    }
}