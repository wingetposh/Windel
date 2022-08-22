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
    constructor create(aPos1, aPos2 : Integer);
  end;

  tUpgradePackage = Class
  public
    Nom : String;
    ID : String;
    Version : String;
    Disponible : string;
    Source : string;
  End;

var
  dUpgradeColumn : TDictionary<String, tColumnClass>;

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
    pColumnClass : tColumnClass;
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
    iPosNom := pos('Nom',sLine);
    iPosID := pos('ID',sLine);
    iPosVersion := pos('Version',sLine);
    iPosDispo := pos('Disponible',sLine);
    iPosSource := pos('Source',sLine);
    iLen := length(sLine);

    dUpgradeColumn := TDictionary<String,tColumnClass>.create;

    pColumnClass := tColumnClass.Create(iPosNom,iPosID-iPosNom);
    dUpgradeColumn.Add('Nom',pColumnClass);

    pColumnClass := tColumnClass.Create(iPosID,iPosVersion-iPosID);
    dUpgradeColumn.Add('ID',pColumnClass);

    pColumnClass := tColumnClass.Create(iPosVersion,iPosDispo-iPosVersion);
    dUpgradeColumn.Add('Version',pColumnClass);

    pColumnClass := tColumnClass.Create(iPosDispo,iPosSource-iPosDispo);
    dUpgradeColumn.Add('Disponible',pColumnClass);

    pColumnClass := tColumnClass.Create(iPosSource,-1); // '-1' = jusqu'au bout de la ligne
    dUpgradeColumn.Add('Source',pColumnClass);

  end;

{ tColumnClass }

constructor tColumnClass.create(aPos1, aPos2: Integer);
begin
    iPos := aPos1;
    if aPos2 <> -1 then
      iLen := aPos2-aPos1
    else
      iLen := -1;
end;

end.
