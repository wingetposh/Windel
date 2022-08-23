unit uConst;

interface
uses
  System.Generics.Collections, System.Types, System.strUtils, system.SysUtils, system.classes;

type
  tColumnClass = class
  public
    sLabel : String;
    iPos : integer;
    iLen : integer;
    constructor create(aPos1, aLen : Integer);
  end;

  tWingetPackage = Class
  public
    Nom : String;
    ID : String;
    Version : String;
    Disponible : string;
    Source : string;
  End;

var
  lListColumn : TStrings;

  procedure makeUpgradeDictonary(sLine : String);

implementation

  procedure makeUpgradeDictonary(sLine : String);
  var
    iPosNom,
    iPosID,
    iPosVersion,
    iPosDispo,
    iPosSource : Integer;
    iLen : Integer;
    pColumn : tColumnClass;
    lHeaders : TStringDynArray;
    lsHeaders : tStringList;
    i : integer;
  begin
    lHeaders := SplitString(sLine,' ');
    i := 0;
    lsHeaders := tStringList.Create;
    lsHeaders.AddStrings(lHeaders);
    while i <= lsHeaders.Count -1 do
    begin
      if trim(lsHeaders[i]) = '' then
      begin
         lsheaders.Delete(i);
      end
      else
        inc(i);
    end;

      lListColumn := tStringlist.Create;
      i := 0;
      repeat
        var key := lsHeaders[i];
        var iPosCol := pos(key,sLine);
        var iLenCol := 0;
        pColumn := tColumnClass.Create(iPosCol,iLenCol);
        pColumn.sLabel := key;
        inc(i);
        lListColumn.AddObject(key,pColumn)
      until i > lsHeaders.Count -1;

      i := 0;
      repeat
         if i < lListColumn.Count -1 then
         begin
             var iPos1 := tColumnClass(lListColumn.Objects[i]).iPos;
             var iPos2 := tColumnClass(lListColumn.Objects[i+1]).iPos;
             tColumnClass(lListColumn.Objects[i]).iLen := iPos2 - iPos1;
         end
         else
         begin
            tColumnClass(lListColumn.Objects[i]).iLen := -1;
         end;
         inc(i);
      until i < lsHeaders.Count -1;

  end;

{ tColumnClass }

constructor tColumnClass.create(aPos1, aLen: Integer);
begin
    iPos := aPos1;
    iLen := aLen;
end;

end.
