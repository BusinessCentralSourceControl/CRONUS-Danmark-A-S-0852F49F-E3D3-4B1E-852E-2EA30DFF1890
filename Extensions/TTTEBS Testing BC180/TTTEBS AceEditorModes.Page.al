page 50002 "TTTEBS AceEditorModes"
{
    PageType = ListPart;
    SourceTable = Integer;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(modes)
            {
                field(Name;Format(Enum::"TTTEBS AceEditorMode".FromInteger(Rec.Number)))
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Style = Strong;
                    StyleExpr = IsCurrentMode;
                    Caption = 'Name';
                    ToolTip = '.';

                    trigger OnDrillDown()begin
                        CurrentMode:=Enum::"TTTEBS AceEditorMode".FromInteger(Rec.Number);
                        CurrPage.Update();
                    end;
                }
            }
        }
    }
    var CurrentMode: Enum "TTTEBS AceEditorMode";
    IsCurrentMode: Boolean;
    trigger OnInit()begin
        Rec.SetRange(Number, 1, Enum::"TTTEBS AceEditorMode".Names().Count);
    end;
    trigger OnAfterGetRecord()begin
        IsCurrentMode:=Enum::"TTTEBS AceEditorMode".FromInteger(Rec.Number) = CurrentMode;
    end;
    trigger OnAfterGetCurrRecord()begin
        IsCurrentMode:=Enum::"TTTEBS AceEditorMode".FromInteger(Rec.Number) = CurrentMode;
    end;
    procedure GetSelectedMode(): Enum "TTTEBS AceEditorMode";
    begin
        exit(CurrentMode);
    end;
    procedure SetMode(Mode: Enum "TTTEBS AceEditorMode")begin
        CurrentMode:=Mode;
        Rec.Get(Mode.AsInteger());
        CurrPage.Update(false);
    end;
}
