unit NvNxsRoutines;

interface

uses Graphics, Windows;

procedure DrawNextFrame(Canvas: TCanvas; Rec: TRect; Up: Boolean; High, Shad1, Shad2, Face: TColor);

implementation

procedure DrawNextFrame(Canvas: TCanvas; Rec: TRect; Up: Boolean; High, Shad1, Shad2, Face: TColor);
begin
  with Canvas do
    begin
      Brush.Color := Face;
      FillRect(Rec);
      if Up then
         begin
           Pen.Color := High;
           MoveTo(Rec.Left, Rec.Bottom-1);
           LineTo(Rec.Left, Rec.Top);
           LineTo(Rec.Right, Rec.Top);
           Pen.Color := Shad2;
           MoveTo(Rec.Left, Rec.Bottom);
           LineTo(Rec.Right, Rec.Bottom);
           LineTo(Rec.Right, Rec.Top-1);
           Pen.Color := Shad1;
           MoveTo(Rec.Left+1, Rec.Bottom-1);
           LineTo(Rec.Right-1, Rec.Bottom-1);
           LineTo(Rec.Right-1, Rec.Top);
         end
       else
         begin
           Pen.Color := Shad2;
           MoveTo(Rec.Left, Rec.Bottom-1);
           LineTo(Rec.Left, Rec.Top);
           LineTo(Rec.Right, Rec.Top);
           Pen.Color := High;
           MoveTo(Rec.Left, Rec.Bottom);
           LineTo(Rec.Right, Rec.Bottom);
           LineTo(Rec.Right, Rec.Top-1);
           Pen.Color := Shad1;
           MoveTo(Rec.Left+1, Rec.Bottom-2);
           LineTo(Rec.Left+1, Rec.Top+1);
           LineTo(Rec.Right, Rec.Top+1);
         end
     end;
end;

end.
