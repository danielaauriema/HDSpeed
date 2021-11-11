unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.FileCtrl,
  Vcl.Samples.Spin, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP;

type
  TfrmMain = class(TForm)
    btnStart: TButton;
    Memo1: TMemo;
    DriveComboBox1: TDriveComboBox;
    btnClear: TButton;
    ComboBox1: TComboBox;
    procedure btnStartClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FTick: Cardinal;
    FSize: Cardinal;
    FFileName: String;
    FStream: TMemoryStream;
  public
    function GetTimeForRead(ABuffered: boolean): single;
    function GetTimeForWrite(ABuffered: boolean): single;
  end;

var
  frmMain: TfrmMain;

implementation
uses Math;

{$R *.dfm}

procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Memo1.Clear;
  FStream:= TMemoryStream.Create;
end;

function TfrmMain.GetTimeForRead(ABuffered: boolean): single;
var
  FlagsAndAttributes: DWORD;
  FileHandle: THandle;
  SrcStream, DestStream: TStream;
  Ticks: DWord;
  FileToRead: PWideChar;
begin
  if ABuffered then
    FlagsAndAttributes := FILE_ATTRIBUTE_NORMAL
  else
    FlagsAndAttributes := FILE_FLAG_NO_BUFFERING;

  FileToRead:=  PWideChar(FFileName);

  FileHandle := CreateFile(FileToRead, GENERIC_READ, FILE_SHARE_READ, nil,
    OPEN_EXISTING, FlagsAndAttributes, 0);
  if FileHandle = INVALID_HANDLE_VALUE then begin
    Result := 0.0;
    exit;
  end;

  SrcStream := THandleStream.Create(FileHandle);
  try
    DestStream := TMemoryStream.Create;
    try
      DestStream.Size := 1024 * 1024;

      Sleep(0);
      Ticks := GetTickCount;
      while SrcStream.Position < SrcStream.Size do
      begin
        DestStream.Position:= 0;
        DestStream.CopyFrom(SrcStream, min (DestStream.Size, SrcStream.Size - SrcStream.Position));
      end;
      Result := 0.001 * (GetTickCount - Ticks);

    finally
      DestStream.Free;
    end;
  finally
    SrcStream.Free;
  end;
  FileClose(FileHandle);
  Memo1.Lines.Add('Read: ' + FormatFloat ('###,###.0000', FSize/Result) + ' MB/s');
end;

function TfrmMain.GetTimeForWrite(ABuffered: boolean): single;
var
  m: TMemoryStream;
  i: Cardinal;
  b: Byte;

  FlagsAndAttributes: DWORD;
  FileHandle: THandle;
  SrcStream, DestStream: TStream;
  Ticks: DWord;
  FileToWrite: PWideChar;
begin

  m:= TMemoryStream.Create;
  for i := 1 to 1024 * 1024 do
  begin
    b:= ord('0') + i mod 10;
    m.Write(b, 1);
  end;

  if ABuffered then
    FlagsAndAttributes := FILE_ATTRIBUTE_NORMAL
  else
    FlagsAndAttributes := FILE_FLAG_NO_BUFFERING + FILE_FLAG_WRITE_THROUGH;

  FileToWrite:=  PWideChar(FFileName);

  FileHandle := CreateFile(FileToWrite, GENERIC_WRITE, 0, nil,
    CREATE_ALWAYS, FlagsAndAttributes, 0);

  if FileHandle = INVALID_HANDLE_VALUE then begin
    Result := 0.0;
    exit;
  end;

  DestStream := THandleStream.Create(FileHandle);
  try

    DestStream.Size := m.Size;

    Sleep(0);
    Ticks := GetTickCount;
    for i := 1 to FSize do
    begin
      m.Position:= 0;
      DestStream.CopyFrom(m, m.Size);
    end;

    Result := 0.001 * (GetTickCount - Ticks);

  finally
    DestStream.Free;
  end;
  FileClose(FileHandle);
  m.Free;

  Memo1.Lines.Add('Write: ' + FormatFloat ('###,###.0000', FSize/Result) + ' MB/s');

end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  FSize:= StrToInt(ComboBox1.Text);
  FFileName:= DriveComboBox1.Drive + ':\File1.txt';
  Memo1.Lines.Add(FFileName);
  GetTimeForWrite(False);
  GetTimeForRead(False);
  DeleteFile(FFileName);
end;



end.
