page 90000 "TTTEBS Books"
{
    PageType = List;
    SourceTable = "TTTEBS BookPTE";
    SourceTableTemporary = true;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(Number;Rec.Number)
                {
                    ApplicationArea = All;
                    ToolTip = '.';
                }
                field(Title;Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = '.';
                }
                field(Author;Rec.Author)
                {
                    ApplicationArea = All;
                    ToolTip = '.';
                }
                field(ISBN;Rec.ISBN)
                {
                    ApplicationArea = All;
                    ToolTip = '.';
                }
                field(Price;Rec.Price)
                {
                    ApplicationArea = All;
                    ToolTip = '.';
                }
            }
        }
    }
}
