controladdin "TTTEBS AceEditor"
{
    Scripts = 'src/xml/ControlAddins/AceEditor/startup.js', 'src/xml/ControlAddins/AceEditor/script.js', 'https://pagecdn.io/lib/ace/1.4.12/ace.min.js';
    StyleSheets = 'src/xml/ControlAddins/AceEditor/stylesheet.css';
    MinimumWidth = 100;
    RequestedWidth = 300;
    HorizontalStretch = true;
    VerticalStretch = true;
    VerticalShrink = true;
    RequestedHeight = 370;

    event ControlAddInReady();
    event GetValueRequested(value: Text);
    procedure Init();
    procedure SetTheme(theme: Text);
    procedure SetMode(mode: Text);
    procedure SetValue(value: Text);
    procedure GetValue();
    procedure SetReadOnly(readOnly: Boolean);
    procedure PrettifyXml();
}
