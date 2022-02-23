pageextension 90100 "TTTEBS CustomerListExt" extends "Customer List"
{
    trigger OnOpenPage();
    begin
        Message('App published: Hello world');
    end;
}
