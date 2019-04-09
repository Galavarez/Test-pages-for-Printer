unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Printers, Winspool,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Imaging.jpeg, ShellApi, System.ImageList,
  Vcl.ImgList, Vcl.Grids, Vcl.FileCtrl, GDIPAPI,GDIPOBJ, Vcl.ButtonGroup,
  Vcl.Menus;

type
  TForm1 = class(TForm)
    PrintDialog1: TPrintDialog;
    RadioGroup1: TRadioGroup;
    RadioButton_auto: TRadioButton;
    Button1: TButton;
    RadioButton_manual: TRadioButton;
    RadioButton_lotok1: TRadioButton;
    RadioButton_lotok2: TRadioButton;
    ListViewPrinter: TListView;
    ImageList1: TImageList;
    ScrollBox1: TScrollBox;
    GroupBox1: TGroupBox;
    EditNumberOfCopy: TEdit;
    TrackBar1: TTrackBar;
    GroupBox2: TGroupBox;
    ButtonStarTestWithoutDialog: TButton;
    ButtonStarTestWithDialog: TButton;
    ButtonStandartPageWindows: TButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Button2: TButton;
    GroupBox3: TGroupBox;
    ButtonClearAllSelectChecbox: TButton;
    ButtonIncRight: TButton;
    ButtonDecLeft: TButton;

    procedure PrintStandartTestPageWhitoutDialog();
    //procedure ListPrinter();
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintImage(ImageBitmap: TImage);
    procedure PrintFromImageWithDialog();
    procedure PrintFromImageWithoutDialog();
    procedure ButtonStarTestWithoutDialogClick(Sender: TObject);
    procedure ButtonStarTestWithDialogClick(Sender: TObject);
    procedure ButtonStandartPageWindowsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ChangePrinterTray;
    procedure GetImageFiles();
    procedure select_checkbox(Sender:TObject);
    function GetAllSelectCheckbox:integer;
    function PrinterSupportsDuplex: Boolean;
    function GetPrinterStatus(PrinterName: string) : Integer;
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1Click(Sender: TObject);
    //procedure ListViewPrinterColumnClick(Sender: TObject; Column: TListColumn);
    procedure WindowPrintQueue();
    procedure WindowPrinterProperties();
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure WindowOutputPrintSettings();
    procedure N3Click(Sender: TObject);
    procedure ListPrinter2();
    procedure Button2Click(Sender: TObject);

    procedure ButtonClearAllSelectChecboxClick(Sender: TObject);
    procedure ButtonIncRightClick(Sender: TObject);
    procedure ButtonDecLeftClick(Sender: TObject);
    function CheckSelectTestList() : Integer;
    function CheckSelectPrinter() : Integer;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{
 // �������� ��� ����������� ��������
 ListView1.Items[ListView1.ItemIndex].Caption

 // ������ ������������ ��������
 Printer.Printers.IndexOf(ListView1.Items[ListView1.ItemIndex].Caption);

 ChangeFileExt(ExtractFileName(���_�_�����������),'');  // �������� ������ ��� ��� .jpg

}

// ��������� ������ ������� �������� Windows ��� �������
procedure TForm1.PrintStandartTestPageWhitoutDialog();
var
  i: Integer;
  n: Integer;
  cmd: string;
begin
  n := StrToInt(EditNumberOfCopy.Text);
  for i:= 1 to n do
  begin
    //cmd := 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /k /n"' + Trim(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption) + '"';
    //WinExec(PAnsiChar(AnsiString(cmd)), SW_HIDE);
    cmd := 'PRINTUI.DLL,PrintUIEntry /k /n"' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', 'rundll32.exe', Pchar(cmd), nil, SW_NORMAL);
  end;
end;

// ���������  ���� ������� ������
procedure TForm1.WindowPrintQueue();
var
  cmd: string;
begin
    //cmd := 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /o /n"' + Trim(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption) + '"';
    //WinExec(PAnsiChar(AnsiString(cmd)), SW_HIDE);
    cmd := 'PRINTUI.DLL,PrintUIEntry /o /n"' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', 'rundll32.exe', Pchar(cmd), nil, SW_NORMAL);
end;

// ��������� ���� �������� ��������
procedure TForm1.WindowPrinterProperties();
var
  cmd: string;
begin
    //cmd := 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /p /n"' + Trim(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption) + '"';
    //WinExec(PAnsiChar(AnsiString(cmd)), SW_HIDE);
    cmd := 'PRINTUI.DLL,PrintUIEntry /p /n"' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', 'rundll32.exe', Pchar(cmd), nil, SW_NORMAL);
end;

// ��������� ���� ����� ���������� ��������� ������
procedure TForm1.WindowOutputPrintSettings();
var
  cmd: string;
begin
    //cmd := 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /e /n"' + Trim(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption) + '"';
    //WinExec(PAnsiChar(AnsiString(cmd)), SW_HIDE);
    cmd := 'PRINTUI.DLL,PrintUIEntry /e /n"' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', 'rundll32.exe', Pchar(cmd), nil, SW_NORMAL);
end;

// ��������� ������������� ����� ��� ����� �� ScrollBox ���������� ���
procedure TForm1.ScrollBox1Click(Sender: TObject);
begin
    ScrollBox1.SetFocus;
end;

// ��������� ��������� ScrollBox
procedure TForm1.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  WheelDelta := WheelDelta div 4;
  ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position - WheelDelta;
end;

// ��������� ��������� ������ ������ ONLINE ���������
procedure TForm1.ListPrinter2();
var
  i, i3: Integer;
  name_def_printer: String;
begin
   // ������� ������
  ListViewPrinter.Clear;

  // ��������� ������ ���������
  Printer.Free;
  TPrinter.Create;

  // ��� �������� �� ���������
  name_def_printer := Printer.Printers.Strings[Printer.PrinterIndex];

  // ������ ������ ���������
  i :=  Printer.Printers.Count - 1;
  While i >= 0 Do
  begin

       if GetPrinterStatus ( Printer.Printers.Strings[i] ) = 1 then
       begin
          with ListViewPrinter.Items.Add do
          begin
            Caption := Printer.Printers.Strings[i]; // ���������
            ImageIndex:= 3;  // ��������
          end;
       end;
       Dec(i);
  end;

  // �������� � ������������ ������� �� ���������
  i3 := ListViewPrinter.Items.Count - 1;
  While i3 >= 0 Do
  begin
    if Trim(ListViewPrinter.Items[i3].Caption) = Trim(name_def_printer) then
      begin
        ListViewPrinter.ItemIndex := i3;
      end;
    Dec(i3);
  end;

end;

// ������� �������� ������� �� ������� ����
function Tform1.CheckSelectTestList() : Integer;
var
  SelectTestList: Integer;
begin
  SelectTestList := 0;

  if GetAllSelectCheckbox > 0 then
  begin
    SelectTestList := 1;
  end;

  if SelectTestList <> 1 then
  begin
    ShowMessage('���� ������� �������� ����');
    Result := 0;
  end
  else
  begin
    Result := 1;
  end;

end;


// ������� �������� ������� �� ������� ���� ��� �������
function Tform1.CheckSelectPrinter() : Integer;
var
  i, SelectPrinter: Integer;
begin
  SelectPrinter := 0;

  i := ListViewPrinter.Items.Count - 1;
  while i >= 0 do
  begin
    if ListViewPrinter.Items[i].Selected = True then
      begin
         SelectPrinter := 1;
      end;
    Dec(i);
  end;

  if (SelectPrinter <> 1) then
  begin
    ShowMessage('���� ������� �������');
    Result := 0;
  end
  else
  begin
    Result := 1;
  end;

end;


// ���� �� ������� ������ ��� ListViewPrinter
procedure TForm1.N1Click(Sender: TObject);
begin
    WindowPrintQueue;
end;

// ���� �� �������� �������� ��� ListViewPrinter
procedure TForm1.N2Click(Sender: TObject);
begin
   WindowPrinterProperties;
end;

// ���� �� ��������� ������ ��� ListViewPrinter
procedure TForm1.N3Click(Sender: TObject);
begin
   WindowOutputPrintSettings;
end;

// ������� �������� ������� ��������
// ����� ��� http://forum.vingrad.ru/topic-376303.html
function TForm1.GetPrinterStatus(PrinterName: string) : Integer;
var
  BufferLength: Cardinal;
  Buffer: Pointer;
  PrinterInfo: PPrinterInfo2;
  hPrinter: THandle;
  PD: TPrinterDefaults;
  //PrinterStatus: Cardinal;
  //PrinterJobs: Cardinal;
begin
  //PrinterStatus := MAXDWORD;
  ZeroMemory(@PD, SizeOf(PD));
  PD.DesiredAccess := PRINTER_ACCESS_USE;
  if OpenPrinter(PChar(PrinterName), hPrinter, @PD) then
  try
    GetPrinter(hPrinter, 2, nil, 0, @BufferLength);
    if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      Buffer := AllocMem(BufferLength);
      try
        if GetPrinter(hPrinter, 2, Buffer, BufferLength, @BufferLength) then
        begin
          PrinterInfo := PPrinterInfo2(Buffer);
          //PrinterStatus := PrinterInfo^.Status;
          // ��� ������������� ����������� ������
          //if (PrinterInfo^.Attributes and PRINTER_ATTRIBUTE_WORK_OFFLINE) > 0 then
          //  PrinterStatus := PrinterStatus or PRINTER_STATUS_OFFLINE;
          //  PrinterJobs := PrinterInfo^.cJobs;
          if PrinterInfo^.Attributes and PRINTER_ATTRIBUTE_WORK_OFFLINE = PRINTER_ATTRIBUTE_WORK_OFFLINE then
            begin
               //Label2.Caption := ('OFFLINE');
               //ShowMessage('OFFLINE');
               Result := 0;
            end
            else
            begin
               //Label2.Caption := ('ONLINE');
               //ShowMessage('ONLINE');
               Result := 1;
            end;
        end
        else
          RaiseLastOSError;
        finally
        FreeMem(Buffer, BufferLength);
      end;
    end
    else
      RaiseLastOSError;
    finally
    ClosePrinter(hPrinter);
  end;
end;

// ������ �������� ������ ���������
procedure TForm1.Button2Click(Sender: TObject);
begin
   ListPrinter2;
end;

// ������ ����� ��� �������� � �������� ������
procedure TForm1.ButtonClearAllSelectChecboxClick(Sender: TObject);
var
  i: Integer;
begin
  with ScrollBox1 do
  for i := 0 to ControlCount - 1 do
  begin
    if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
    begin
        (Controls[i] as TCheckBox).Checked := False;
    end;
  end;
end;

// ������ ��������� ���-�� �����
procedure TForm1.ButtonDecLeftClick(Sender: TObject);
begin
   if StrToInt(EditNumberOfCopy.Text) > 1 then
   begin
      EditNumberOfCopy.Text :=  IntToStr( StrToInt(EditNumberOfCopy.Text) - 1 );
      TrackBar1.Position := StrToInt(EditNumberOfCopy.Text) ; // �������� ��������� �������
   end;
end;

// ������ ��������� ���-�� �����
procedure TForm1.ButtonIncRightClick(Sender: TObject);
begin
  EditNumberOfCopy.Text :=  IntToStr( StrToInt(EditNumberOfCopy.Text) + 1 );
  TrackBar1.Position := StrToInt(EditNumberOfCopy.Text) ;  // �������� ��������� �������
end;

// ������ ������� �������� ������ Windows ��� �������
procedure TForm1.ButtonStandartPageWindowsClick(Sender: TObject);
begin
  if (CheckSelectPrinter = 1) then PrintStandartTestPageWhitoutDialog;
end;

// ������ ������ � ��������
procedure TForm1.ButtonStarTestWithDialogClick(Sender: TObject);
begin
  if (CheckSelectPrinter = 1) AND (CheckSelectTestList = 1) then  PrintFromImageWithDialog;
end;

// ������ ������ ��� �������
procedure TForm1.ButtonStarTestWithoutDialogClick(Sender: TObject);
begin
   if (CheckSelectPrinter = 1) AND (CheckSelectTestList = 1) then  PrintFromImageWithoutDialog;
end;

// ������  ������ � Duplex ������
procedure TForm1.Button1Click(Sender: TObject);
begin
   if (CheckSelectPrinter = 1) AND (CheckSelectTestList = 1) then ChangePrinterTray;
end;

// ��������� ����� �����
procedure TForm1.FormCreate(Sender: TObject);
begin
  //ListPrinter;
  ListPrinter2;
  GetImageFiles;
end;

// ��������� ��������� ������ ������
procedure TForm1.GetImageFiles();
var
   searchResult: TSearchRec;
   img : TImage;
   cb : TCheckBox;
   x, y, count : Integer;
begin
     if FindFirst( './files/*.bmp', faAnyFile, searchResult) = 0 then
       begin
        x := 20;  // ��������� ��������
        y := 30;
        count := 1;
         repeat
          // ������� ������� Image � �������� � ���
          img := TImage.Create(ScrollBox1);
          //img.Picture.Bitmap.PixelFormat := pf16bit;
          //img.Picture.Bitmap.HandleType := bmDIB;
          img.Parent := ScrollBox1;
          img.Picture.Bitmap.LoadFromFile('files/' + searchResult.Name);
          img.Name := ChangeFileExt(ExtractFileName(searchResult.Name),'');  // �������� ������ ��� ��� .bmp
          img.Width := 100;
          img.Height := 130;
          img.Stretch := True;
          img.Left := x;
          img.Top := y;

          img.Hint := searchResult.Name;  // ������ ��� � ���������� � hint
          img.OnClick := select_checkbox;

          // ������� �������
          cb := TCheckBox.Create(ScrollBox1);
          cb.Parent := ScrollBox1;
          cb.Caption := searchResult.Name;
          cb.Left := x;
          cb.Top := y - 20;

          // ������ �� �����������
          if count = 5 then
            begin
              x := 20; // ��������� ��������
              count := 0;
              y := y + 160;
            end
          else
            begin
              x := x + 120;
            end;

          Inc(count);
         until FindNext(searchResult) <> 0;

       end;
       FindClose(searchResult);
end;

// ��������� ����� �������� ��� ����� �� ��������
procedure TForm1.select_checkbox(Sender:TObject);
var
  img_hint: string;
  i:integer;
begin
  img_hint := (Sender as TImage).Hint; // ���

  with ScrollBox1 do
    for i := 0 to ComponentCount-1 do
      begin

        if TCheckBox(Components[i]).Caption = trim(img_hint) then
        begin
          if TCheckBox(Components[i]).Checked = True then TCheckBox(Components[i]).Checked := False
          else TCheckBox(Components[i]).Checked := True;
        end;

      end;
end;

// �������
procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  EditNumberOfCopy.Text := IntToStr(TrackBar1.Position);
end;

// ��������� ����������� �������� � ������� ��� ��� ���� �4
procedure TForm1.PrintImage(ImageBitmap: TImage);
var
  //TempImageBMP: TBitmap;
  PRect: Trect;
  MetaFile:TMetafile;
  MetaCanvas:TMetafileCanvas;

begin
  //TempImageBMP := TBitmap.Create; // ������ BMP
  //TempImageBMP.LoadFromFile('./files/'+ ImageBitmap.Name +'.bmp');
  //TempImageBMP.Assign(ImageBitmap.Picture.Bitmap); // ��������� JPG � ������ JPEG � BMP � ������ Bitmap

  with PRect do
  begin
    left:=0;
    top:=0;
    right:=Printer.PageWidth;
    Bottom:=Printer.PageHeight;
  end;

  // ������� �������� (��������� �������)
  MetaFile:= TMetafile.Create;
  MetaFile.Height:= ImageBitmap.Picture.Bitmap.Height;
  MetaFile.Width:= ImageBitmap.Picture.Bitmap.Width;
  // ������ ��������
  MetaCanvas:= TMetafileCanvas.Create(MetaFile,0);
  MetaCanvas.Draw(0,0, ImageBitmap.Picture.Bitmap);
  // ����� ���������
  MetaCanvas.Free;
  // ��������� � ������
  Printer.Canvas.StretchDraw(PRect, MetaFile);
  // ������� ������
  MetaFile.Free;
end;

// ��������� ������ �������� � ��������
procedure TForm1.PrintFromImageWithDialog();
var
  i, num_all_cb: Integer;
  string_temp : String;
begin
  // �������� �������
  Printer.PrinterIndex := Printer.Printers.IndexOf(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption);

  // ������ ���-�� �����
  PrintDialog1.Copies := StrToInt(EditNumberOfCopy.Text);

  // ������ �������
  if PrintDialog1.Execute then
    Begin
      num_all_cb := GetAllSelectCheckbox - 1; // ���-�� ���������  Checkbox
      Printer.BeginDoc;
      // ���� ��� � ScrollBox
      with ScrollBox1 do     // ���� ��� � ScrollBox
            for i := 0 to ControlCount - 1 do  // ������� ���-�� ���� ���������
              begin
                // ���� ��� TCheckBox � �� Checked
                if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
                  begin

                    // �������� ��� TImage
                    string_temp := ChangeFileExt(ExtractFileName((Controls[i] as TCheckBox).Caption),'') ;

                    //ShowMessage( (FindComponent('color_1') as TImage) );

                    // �������� ��� � � ������
                    PrintImage( (FindComponent(string_temp) as TImage) );


                    // ����� ���� ����� ?
                    if num_all_cb > 0 then
                    begin
                      Printer.NewPage;
                      Dec(num_all_cb);
                    end;

                  end;
              end;
      // ���������� ������ ��������� ����� ��������
      Printer.EndDoc;
     end;
end;

// ��������� ������ �������� ��� �������
procedure TForm1.PrintFromImageWithoutDialog();
var
   i, num_all_cb: Integer;
   string_temp : String;
begin
  // �������� �������
  Printer.PrinterIndex := Printer.Printers.IndexOf(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption);

  // ������ ���-�� �����
  Printer.Copies := StrToInt(EditNumberOfCopy.Text);

  // ���-�� ���������  Checkbox
  num_all_cb := GetAllSelectCheckbox - 1;
  // ��������� ���������� � ������
  Printer.BeginDoc;
  // ���� ��� � ScrollBox
  with ScrollBox1 do     // ���� ��� � ScrollBox
        for i := 0 to ControlCount - 1 do  // ������� ���-�� ���� ���������
          begin
            // ���� ��� TCheckBox � �� Checked
            if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
              begin

                // �������� ��� TImage
                string_temp := ChangeFileExt(ExtractFileName((Controls[i] as TCheckBox).Caption),'') ;

                //ShowMessage( (FindComponent('color_1') as TImage) );
                //ShowMessage( string_temp );
                // �������� ��� � � ������
                PrintImage( (FindComponent(string_temp) as TImage) );


                // ����� ���� ����� ?
                if num_all_cb > 0 then
                begin
                  Printer.NewPage;
                  Dec(num_all_cb);
                end;

              end;
          end;
  // ���������� ������ ��������� ����� ��������
  Printer.EndDoc;
end;

// ������� ���������� ������� ������ ���������
function TForm1.GetAllSelectCheckbox:integer;
var
  i: Integer;
  all_select: Integer;
begin
  all_select := 0;
  with ScrollBox1 do
  for i := 0 to ControlCount - 1 do
  begin
    if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
    begin
        all_select := all_select + 1;
    end;
  end;
  Result := all_select;
end;

// ������� �������� �������� � ��������
function TForm1.PrinterSupportsDuplex: Boolean;
 var
   Device, Driver, Port: array[0..255] of Char;
   hDevMode: THandle;
 begin
   Printer.GetPrinter(Device, Driver, Port, hDevmode);
   Result := WinSpool.DeviceCapabilities(Device, Port, DC_DUPLEX, nil, nil) <> 0;
 end;

// ��������� �������� ����� ��� ������� ������
procedure TForm1.ChangePrinterTray;
var
  Device: array[0..255] of char;
  Driver: array[0..255] of char;
  Port: array[0..255] of char;
  hDMode: THandle;
  PDMode: PDEVMODE;
  i : Integer;
  //num_all_cb: Integer;
  string_temp: String;
begin
  // �������� �������
  Printer.PrinterIndex := Printer.Printers.IndexOf(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption);

  // ��������� ������� �� ����� ��������, ���� ���� �� ������� ���
  //if PrinterSupportsDuplex then
  //begin

    // �������� �������
    Printer.GetPrinter(Device, Driver, Port, hDMode);

        if hDMode <> 0 then
        begin
          pDMode := GlobalLock(hDMode);
          if pDMode <> nil then
          begin
              pDMode^.dmFields := pDMode^.dmFields or DM_DEFAULTSOURCE;

              // ����� �����
              if RadioButton_auto.Checked then pDMode^.dmDefaultSource := DMBIN_AUTO;
              if RadioButton_manual.Checked then pDMode^.dmDefaultSource := DMBIN_MANUAL;
              if RadioButton_lotok1.Checked then pDMode^.dmDefaultSource := 1;
              if RadioButton_lotok2.Checked then pDMode^.dmDefaultSource := 2;

              //pDMode^.dmDefaultSource := DMBIN_MANUAL;
              // 0 DMBIN_AUTO, 1 �����_1, DMBIN_MANUAL ������_���������

              // ������� �������
              pDMode^.dmFields := pDMode^.dmFields or DM_DUPLEX;
              pDMode^.dmDuplex := DMDUP_VERTICAL; //������������ ������������� ������

              //Printer.SetPrinter(Device, Driver, Port, hDMode);
              GlobalUnlock(hDMode);
          end;
        end;

        // �������� ������� ��� ������
        Printer.PrinterIndex := Printer.Printers.IndexOf(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption);

        // ������ ���-�� �����
        Printer.Copies := StrToInt(EditNumberOfCopy.Text);

        // ������ �������
      if PrintDialog1.Execute then
      Begin
        //num_all_cb := GetAllSelectCheckbox - 1; // ���-�� ���������  Checkbox
        //Printer.BeginDoc;
        // ���� ��� � ScrollBox
        with ScrollBox1 do     // ���� ��� � ScrollBox
              for i := 0 to ControlCount - 1 do  // ������� ���-�� ���� ���������
                begin
                  // ���� ��� TCheckBox � �� Checked
                  if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
                    begin

                      // �������� ��� TImage
                      string_temp := ChangeFileExt(ExtractFileName((Controls[i] as TCheckBox).Caption),'') ;

                      Printer.BeginDoc;
                      //ShowMessage( (FindComponent('color_1') as TImage) );
                      // �������� ��� � � ������
                      PrintImage( (FindComponent(string_temp) as TImage) );

                      Printer.NewPage;

                      PrintImage( (FindComponent(string_temp) as TImage) );
                      // ����� ���� ����� ?
                      {
                      if num_all_cb > 0 then
                      begin
                        Printer.NewPage;
                        Dec(num_all_cb);
                      end;
                      }
                      Printer.EndDoc;
                    end;
                end;
        // ���������� ������ ��������� ����� ��������
        //Printer.EndDoc;
        end;

  //end
  //else  ShowMessage('���� �������/��� �� ������������ Duplex �����');

end;


end.
