unit FormDesigner.DragHandles;

interface

uses Classes, Controls, Graphics, Windows, Messages, Forms, SysUtils, StdCtrls,
  RTTI, System.Types, System.Generics.Collections, FormDesigner.Interfaces,
  FormDesigner.Utils;

type

  /// Base class for drag handles
  TDragHandle = class(TCustomControl)
  protected
    FClickOrigin: TPoint;
    FHorizontalFix: TDirection;
    FVerticalFix: TDirection;
    FFormDesigner: IFormDesigner;
    FSize: Byte;
    FBorderColor: TColor;
    function GetRectSide(const Rect: TRect; Direction: TDirection) : Integer;
    procedure SetSize(const Value: Byte);
  public
    property Color;
    property BorderColor : TColor read FBorderColor write FBorderColor;
    property FormDesigner: IFormDesigner read FFormDesigner write FFormDesigner;
    property Size: Byte read FSize write SetSize;
    procedure UpdateChildSize(Sender: TControl; X, Y: Integer); virtual; abstract;
    procedure SetSizingOrigin(const X, Y: Integer);
    procedure UpdatePosition(Control: TControl); virtual; abstract;
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
  end;

  THorizontalDragHandle = class(TDragHandle)
    procedure UpdateChildSize(Sender: TControl; X, Y: Integer); override;
  end;

  TVerticalDragHandle = class(TDragHandle)
    procedure UpdateChildSize(Sender: TControl; X, Y: Integer); override;
  end;

  TMultiDirectionalDragHandle = class(TDragHandle)
    procedure UpdateChildSize(Sender: TControl; X, Y: Integer); override;
  end;

  TUpDragHandle = class(TVerticalDragHandle)
  public
    procedure UpdatePosition(Control: TControl); override;
    constructor Create(AOwner: TComponent); override;
  end;

  TDownDragHandle = class(TVerticalDragHandle)
  public
    procedure UpdatePosition(Control: TControl); override;
    constructor Create(AOwner: TComponent); override;
  end;

  TLeftDragHandle = class(THorizontalDragHandle)
  public
    procedure UpdatePosition(Control: TControl); override;
    constructor Create(AOwner: TComponent); override;
  end;

  TRightDragHandle = class(THorizontalDragHandle)
  public
    procedure UpdatePosition(Control: TControl); override;
    constructor Create(AOwner: TComponent); override;
  end;

  TUpLeftDragHandle = class(TMultiDirectionalDragHandle)
  public
    procedure UpdatePosition(Control: TControl); override;
    constructor Create(AOwner: TComponent); override;
  end;

  TUpRightDragHandle = class(TMultiDirectionalDragHandle)
  public
    procedure UpdatePosition(Control: TControl); override;
    constructor Create(AOwner: TComponent); override;
  end;

  TDownLeftDragHandle = class(TMultiDirectionalDragHandle)
  public
    procedure UpdatePosition(Control: TControl); override;
    constructor Create(AOwner: TComponent); override;
  end;

  TDownRightDragHandle = class(TMultiDirectionalDragHandle)
  public
    procedure UpdatePosition(Control: TControl); override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TDragHandle.Create;
begin
  inherited Create(AOwner);
  Visible := False;
  FClickOrigin := TPoint.Zero;
  FBorderColor := RGB(0, 120, 215);
end;

procedure TDragHandle.SetSize(const Value: Byte);
begin
  FSize := Value;
  Width := Value;
  Height := Value;
end;

procedure TDragHandle.SetSizingOrigin(const X, Y: Integer);
var
  HalfWidth: Integer;
begin
  inherited;
  HalfWidth := Width div 2;
  if (X <> HalfWidth) then
  begin
    if (X > HalfWidth) then
      FClickOrigin.X := -(X mod HalfWidth)
    else
      FClickOrigin.X := HalfWidth - X;
  end;

  if (Y <> HalfWidth) then
  begin
    if (Y > HalfWidth) then
      FClickOrigin.Y := -(Y mod HalfWidth)
    else
      FClickOrigin.Y := HalfWidth - Y;
  end;
end;

procedure TDragHandle.Paint;
begin
  inherited;
  Canvas.Pen.Color := FBorderColor;
  Canvas.FillRect(ClientRect);
  Canvas.Brush.Color := Color;
  Canvas.Rectangle(0, 0, BoundsRect.Width, BoundsRect.Height);
end;

constructor TUpDragHandle.Create;
begin
  inherited Create(AOwner);
  Cursor := crSizeNS;
  FVerticalFix := dBottom;
end;

constructor TDownDragHandle.Create;
begin
  inherited Create(AOwner);
  Cursor := crSizeNS;
  FVerticalFix := dTop;
end;

constructor TLeftDragHandle.Create;
begin
  inherited Create(AOwner);
  Cursor := crSizeWE;
  FHorizontalFix := dRight;
end;

constructor TRightDragHandle.Create;
begin
  inherited Create(AOwner);
  Cursor := crSizeWE;
  FHorizontalFix := dLeft;
end;

constructor TUpLeftDragHandle.Create;
begin
  inherited Create(AOwner);
  Cursor := crSizeNWSE;
  FHorizontalFix := dRight;
  FVerticalFix := dBottom;
end;

constructor TUpRightDragHandle.Create;
begin
  inherited Create(AOwner);
  Cursor := crSizeNESW;
  FHorizontalFix := dLeft;
  FVerticalFix := dBottom;
end;

constructor TDownLeftDragHandle.Create;
begin
  inherited Create(AOwner);
  Cursor := crSizeNESW;
  FHorizontalFix := dRight;
  FVerticalFix := dTop;
end;

constructor TDownRightDragHandle.Create;
begin
  inherited Create(AOwner);
  Cursor := crSizeNWSE;
  FHorizontalFix := dLeft;
  FVerticalFix := dTop;
end;

procedure TUpDragHandle.UpdatePosition(Control: TControl);
begin
  Left := Control.Left + ((Control.Width - Width) div 2);
  Top := Control.Top - (Height div 2);
end;

procedure TDownDragHandle.UpdatePosition(Control: TControl);
begin
  Left := Control.Left + ((Control.Width - Width) div 2);
  Top := Control.Top + Control.Height - (Height div 2);
end;

procedure TLeftDragHandle.UpdatePosition(Control: TControl);
begin
  Left := Control.Left - (Width div 2);
  Top := Control.Top + ((Control.Height - Height) div 2);
end;

procedure TRightDragHandle.UpdatePosition(Control: TControl);
begin
  Left := Control.Left + Control.Width - (Width div 2);
  Top := Control.Top + ((Control.Height - Height) div 2);
end;

procedure TUpLeftDragHandle.UpdatePosition(Control: TControl);
begin
  Left := Control.Left - (Width div 2);
  Top := Control.Top - (Height div 2);
end;

procedure TDownLeftDragHandle.UpdatePosition(Control: TControl);
begin
  Left := Control.Left - (Width div 2);
  Top := Control.Top + Control.Height - (Height div 2);
end;

procedure TUpRightDragHandle.UpdatePosition(Control: TControl);
begin
  Left := Control.BoundsRect.Right - (Width div 2);
  Top := Control.Top - (Height div 2);
end;

procedure TDownRightDragHandle.UpdatePosition(Control: TControl);
begin
  Left := Control.BoundsRect.Right - (Width div 2);
  Top := Control.Top + Control.Height - (Height div 2);
end;

procedure TVerticalDragHandle.UpdateChildSize(Sender: TControl; X, Y: Integer);
var
  DragRect: TRect;
  ChildRect: TRect;
  VerticalFix: Integer;
begin
  DragRect := FFormDesigner.GetDragRect();
  ChildRect := FFormDesigner.GetChildRect();
  VerticalFix := GetRectSide(ChildRect, FVerticalFix);
  with DragRect do
  begin
    if (Y <> Top) and (Y <> Bottom) then
    begin
      if Y >= VerticalFix then
      begin
        Top := VerticalFix;
        Bottom := Y + FClickOrigin.Y;
        FFormDesigner.UpdateDragRect(DragRect, [dBottom]);
      end
      else
      begin
        Top := Y + FClickOrigin.Y;
        Bottom := VerticalFix;
        FFormDesigner.UpdateDragRect(DragRect, [dTop]);
      end;
    end;
  end;
end;

procedure THorizontalDragHandle.UpdateChildSize(Sender: TControl; X: Integer; Y: Integer);
var
  DragRect: TRect;
  ChildRect: TRect;
  HorizontalFix: Integer;
begin
  DragRect := FFormDesigner.GetDragRect();
  ChildRect := FFormDesigner.GetChildRect();
  HorizontalFix := GetRectSide(ChildRect, FHorizontalFix);
  with DragRect do
  begin
    if (X <> Right) and (X <> Left) then
    begin
      if X > HorizontalFix then
      begin
        Left := HorizontalFix;
        Right := X + FClickOrigin.X;
        FFormDesigner.UpdateDragRect(DragRect, [dRight]);
      end
      else
      begin
        Left := X + FClickOrigin.X;
        Right := HorizontalFix;
        FFormDesigner.UpdateDragRect(DragRect, [dLeft]);
      end;
    end;
  end;
end;

procedure TMultiDirectionalDragHandle.UpdateChildSize(Sender: TControl; X, Y: Integer);
var
  DragRect: TRect;
  ChildRect: TRect;
  HorizontalFix, VerticalFix: Integer;
begin
  DragRect := FFormDesigner.GetDragRect();
  ChildRect := FFormDesigner.GetChildRect();
  HorizontalFix := GetRectSide(ChildRect, FHorizontalFix);
  VerticalFix := GetRectSide(ChildRect, FVerticalFix);
  with DragRect do
  begin
    if (X > HorizontalFix) and (Y > VerticalFix) then
    begin
      Left := HorizontalFix;
      Top := VerticalFix;
      Right := X + FClickOrigin.X;
      Bottom := Y + FClickOrigin.Y;
      FFormDesigner.UpdateDragRect(DragRect, [dRight, dBottom]);
    end;
    if (X < HorizontalFix) and (Y > VerticalFix) then
    begin
      Left := X + FClickOrigin.X;
      Top := VerticalFix;
      Right := HorizontalFix;
      Bottom := Y + FClickOrigin.Y;
      FFormDesigner.UpdateDragRect(DragRect, [dLeft, dBottom]);
    end;
    if (X > HorizontalFix) and (Y < VerticalFix) then
    begin
      Left := HorizontalFix;
      Top := Y + FClickOrigin.Y;
      Right := X + FClickOrigin.X;
      Bottom := VerticalFix;
      FFormDesigner.UpdateDragRect(DragRect, [dRight, dTop]);
    end;
    if (X < HorizontalFix) and (Y < VerticalFix) then
    begin
      Left := X + FClickOrigin.X;
      Top := Y + FClickOrigin.Y;
      Right := HorizontalFix;
      Bottom := VerticalFix;
      FFormDesigner.UpdateDragRect(DragRect, [dLeft, dTop]);
    end;
  end;
end;

function TDragHandle.GetRectSide(const Rect: TRect; Direction: TDirection): Integer;
var
  RectType: TRttiType;
  Field: TRttiField;
  DirectionStr: String;
begin
  DirectionStr := TRttiEnumerationType.GetName(Direction);
  Assert(DirectionStr.StartsWith('d'));
  DirectionStr := DirectionStr.Remove(0, 1);
  RectType := TRTTIContext.Create.GetType(TypeInfo(TRect));
  Field := RectType.GetField(DirectionStr);
  Result := Field.GetValue(@Rect).AsInteger;
end;

end.
