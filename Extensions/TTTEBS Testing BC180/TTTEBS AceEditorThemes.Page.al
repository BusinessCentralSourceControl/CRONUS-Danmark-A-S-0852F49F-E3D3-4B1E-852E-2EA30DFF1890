page 50003 "TTTEBS AceEditorThemes"
{
    PageType = ListPart;
    SourceTable = Integer;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(themes)
            {
                field(Name;Format(Enum::"TTTEBS AceEditorTheme".FromInteger(Rec.Number)))
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Style = Strong;
                    StyleExpr = IsCurrentTheme;
                    Caption = 'Name';
                    ToolTip = '.';

                    trigger OnDrillDown()begin
                        CurrentTheme:=Enum::"TTTEBS AceEditorTheme".FromInteger(Rec.Number);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
    var CurrentTheme: Enum "TTTEBS AceEditorTheme";
    IsCurrentTheme: Boolean;
    trigger OnInit()begin
        Rec.SetRange(Number, 1, Enum::"TTTEBS AceEditorTheme".Names().Count);
    end;
    trigger OnAfterGetRecord()begin
        IsCurrentTheme:=Enum::"TTTEBS AceEditorTheme".FromInteger(Rec.Number) = CurrentTheme;
    end;
    trigger OnAfterGetCurrRecord()begin
        IsCurrentTheme:=Enum::"TTTEBS AceEditorTheme".FromInteger(Rec.Number) = CurrentTheme;
    end;
    procedure GetSelectedTheme(): Enum "TTTEBS AceEditorTheme" begin
        exit(CurrentTheme);
    end;
    procedure SetTheme(Theme: Enum "TTTEBS AceEditorTheme")begin
        CurrentTheme:=Theme;
        Rec.Get(Theme.AsInteger());
        CurrPage.Update(false);
    end;
}
