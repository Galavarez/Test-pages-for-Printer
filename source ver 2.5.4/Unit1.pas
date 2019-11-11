unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Printers, Winspool,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Imaging.jpeg, ShellApi, System.ImageList,
  Vcl.ImgList, Vcl.Grids, Vcl.FileCtrl, GDIPAPI,GDIPOBJ, Vcl.ButtonGroup,
  Vcl.Menus, inifiles, Registry, Unit2;

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
    ButtonIncRight: TButton;
    ButtonDecLeft: TButton;
    Button_Clear_All_Setting: TButton;
    GroupBox3: TGroupBox;
    Button_Head_Cleaning_Normal: TButton;
    Button_Nozzle_Check: TButton;
    Button_Head_Cleaning_Deep: TButton;
    Button_Head_Cleaning_Starter: TButton;
    Label1: TLabel;

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
    //procedure select_checkbox(Sender:TObject);
    procedure select_checkbox_2(Sender:TObject);
    function GetAllSelectCheckbox:integer;
    function PrinterSupportsDuplex: Boolean;
    function GetPrinterStatus(PrinterName: string) : Integer;
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    //procedure ScrollBox1Click(Sender: TObject);
    //procedure ListViewPrinterColumnClick(Sender: TObject; Column: TListColumn);
    procedure WindowPrintQueue();
    procedure WindowPrinterProperties();
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure WindowOutputPrintSettings();
    procedure N3Click(Sender: TObject);
    procedure ListPrinter2();
    procedure Button2Click(Sender: TObject);

    procedure Button_Clear_All_SettingClick(Sender: TObject);
    procedure ButtonIncRightClick(Sender: TObject);
    procedure ButtonDecLeftClick(Sender: TObject);
    function CheckSelectTestList() : Integer;
    function CheckSelectPrinter() : Integer;
    procedure ScrollBox1MouseEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);


    procedure NozzleCheckEpson();
    procedure NozzleCheckCanon();

    procedure HeadCleaningEpsonNormal();
    procedure HeadCleaningEpsonDeep();
    procedure HeadCleaningCanonNormal();
    procedure HeadCleaningCanonDeep();
    procedure HeadCleaningCanonStarter();

    procedure Button_Head_Cleaning_NormalClick(Sender: TObject);
    procedure Button_Nozzle_CheckClick(Sender: TObject);
    procedure Button_Head_Cleaning_DeepClick(Sender: TObject);
    procedure Button_Head_Cleaning_StarterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  Form1: TForm1;
  Registry: TRegIniFile;

implementation

{$R *.dfm}

{
 // �������� ��� ����������� ��������
 ListView1.Items[ListView1.ItemIndex].Caption

 // ������ ������������ ��������
 Printer.Printers.IndexOf(ListView1.Items[ListView1.ItemIndex].Caption);

 ChangeFileExt(ExtractFileName(���_�_�����������),'');  // �������� ������ ��� ��� .jpg

}

//////////////////////////////////////////////////
//                � � � � � � �                 //
//////////////////////////////////////////////////

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

// ������� ���������� ������� ������ ���������
function TForm1.GetAllSelectCheckbox:integer;
var
  i: Integer;
  all_select: Integer;
begin
  all_select := 0;
  with ScrollBox1 do
  for i := 0 to ComponentCount - 1 do
  begin
    //ShowMessage(Components[i].Name);
    if TImage(Components[i]).ImageCheck = True then
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


//////////////////////////////////////////////////////
//                � � � � � � � � �                 //
//////////////////////////////////////////////////////

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

// ���������  ������� ��� Epson
procedure TForm1.NozzleCheckEpson();
var
  cmd: string;
begin
    cmd := ' "spool\epson_nozzle_check.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ���������  ������� ��� Canon
procedure TForm1.NozzleCheckCanon();
var
  cmd: string;
begin
    cmd := ' "spool\canon_nozzle_check.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ���������  ��������� �� Epson
procedure TForm1.HeadCleaningEpsonNormal();
var
  cmd: string;
begin
    cmd := ' "spool\epson_head_cleaning_normal.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ���������  ��������� �� Epson Strong
procedure TForm1.HeadCleaningEpsonDeep();
var
  cmd: string;
begin
    cmd := ' "spool\epson_head_cleaning_deep.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ���������  ��������� �� Canon Normal
procedure TForm1.HeadCleaningCanonNormal();
var
  cmd: string;
begin
    cmd := ' "spool\canon_head_cleaning_normal.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ���������  ��������� �� Canon Deep
procedure TForm1.HeadCleaningCanonDeep();
var
  cmd: string;
begin
    cmd := ' "spool\canon_head_cleaning_deep.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ���������  ��������� �� Canon Starter
procedure TForm1.HeadCleaningCanonStarter();
var
  cmd: string;
begin
    cmd := ' "spool\canon_head_cleaning_system_starter.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
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

// ��������� ��������� �������� ScrollBox1 ����� ��� ��� �����
procedure TForm1.ScrollBox1MouseEnter(Sender: TObject);
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

// ��������� ����� �����
procedure TForm1.FormCreate(Sender: TObject);
var
  Registry: TRegistry;
begin
  //ListPrinter;
  ListPrinter2;
  GetImageFiles;

  // ��������� � ������� �������� ��������� ����
  Registry := TRegistry.Create;
  Registry.RootKey := HKEY_CURRENT_USER;
  Registry.OpenKey('\SOFTWARE\TestPageProgram',True);

  if Registry.ValueExists('Left') then Form1.Left := Registry.ReadInteger('Left');
  if Registry.ValueExists('Top') then Form1.Top := Registry.ReadInteger('Top');
  if Registry.ValueExists('Width') then Form1.Width := Registry.ReadInteger('Width');
  if Registry.ValueExists('Height') then Form1.Height := Registry.ReadInteger('Height');

  Registry.Free;

end;

// ��������� ��������� � ������� �������� ��������� ����
procedure TForm1.FormDestroy(Sender: TObject);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  Registry.RootKey := HKEY_CURRENT_USER;
  Registry.OpenKey('\SOFTWARE\TestPageProgram',True);

  Registry.WriteInteger('Left', Form1.Left);
  Registry.WriteInteger('Top', Form1.Top);
  Registry.WriteInteger('Width', Form1.Width);
  Registry.WriteInteger('Height', Form1.Height);

  Registry.Free;
end;

// ��������� ��������� �������� �� Scrollbox � ��������� ������ ������
procedure TForm1.GetImageFiles();
var
   searchResult: TSearchRec;
   img : TImage;
   x, y, count : Integer;
   pic_in_widh: Integer;
   count_str_in_scrollbox : Integer;
begin
     count_str_in_scrollbox := 1; // ���-�� ����� � ����������
     pic_in_widh := Round(ScrollBox1.Width / 120); // ���-�� �������� �� ������ 8 �� ���� � ����

     if FindFirst( './files/*.bmp', faAnyFile, searchResult) = 0 then
       begin
          x := 10;  // ��������� �������� �� �����������
          y := 10;  // ��������� �������� �� ���������
          count := 1;  // ������ ������� ��������
         repeat
          //ShowMessage('searchResult = ' + searchResult.Name);
          // ������� ������� Image � �������� � ���
          img := TImage.Create(ScrollBox1);
          img.Parent := ScrollBox1;
          img.Picture.Bitmap.LoadFromFile('files/' + searchResult.Name);
          img.Name := ChangeFileExt(ExtractFileName(searchResult.Name),'');  // �������� ������ ��� ��� .bmp
          img.Width := 100;
          img.Height := 130;
          img.Stretch := True;
          img.Left := x;
          img.Top := y;

          img.NameAndExtension := searchResult.Name;  // ������ ��� � ����������
          img.ImageCheck := False; // ������ ��������� ��������� �������� ��� ���
          img.OnClick := select_checkbox_2;

          case count of
              0..7:
                begin
                  x := x + 112; // �������� �� �����������
                end;
              8:
                begin
                  x := 10; // ��������� ��������
                  y := y + 140;  // �������� �� ���������
                End;
              9:
                begin
                  x := x + 112; // �������� �� �����������
                  Inc(count_str_in_scrollbox); // ����������� �������� ����������
                  count := 1; // �������� ������� ��� ����� ������
                end;
          end;
          Inc(count);  // ����������� �������
         until FindNext(searchResult) <> 0;


       end;
       FindClose(searchResult);
       // ������������� �������� ����� ����� ��� � ���� � ����� ���-�� �� ����
       ScrollBox1.VertScrollBar.Range := count_str_in_scrollbox * 145;
end;

// ��������� �������� �������� �� �����
procedure TForm1.select_checkbox_2(Sender:TObject);
var
  i :integer;
  BitmapImg: TBitmap;
  NameAndExtension: String;
begin
  NameAndExtension := (Sender as TImage).NameAndExtension; // �������� ��� � ����������� ����� ��������� �� ��������

  BitmapImg := TBitmap.Create;    // �������  Bitmap
  BitmapImg.LoadFromFile('files/' + NameAndExtension);  // ��������� ��������

  with ScrollBox1 do      // ���� ��� � ScrollBox1
    for i := 0 to ComponentCount-1 do
      begin

        if TImage(Components[i]).NameAndExtension = trim(NameAndExtension) then    // ���� �����
        begin

          if TImage(Components[i]).ImageCheck = False then
            begin
              if BitmapImg.Width > 2000 then
                begin
                  TImage(Components[i]).Canvas.Pen.Width := 100;  //������� �����
                end
              else if (BitmapImg.Width < 2000) and (BitmapImg.Width > 1000) then
                begin
                  TImage(Components[i]).Canvas.Pen.Width := 50;  //������� �����
                end
              else if BitmapImg.Width < 1000 then
                begin
                  TImage(Components[i]).Canvas.Pen.Width := 25;  //������� �����
                end;

              TImage(Components[i]).Canvas.Pen.Color := clRed; //���� �����
              TImage(Components[i]).Canvas.Brush.Style := bsClear; // �����
              TImage(Components[i]).Canvas.Rectangle(0,0, BitmapImg.Width, BitmapImg.Height);//������ ������� (�����)

              TImage(Components[i]).ImageCheck := True; // ���������� ��������� �������� ��� ��������
            end
          else
            begin
              TImage(Components[i]).Picture.Bitmap := BitmapImg;
              TImage(Components[i]).ImageCheck := False; // ���������� ��������� �������� ��� �� ��������
            end;

        end;

      end;
  BitmapImg.Destroy;   // �������  Bitmap
end;

// ��������� �������
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
  img_temp : TImage;
begin
  // �������� �������
  Printer.PrinterIndex := Printer.Printers.IndexOf(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption);

  // ������ ���-�� �����
  PrintDialog1.Copies := StrToInt(EditNumberOfCopy.Text);

  // ������ �������
  if PrintDialog1.Execute then
    Begin
      // ���-�� ���������  Checkbox
      num_all_cb := GetAllSelectCheckbox - 1;
      // ��������� ���������� � ������
      Printer.BeginDoc;
      // ���� ��� � ScrollBox
      with ScrollBox1 do     // ���� ��� � ScrollBox
            for i := 0 to ComponentCount - 1 do  // ������� ���-�� ���� ���������
              begin
                // ���� ��� TImage � �� Checked
                if TImage(Components[i]).ImageCheck = True then
                  begin

                    // ������� TImage
                    img_temp := TImage.Create(Self);
                    // ��������� �������� ����� ����� � ������
                    img_temp.Picture.Bitmap.LoadFromFile('files/' + TImage(Components[i]).NameAndExtension);
                    // �������� ��� � � ������
                    PrintImage( img_temp );
                    // ������� ������
                    img_temp.Free;

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
   img_temp : TImage;
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
        for i := 0 to ComponentCount - 1 do  // ������� ���-�� ���� ���������
          begin
            // ���� ��� TImage � �� Checked
            if TImage(Components[i]).ImageCheck = True then
              begin

                // ������� TImage
                img_temp := TImage.Create(Self);
                // ��������� �������� ����� ����� � ������
                img_temp.Picture.Bitmap.LoadFromFile('files/' + TImage(Components[i]).NameAndExtension);
                // �������� ��� � � ������
                PrintImage( img_temp );
                // ������� ������
                img_temp.Free;

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

// ��������� �������� ����� ��� ������� ������ � ������
procedure TForm1.ChangePrinterTray;
var
  Device: array[0..255] of char;
  Driver: array[0..255] of char;
  Port: array[0..255] of char;
  hDMode: THandle;
  PDMode: PDEVMODE;
  i : Integer;
  img_temp : TImage;
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


              //pDMode^.dmDuplex := DMDUP_SIMPLEX;   // ���������� ��������
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
        // ���� ��� � ScrollBox
        (*
        with ScrollBox1 do     // ���� ��� � ScrollBox
              for i := 0 to ControlCount - 1 do  // ������� ���-�� ���� ���������
                begin
                  // ���� ��� TCheckBox � �� Checked
                  if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
                    begin
                      // �������� ��� TImage
                      string_temp := ChangeFileExt(ExtractFileName((Controls[i] as TCheckBox).Caption),'') ;
                      // ���������� ������
                      Printer.BeginDoc;
                      // �������� ��� � � ������
                      PrintImage( (FindComponent(string_temp) as TImage) );
                      // ��������� ����� ��������
                      Printer.NewPage;
                      // �������� ��� � � ������
                      PrintImage( (FindComponent(string_temp) as TImage) );
                      // ���������� ������ ��������� ����� ��������
                      Printer.EndDoc;
                    end;
                end;
            *)
        with ScrollBox1 do     // ���� ��� � ScrollBox
        for i := 0 to ComponentCount - 1 do  // ������� ���-�� ���� ���������
          begin
            // ���� ��� TImage � �� Checked
            if TImage(Components[i]).ImageCheck = True then
              begin
                // ������� TImage
                img_temp := TImage.Create(Self);
                // ��������� �������� ����� ����� � ������
                img_temp.Picture.Bitmap.LoadFromFile('files/' + TImage(Components[i]).NameAndExtension);
                // ���������� ������
                Printer.BeginDoc;
                // �������� ��� � � ������
                PrintImage(img_temp);
                // ��������� ����� ��������
                Printer.NewPage;
                // �������� ��� � � ������
                PrintImage(img_temp);
                // ���������� ������ ��������� ����� ��������
                Printer.EndDoc;
                // ������� ������
                img_temp.Free;
              end;
          end;
      end;

  //end
  //else  ShowMessage('���� �������/��� �� ������������ Duplex �����');

    // ��������� �������
    Printer.GetPrinter(Device, Driver, Port, hDMode);   // ������� �������

    if hDMode <> 0 then
    begin
    pDMode := GlobalLock(hDMode);  // ������������� ���������
      if pDMode <> nil then
        begin
          pDMode^.dmFields := pDMode^.dmFields or DM_DEFAULTSOURCE;
          pDMode^.dmDefaultSource := DMBIN_AUTO;
          pDMode^.dmDuplex := DMDUP_SIMPLEX;  // ��������� �������
          GlobalUnlock(hDMode);  // �������������� ���������
        end;
    end;

end;


////////////////////////////////////////////////
//                � � � � � �                 //
////////////////////////////////////////////////

// ������ �������� ������ ���������
procedure TForm1.Button2Click(Sender: TObject);
begin
   ListPrinter2;
end;

// ������ ����� ���� ��������� ������������
procedure TForm1.Button_Clear_All_SettingClick(Sender: TObject);
var
  i: Integer;
begin
  // ������� ����� � �������� ������
  with ScrollBox1 do
  for i := 0 to ComponentCount - 1 do
  begin
    if TImage(Components[i]).ImageCheck = True then
    begin
       TImage(Components[i]).Picture.LoadFromFile('files/' + TImage(Components[i]).NameAndExtension);
       TImage(Components[i]).ImageCheck := False;
    end;
  end;
  // �������� ���������� ����� � �������
  EditNumberOfCopy.Text := '1';
  TrackBar1.Position := 1;
  // ������ ����� � ����� �����
  RadioButton_manual.Checked := True;
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

// ������ ������ � Duplex ������
procedure TForm1.Button1Click(Sender: TObject);
begin
   if (CheckSelectPrinter = 1) AND (CheckSelectTestList = 1) then ChangePrinterTray;
end;

// ������ ������ ��������� ���������� �������. �������
procedure TForm1.Button_Head_Cleaning_NormalClick(Sender: TObject);
var
  NamePrinter: string;
begin
  //ShowMessage(IntToStr(GetAllSelectCheckbox));
  NamePrinter := LowerCase(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption); // �������� ��� � ������ ��������
  if CheckSelectPrinter = 1 then
    begin
      if Pos('canon', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'canon';
         HeadCleaningCanonNormal;
      end;
      if Pos('epson', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'epson';
         HeadCleaningEpsonNormal;
      end;
    end;
end;

// ������ ������ ��������� ���������� �������. ��������
procedure TForm1.Button_Head_Cleaning_DeepClick(Sender: TObject);
var
  NamePrinter: string;
begin
  NamePrinter := LowerCase(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption); // �������� ��� � ������ ��������
  if CheckSelectPrinter = 1 then
    begin
      if Pos('canon', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'canon';
         HeadCleaningCanonDeep;
      end;
      if Pos('epson', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'epson';
         HeadCleaningEpsonDeep;
      end;
    end;
end;

// ������ ������ �������������� ��������
procedure TForm1.Button_Head_Cleaning_StarterClick(Sender: TObject);
var
  NamePrinter: string;
begin
  NamePrinter := LowerCase(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption); // �������� ��� � ������ ��������
  if CheckSelectPrinter = 1 then
    begin
      if Pos('canon', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'canon';
         HeadCleaningCanonStarter;
      end;
      if Pos('epson', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'epson';
         ShowMessage('��� Epson ��� ���');
      end;
    end;
end;


// ������ ������ �������� ���
procedure TForm1.Button_Nozzle_CheckClick(Sender: TObject);
var
  NamePrinter: string;
begin
  NamePrinter := LowerCase(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption); // �������� ��� � ������ ��������
  if CheckSelectPrinter = 1 then               // �������� �� ��������� ��������
    begin
      if Pos('canon', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'canon';
         NozzleCheckCanon;
      end;
      if Pos('epson', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'epson';
         NozzleCheckEpson;
      end;
    end;
end;

//////////////////////////////////////////////////////////
//                � � � � � �   � � � �                 //
//////////////////////////////////////////////////////////

// ������ ���� �� ������� ������ ��� ListViewPrinter
procedure TForm1.N1Click(Sender: TObject);
begin
    WindowPrintQueue;
end;

// ������ ���� �� �������� �������� ��� ListViewPrinter
procedure TForm1.N2Click(Sender: TObject);
begin
   WindowPrinterProperties;
end;

// ������ ���� �� ��������� ������ ��� ListViewPrinter
procedure TForm1.N3Click(Sender: TObject);
begin
   WindowOutputPrintSettings;
end;


end.
