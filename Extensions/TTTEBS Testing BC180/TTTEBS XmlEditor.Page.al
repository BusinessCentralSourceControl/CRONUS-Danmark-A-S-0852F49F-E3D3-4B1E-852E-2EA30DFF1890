page 90004 "TTTEBS XmlEditor"
{
    PageType = Card;
    Caption = 'XML Editor';
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Editor1Group)
            {
                ShowCaption = false;

                usercontrol(Editor1;"TTTEBS AceEditor")
                {
                ApplicationArea = All;

                trigger ControlAddInReady()begin
                    EditorControlIsReady:=true;
                    InitEditor();
                end;
                trigger GetValueRequested(value: Text)begin
                    Editor1Value:=value;
                    case DemoType of // TTTEBS - Only OnPrem >>
                    // 'DotNet':
                    //     ReadBooksDotNet(value);
                    // TTTEBS - Only OnPrem <<
                    'AL': ReadBooksAL(value);
                    end end;
                }
            }
        }
        area(FactBoxes)
        {
            part(EditorModes;"TTTEBS AceEditorModes")
            {
                Caption = 'Modes';
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            part(EditorThemes;"TTTEBS AceEditorThemes")
            {
                Caption = 'Themes';
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(LoadFileAction)
            {
                Caption = 'Load file';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = '.';

                trigger OnAction()begin
                    LoadFile();
                end;
            }
            action(PrettifyXml)
            {
                Caption = 'Prettify XML';
                ApplicationArea = All;
                Image = XMLSetup;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Enabled = CurrentMode = CurrentMode::xml;
                ToolTip = '.';

                trigger OnAction()begin
                    CurrPage.Editor1.PrettifyXml();
                end;
            }
            action(InitXmlAction)
            {
                Caption = 'Init XML';
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = '.';
                Image = "8ball";

                trigger OnAction()begin
                    CurrPage.Editor1.SetValue(XmlDataLibrary.GetValidXml());
                end;
            }
            action(DemoActionDotNet)
            {
                Caption = 'Demo DotNet';
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = '.';
                Image = "8ball";

                trigger OnAction()begin
                    Editor1Value:='';
                    DemoType:='DotNet';
                    CurrPage.Editor1.GetValue();
                end;
            }
            action(DemoActionAL)
            {
                Caption = 'Demo AL';
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = '.';
                Image = "8ball";

                trigger OnAction()begin
                    Editor1Value:='';
                    DemoType:='AL';
                    CurrPage.Editor1.GetValue();
                end;
            }
            action(CreateXmlAction)
            {
                Caption = 'Create XML';
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = '.';
                Image = "8ball";

                trigger OnAction()begin
                    CreateXml();
                end;
            }
        }
    }
    var FileMgt: Codeunit "File Management";
    FileContent: Codeunit "Temp Blob";
    XmlDataLibrary: Codeunit "TTTEBS XmlDataLibrary";
    EditorControlIsReady, EditorControl2IsReady: Boolean;
    CurrentTheme: Enum "TTTEBS AceEditorTheme";
    CurrentMode: Enum "TTTEBS AceEditorMode";
    Editor1Value, Editor2Value: Text;
    DemoType: Text;
    // LoadFileCaptionTxt: Label 'Select a file';
    // FileFilterTxt: Label 'All Files (*.*)|*.*';
    // ExtFilterTxt: Label '';
    trigger OnAfterGetRecord()begin
        SetEditorMode();
        SetEditorTheme();
    end;
    local procedure InitEditor()var begin
        if not EditorControlIsReady then exit;
        CurrPage.Editor1.Init();
        CurrPage.Editor1.SetValue(XmlDataLibrary.GetValidXml());
        CurrPage.EditorModes.Page.SetMode(Enum::"TTTEBS AceEditorMode"::xml);
        SetEditorMode();
        CurrPage.EditorThemes.Page.SetTheme(Enum::"TTTEBS AceEditorTheme"::sqlserver);
        SetEditorTheme();
    end;
    // local procedure InitEditor2()
    // begin
    //     if not EditorControl2IsReady then
    //         exit;
    //     CurrPage.Editor2.Init();
    //     CurrPage.Editor2.SetMode('xml');
    //     CurrPage.Editor2.SetTheme('monokai');
    // end;
    local procedure SetEditorMode()var Mode: Enum "TTTEBS AceEditorMode";
    begin
        if not EditorControlIsReady then exit;
        Mode:=CurrPage.EditorModes.Page.GetSelectedMode();
        if Mode <> CurrentMode then begin
            CurrPage.Editor1.SetMode(Mode.Names.Get(Mode.Ordinals.IndexOf(Mode.AsInteger())));
            // CurrPage.Editor2.SetMode(Mode.Names.Get(Mode.Ordinals.IndexOf(Mode.AsInteger())));
            CurrentMode:=Mode;
        end;
    end;
    local procedure SetEditorTheme()var Theme: Enum "TTTEBS AceEditorTheme";
    begin
        if not EditorControlIsReady then exit;
        Theme:=CurrPage.EditorThemes.Page.GetSelectedTheme();
        if Theme <> CurrentTheme then begin
            CurrPage.Editor1.SetTheme(Theme.Names.Get(Theme.Ordinals.IndexOf(Theme.AsInteger())));
            // CurrPage.Editor2.SetTheme(Theme.Names.Get(Theme.Ordinals.IndexOf(Theme.AsInteger())));
            CurrentTheme:=Theme;
        end;
    end;
    local procedure LoadFile()var Filename: Text;
    Content: Text;
    Mode: Enum "TTTEBS AceEditorMode";
    // TempBlob: Codeunit "Temp Blob";
    // InStr: InStream;
    // InFile: File;
    begin
        Clear(FileContent);
        Filename:=FileMgt.BLOBImport(FileContent, '');
        if Filename <> '' then begin
            case FileMgt.GetExtension(Filename)of 'xml': Mode:=Mode::xml;
            'json': Mode:=Mode::json;
            'txt': Mode:=Mode::text;
            'js': Mode:=Mode::javascript;
            else
                Mode:=Mode::text;
            end;
            Content:=GetContent();
            CurrPage.EditorModes.Page.SetMode(Mode);
            SetEditorMode();
            CurrPage.Editor1.SetValue(Content);
        end;
    end;
    // TTTEBS >>
    // local procedure GetContent(InStr: InStream) Content: Text
    // var
    //     XmlDoc: XmlDocument;
    //     Declaration: XmlDeclaration;
    //     Line: Text;
    //     TxtBuilder: TextBuilder;
    // begin
    //     if not XmlDocument.ReadFrom(InStr, XmlDoc) then
    //         Message('Could not read XML');
    //     // InStr.Read(Line);
    //     while not InStr.EOS do begin
    //         InStr.ReadText(Line);
    //         TxtBuilder.AppendLine(Line);
    //     end;
    //     Content := TxtBuilder.ToText();
    //     XmlDocument.ReadFrom(Content, XmlDoc);
    //     Declaration := XmlDeclaration.create('1.0', 'UTF-8', 'yes');
    //     XmlDoc.SetDeclaration(Declaration);
    //     XmlDoc.WriteTo(Content);
    // end;
    // TTTEBS <<
    local procedure GetContent()Content: Text;
    var InStr: InStream;
    Line: Text;
    TxtBuilder: TextBuilder;
    xmldoc: XmlDocument;
    // TempBlob: Codeunit "Temp Blob";
    // OutStr: OutStream;
    // FileMgt: Codeunit "File Management";
    begin
        FileContent.CreateInStream(InStr);
        if not XmlDocument.ReadFrom(InStr, xmldoc)then begin
            FileContent.CreateInStream(InStr, TextEncoding::Windows);
            XmlDocument.ReadFrom(InStr, xmldoc);
            while not InStr.EOS do begin
                InStr.ReadText(Line);
                TxtBuilder.AppendLine(Line);
            end;
            Content:=TxtBuilder.ToText();
            XmlDocument.ReadFrom(Content, xmldoc);
        end;
        XmlDoc.WriteTo(Content);
    end;
    // TTTEBS - Only OnPrem >>
    // local procedure ReadBooksDotNet(xml: Text)
    // var
    //     TempBook: Record "TTTEBS BookPTE" temporary;
    //     DemoDotNetXml: Codeunit "TTTEBS DemoDotNetXmlPTE";  
    // begin
    //     Message('TTTEBS - DotNet - Only OnPrem!');
    //     DemoDotNetXml.ReadBooks(xml, TempBook);
    //     if not TempBook.IsEmpty then
    //         Page.Run(Page::"TTTEBS Books", TempBook);
    // end;
    // TTTEBS - Only OnPrem <<
    local procedure ReadBooksAL(xml: Text)var TempBook: Record "TTTEBS BookPTE" temporary;
    DemoALXml: Codeunit "TTTEBS DemoALXml";
    begin
        DemoALXml.ReadBooks(xml, TempBook);
        if not TempBook.IsEmpty then Page.Run(Page::"TTTEBS Books", TempBook);
    end;
    local procedure CreateXml()var SalesHeader: Record "Sales Header";
    DemoCreateXml: Codeunit "TTTEBS DemoCreateXml";
    Element: XmlElement;
    xml: Text;
    XmlDoc: XmlDocument;
    begin
        SalesHeader.FindFirst();
        Element:=DemoCreateXml.CreateXmlFromSalesHeader(SalesHeader);
        // Element.WriteTo(xml);
        XmlDoc.SetDeclaration(XmlDeclaration.Create('1.0', 'utf-8', 'yes'));
        XmlDoc.Add(Element);
        XmlDoc.WriteTo(xml);
        CurrPage.Editor1.SetValue(xml);
    end;
}
