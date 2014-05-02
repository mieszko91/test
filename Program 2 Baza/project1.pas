program project1;

uses
  crt;

const
  Dziennik = 'Dziennik.txt';
  logintxt = 'login.txt';
  OcenyTxt = 'Oceny.txt';
  PrzedTxt = 'Przedmioty.txt';
  UprNauczyciela = 1;
  UprRodzica = 2;
  UprAdmina = 3;
  Sprawdzian = 7;
  Kartkowka = 8;
  Odpowiedz = 9;
  MaksDl = 25;
  MaksDlKlasy =2;

type
  Oceny = array of integer;

  Przedmioty = array of record
    NazwaPrzedmiotu: string;
    Oceny: Oceny;
  end;

  WskListaDanychOsob = ^ListaDanychOsob;

  DaneUcznia = record
    Id: integer;
    Imie: string[MaksDl];
    Nazwisko: string[MaksDl];
    Klasa: string[MaksDlKlasy];
  end;

  DaneOsoby = record
    DUcznia: DaneUcznia;
    OcenyZPrzed: Przedmioty;
  end;

  ListaDanychOsob = record
    Dosoby: DaneOsoby;
    Next: WskListaDanychOsob;
    Prev: WskListaDanychOsob;
  end;
  WskListaDanychDoZalog = ^ListaDanychDoZalog;

  DaneDoZalogowania = record
    Login: string[MaksDl];
    Haslo: string[MaksDl];
    Imie: string[MaksDl];
    Nazwisko: string[MaksDl];
    upr: integer;
    Id: integer;
  end;

  ListaDanychDoZalog = record
    Log: DaneDoZalogowania;
    Next: WskListaDanychDoZalog;
    Prev: WskListaDanychDoZalog;
  end;

var
  Uprawnienie: integer;
  NumerUcznia: integer;
  Id: integer;
  GlowaDanychOsob: WskListaDanychOsob;
  GlowaDanychDoLog: WskListaDanychDoZalog;

  procedure OdczytaniePrzedmiotowZPliku(var ListaPrzedmiotow: Przedmioty);
  var
    PlikPrzed: Text;
    Dlugosc, i: integer;
  begin
    Dlugosc := 1;
    i := 0;
    Assign(PlikPrzed, PrzedTxt);
    reset(PlikPrzed);
    while not EOF(PlikPrzed) do
    begin
      setlength(ListaPrzedmiotow, Dlugosc);
      readln(PlikPrzed, ListaPrzedmiotow[i].NazwaPrzedmiotu);
      i := i + 1;
      Dlugosc := Dlugosc + 1;
    end;
    Close(PlikPrzed);
  end;

  procedure ZapisaniePrzedmiotowDoPliku(ListaPrzedmiotow: Przedmioty);
  var
    PlikPrzed: Text;
    i: integer;
  begin
    Assign(PlikPrzed, PrzedTxt);
    Rewrite(PlikPrzed);
    for i := high(ListaPrzedmiotow) downto low(ListaPrzedmiotow) do
    begin
      writeln(PlikPrzed, ListaPrzedmiotow[i].NazwaPrzedmiotu);
    end;
    Close(PlikPrzed);
  end;

  procedure SprawdzenieCzyPrzedmiotIstnieje(PodanyPrzedmiot: string;
  var Istnieje: boolean);
  var
    PlikPrzed: Text;
    SprPrzedmiot: string;
  begin
    Assign(PlikPrzed, PrzedTxt);
    Reset(PlikPrzed);
    while not EOF(PlikPrzed) do
    begin
      readln(PlikPrzed, SprPrzedmiot);
      if PodanyPrzedmiot = SprPrzedmiot then
      begin
        Istnieje := True;
        Break;
      end;
    end;
    Close(plikPrzed);
  end;

  procedure DodanieNowegoPrzedmiotu(var GlowaOsob: WskListaDanychOsob);
  var
    PlikPrzed: Text;
    NowyPrzedmiot: string;
    Istnieje: boolean;
  begin
    Writeln('Podaj Nazwe Nowego Przedmiotu');
    Readln(NowyPrzedmiot);
    Istnieje := False;
    SprawdzenieCzyPrzedmiotIstnieje(NowyPrzedmiot, Istnieje);
    if Istnieje = False then
    begin
      if GlowaOsob <> nil then
      begin
        while (GlowaOsob^.prev <> nil) do
        begin
          GlowaOsob := GlowaOsob^.prev;
        end;
      end;
      while GlowaOsob <> nil do
      begin
        if Istnieje = False then
        begin
          setlength(GlowaOsob^.Dosoby.OcenyZPrzed, high(GlowaOsob^.Dosoby.OcenyZPrzed) + 2);
          GlowaOsob^.Dosoby.OcenyZPrzed[high(GlowaOsob^.Dosoby.OcenyZPrzed)].NazwaPrzedmiotu
          :=
            NowyPrzedmiot;
          setlength(GlowaOsob^.Dosoby.OcenyZPrzed[high(GlowaOsob^.Dosoby.OcenyZPrzed)].Oceny, 1);
          GlowaOsob^.Dosoby.OcenyZPrzed[high(GlowaOsob^.Dosoby.OcenyZPrzed)].Oceny[0] := 0;
        end;
        if GlowaOsob^.Next = nil then
          break;
        GlowaOsob := GlowaOsob^.Next;
      end;

      Assign(PlikPrzed, PrzedTxt);
      Append(PlikPrzed);
      if Istnieje = False then
        Writeln(PlikPrzed, NowyPrzedmiot);
      Close(PlikPrzed);
    end;

    if Istnieje = True then
      writeln('podany Przedmiot Isnieje. Wcisnij Dowony Klawisz')
    else
      writeln('Dodano Przedmiot. Wcisnij Dowolny Klawisz');
     readkey;
  end;

  procedure UsunieciePrzedmiotu(var GlowaOsob: WskListaDanychOsob);
  var
    Usunieto, Istnieje: boolean;
    i: integer;
    PrzedmiotDoUsuniecia: string;
  begin
    Istnieje := False;
    Usunieto := False;
    Writeln('Podaj Nazwe Przedmiotu Do Usuniecia');
    Readln(PrzedmiotDoUsuniecia);
    SprawdzenieCzyPrzedmiotIstnieje(PrzedmiotDoUsuniecia, Istnieje);
    if Istnieje = True then
    begin
      if GlowaOsob <> nil then
      begin
        while (GlowaOsob^.prev <> nil) do
        begin
          GlowaOsob := GlowaOsob^.prev;
        end;
      end;
      while GlowaOsob <> nil do
      begin
        Usunieto := False;
        if (GlowaOsob^.Dosoby.OcenyZPrzed[high(GlowaOsob^.Dosoby.OcenyZPrzed)].NazwaPrzedmiotu = PrzedmiotDoUsuniecia) then
        begin
          Setlength(GlowaOsob^.Dosoby.OcenyZPrzed, high(GlowaOsob^.Dosoby.OcenyZPrzed));
          Usunieto := True;
        end;
        if Usunieto = False then
        begin
          i := 0;
          while i <= high(GlowaOsob^.Dosoby.OcenyZPrzed) - 1 do
          begin
            if (GlowaOsob^.Dosoby.OcenyZPrzed[i].NazwaPrzedmiotu =
              PrzedmiotDoUsuniecia) then
            begin
              Usunieto := True;
              while i <= high(GlowaOsob^.Dosoby.OcenyZPrzed) - 1 do
              begin
                GlowaOsob^.Dosoby.OcenyZPrzed[i] := GlowaOsob^.Dosoby.OcenyZPrzed[i + 1];
                i := i + 1;
              end;
              SetLength(GlowaOsob^.Dosoby.OcenyZPrzed,
                high(GlowaOsob^.Dosoby.OcenyZPrzed));
              break;
            end;
            i := i + 1;
          end;
        end;
        if GlowaOsob^.Next = nil then
          break;
        GlowaOsob := GlowaOsob^.Next;
      end;
    end;
    if usunieto = True then
    begin
      ZapisaniePrzedmiotowDoPliku(GlowaOsob^.Dosoby.OcenyZPrzed);
      writeln('Usunieto Przedmiot');
    end
    else
      writeln('Brak Przedmiotu. Poczekaj 2 sek');
    Delay(2000);
  end;

  procedure WyswietlenieOpcjiEdytowaniaPrzedmiotow;
  var
    Decyzja: char;
  begin
    repeat
      ClrScr;
      Writeln('Co Zamierzasz Zrobic?');
      Writeln('1: Dodanie Przedmiotu');
      Writeln('2: Usuniecie Przedmiotu');
      Writeln('3: Zakoncz');
      Decyzja := readkey;
    until (Ord(Decyzja) >= 49) and (Ord(Decyzja) <= 51);
    case Decyzja of
      '1':
      begin
        DodanieNowegoPrzedmiotu(GlowaDanyChOsob);
        WyswietlenieOpcjiEdytowaniaPrzedmiotow;
      end;
      '2':
      begin
        if GlowaDanychOsob <> nil then
        begin
          UsunieciePrzedmiotu(GlowaDanychOsob);
          WyswietlenieOpcjiEdytowaniaPrzedmiotow;
        end
        else
        begin
          Writeln('Nie Mozna Usuwac Przedmiotow W Przypaku Braku Danych Osob');
          readkey;
          WyswietlenieOpcjiEdytowaniaPrzedmiotow;
        end;
      end;
      '3':
      begin
      end;
    end;
  end;

  procedure ZapisanieDanychDoLogowania(GlowaLog: WskListaDanychDoZalog);
  var
    pliklogin: file of DaneDoZalogowania;
  begin
    Assign(pliklogin, logintxt);
    Rewrite(pliklogin);
    if GlowaLog <> nil then
    begin
      while (GlowaLog^.prev <> nil) do
      begin
        GlowaLog := GlowaLog^.prev;
      end;
    end;
    while GlowaLog <> nil do
    begin
      Write(pliklogin, GlowaLog^.Log);
      GlowaLog := GlowaLog^.Next;
    end;
    Close(pliklogin);
    Writeln('Dane Do Logowania Zostaly Zapisane');
  end;

  procedure SprCzyPodanyLogIstnieje(sprlogin: string; GlowaLog: WskListaDanychDoZalog;
  var Istnieje: boolean);
  begin
    Istnieje := False;
    while GlowaLog <> nil do
    begin
      if GlowaLog^.Log.Login = sprlogin then
      begin
        Istnieje := True;
        Writeln('Podany Login Istnieje, Podaj Inny');
        Break;
      end;
      GlowaLog := GlowaLog^.Prev;
    end;
  end;

  procedure Logowanie;
  var
    pliklogin: file of DaneDoZalogowania;
    SprawdzanyRekord: DaneDoZalogowania;
    PodanyLogin: string;
    PodaneHaslo: string;
  begin
    clrscr;
    Assign(pliklogin, logintxt);
    repeat
      begin
        Reset(pliklogin);
        Writeln('Podaj Login');
        Readln(PodanyLogin);
        Writeln('Podaj Haslo');
        Readln(PodaneHaslo);
        while not EOF(pliklogin) do
        begin
          Read(pliklogin, SprawdzanyRekord);
          if PodanyLogin = SprawdzanyRekord.Login then
          begin
            if PodaneHaslo = SprawdzanyRekord.haslo then
            begin
              Uprawnienie := SprawdzanyRekord.upr;
              if Uprawnienie = 2 then
              begin
                NumerUcznia := SprawdzanyRekord.Id;
                Break;
              end;
              if Uprawnienie = 1 then
              begin
                Break;
              end;
            end
            else
            begin
              Uprawnienie := 0;
              Break;
            end;
          end;
        end;
        if Uprawnienie = 0 then
          Writeln('Podane Haslo Lub Login Jest Nieprawidlowe Lub Konto Nie Istenije');
      end;
    until Uprawnienie <> 0;
    Close(pliklogin);
  end;

  procedure DodanieDanychDoZalogowania(NrUcznia: integer; Imie: string;
    Nazwisko: string; UprawnienieDoDodania: integer;
  var GlowaLog: WskListaDanychDoZalog);
  var
    LogDoDodania: string;
    Istnieje: boolean;
    tmp: WskListaDanychDoZalog;
  begin
    istnieje := False;
    repeat
      Writeln('Podaj Login Do Zapisu');
      Readln(LogDoDodania);
      SprCzyPodanyLogIstnieje(LogDoDodania, GlowaDanychDoLog, Istnieje);
    until Istnieje = False;
    New(tmp);
    tmp^.Log.Login := LogDoDodania;
    Writeln('Podaj Haslo Do Zapisu');
    Readln(tmp^.log.Haslo);
    tmp^.Log.upr := UprawnienieDoDodania;
    if UprawnienieDoDodania = UprRodzica then
      tmp^.log.Id := NrUcznia
    else
      tmp^.log.Id := Id + 1;

    tmp^.Log.Imie := Imie;
    tmp^.Log.Nazwisko := Nazwisko;
    tmp^.Next := nil;
    GlowaLog^.Next := tmp;
    tmp^.prev := GlowaLog;
    GlowaLog := tmp;

    Writeln('Wcisnij Dowolny Klawisz');
    readkey;
    clrscr;
  end;

  procedure WybranieOceny(var wybor: integer);
  var
    Decyzja: char;
  begin
    repeat
      Writeln('Z czego Ocene Chcesz Dodac Lub Usunac Ocene?');
      Writeln('1: Sprawdzan');
      Writeln('2: Kartkowka');
      Writeln('3: Odpowiedz');
      Decyzja := readkey;
    until (Ord(Decyzja) >= 49) and (Ord(Decyzja) <= 51);
    case Decyzja of
      '1':
      begin
        Wybor := Sprawdzian;
      end;
      '2':
      begin
        Wybor := Kartkowka;
      end;
      '3':
      begin
        Wybor := Odpowiedz;
      end;
    end;
  end;

  procedure PodanieOcen(var Przedmiot: Oceny);
  var
    Wybor, znak: char;
    WartOceny: integer;
    IlOcen: byte;
    Ocena, i: integer;
    Usunieto: boolean;
  begin
    repeat
      Writeln('Co Zamierzasz Zrobic? ');
      Writeln('1: Dodanie Oceny Z Przedmiotu');
      Writeln('2: Usuniecie Oceny z Przedmiotu');
      Writeln('3: Zakoncz');
      Wybor := readkey;
    until (Ord(Wybor) >= 49) and (Ord(Wybor) <= 51);
    case Wybor of
      '1':
      begin
        WybranieOceny(WartOceny);
        Writeln('Podaj Ocene Ktora Chcesz Dodac 1-6');
        repeat
          znak := readkey;
        until (Ord(znak) >= 49) and (Ord(znak) <= 54);
        val(znak, Ocena);
        SetLength(Przedmiot, high(Przedmiot) + 3);
        IlOcen := Przedmiot[0];
        IlOcen := IlOcen + 2;
        Przedmiot[0] := IlOcen;
        Przedmiot[high(Przedmiot)] := Ocena;
        Przedmiot[high(Przedmiot) - 1] := WartOceny;
        Writeln('Dodano Ocene. Wcisnij Dowolny Klawisz');
        readkey;
        clrscr;
        PodanieOcen(Przedmiot);
      end;
      '2':
      begin
        Usunieto := False;
        WybranieOceny(WartOceny);
        Writeln('Podaj Ocene Ktora Chcesz Usunac 1-6');
        repeat
          znak := readkey;
        until (Ord(znak) >= 49) and (Ord(znak) <= 54);
        val(znak, Ocena);
        if (przedmiot[high(przedmiot)] = ocena) and
          (przedmiot[high(przedmiot) - 1] = WartOceny) then
        begin
          IlOcen := Przedmiot[0];
          IlOcen := IlOcen - 2;
          Przedmiot[0] := IlOcen;
          Setlength(Przedmiot, high(przedmiot) - 1);
          Usunieto := True;
        end;

        if Usunieto = False then
        begin
          i := 1;
          while i <= high(przedmiot) - 1 do
          begin
            if (przedmiot[i] = ocena) and (przedmiot[i - 1] = WartOceny) then
            begin
              Usunieto := True;
              IlOcen := Przedmiot[0];
              IlOcen := IlOcen - 2;
              Przedmiot[0] := IlOcen;
              while i <= high(przedmiot) - 1 do
              begin
                Przedmiot[i - 1] := Przedmiot[i + 1];
                Przedmiot[i] := Przedmiot[i + 2];
                i := i + 1;
              end;
              SetLength(Przedmiot, high(przedmiot) - 1);
              break;
            end;
            i := i + 1;
          end;
        end;
        if usunieto = True then
          writeln('Usunieto Ocene. Wcisnij Dowolny Klawisz')
        else
          writeln('Brak Oceny Do Usuniecia. Wcisnij Dowolny Klawisz');
        Readkey;
        clrscr;
        PodanieOcen(Przedmiot);
      end;
      '3':
      begin
      end;
    end;
  end;

  procedure PodanieDanychOsoby(var tmp: WskListaDanychOsob; var przerwano: boolean);
  var
    NrKlasy, LiteraKlasy, Decyzja: char;
    Klasa: string;
    i: integer;
  begin
    repeat
      Writeln('Podaj Imie');
      Readln(tmp^.Dosoby.DUcznia.Imie);
      repeat
        Writeln('Czy Chcesz Kontynuowac [T/N]');
        Writeln;
        Decyzja := readkey;
      until (Decyzja = 't') or (Decyzja = 'n');
      if decyzja = 'n' then
      begin
        Przerwano := True;
        Break;
      end;
      Writeln('Podaj Nazwisko');
      Readln(tmp^.Dosoby.DUcznia.Nazwisko);
      repeat
        Writeln('Czy Chcesz Kontynuowac [T/N]');
        Writeln;
        Decyzja := readkey;
      until (Decyzja = 't') or (Decyzja = 'n');
      if decyzja = 'n' then
      begin
        Przerwano := True;
        Break;
      end;
      repeat
        Writeln('Podaj Numer Klasy 1-4');
        NrKlasy := readkey;
      until (Ord(NrKlasy) >= 48) and (Ord(NrKlasy) <= 51);
      repeat
        Writeln('Podaj Znak Klasy a-z');
        LiteraKlasy := readkey;
      until (Ord(LiteraKlasy) >= 61) and (Ord(LiteraKlasy) <= 122);
      Klasa := NrKlasy + LiteraKlasy;
      tmp^.Dosoby.DUcznia.Klasa := Klasa;
      repeat
        Writeln('Czy Chcesz Kontynuowac [T/N]');
        Writeln;
        Decyzja := readkey;
      until (Decyzja = 't') or (Decyzja = 'n');
      if decyzja = 'n' then
      begin
        Przerwano := True;
        Break;
      end;
    until (Decyzja = 'n') or (Decyzja = 't');

    if decyzja <> 'n' then
    begin
      OdczytaniePrzedmiotowZPliku(tmp^.Dosoby.OcenyZPrzed);
      for i := 0 to High(tmp^.Dosoby.OcenyZPrzed) do
      begin
        ClrScr;
        Writeln('Podanie Ocen Z ', tmp^.Dosoby.OcenyZPrzed[i].NazwaPrzedmiotu, ':');
        SetLength(tmp^.Dosoby.OcenyZPrzed[i].Oceny, 1);
        tmp^.Dosoby.OcenyZPrzed[i].Oceny[0] := 0;
        PodanieOcen(tmp^.Dosoby.OcenyZPrzed[i].Oceny);
      end;
    end;
  end;

  procedure DodanieOsobyDoListy(var GlowaOsob: WskListaDanychOsob);
  var
    tmp: WskListaDanychOsob;
    Przerwano: boolean;
  begin
    Przerwano := False;
    clrscr;
    if GlowaOsob = nil then
    begin
      New(tmp);
      PodanieDanychOsoby(tmp, przerwano);
      if Przerwano = False then
      begin
        Id := Id + 1;
        tmp^.Dosoby.DUcznia.Id := Id;
        tmp^.Next := nil;
        tmp^.prev := nil;
        GlowaOsob := tmp;
      end
      else
        Dispose(tmp);
    end
    else
    begin
      New(tmp);
      PodanieDanychOsoby(tmp, przerwano);
      if Przerwano = False then
      begin
        Id := Id + 1;
        tmp^.Dosoby.DUcznia.Id := Id;
        tmp^.Next := nil;
        GlowaOsob^.Next := tmp;
        tmp^.prev := GlowaOsob;
        GlowaOsob := tmp;
      end
      else
        dispose(tmp);
    end;

    if przerwano = False then
      DodanieDanychDoZalogowania(ID, tmp^.Dosoby.DUcznia.Imie,
        tmp^.Dosoby.DUcznia.Nazwisko, UprRodzica, GlowaDanychDoLog);
  end;

  procedure WypisanieOcen(Przedmiot: Oceny);
  var
    IlOcen, i: integer;
  begin
    Write('Oceny Z Przedmiotu: ');
    IlOcen := Przedmiot[0];
    for i := 1 to IlOcen do
    begin
      case przedmiot[i] of
        7: Write(' Spr:');
        8: Write(' Kart:');
        9: Write(' Odp:');
        else
          Write(' ', Przedmiot[i]);
      end;
    end;
  end;

  procedure WypisanieDanychOsoby(DaneUcznia: DaneOsoby);
  var
    i: integer;
  begin
    Writeln('ID:', DaneUcznia.DUcznia.Id);
    Writeln('Imie: ', DaneUcznia.DUcznia.Imie);
    Writeln('Nazwisko ', DaneUcznia.DUcznia.Nazwisko);
    writeln('Klasa ', DaneUcznia.DUcznia.Klasa);
    for i := 0 to high(DaneUcznia.OcenyZPrzed) do
    begin
      if DaneUcznia.OcenyZPrzed[i].Oceny[0] <> 0 then
      begin
        Writeln('Oceny Z ', DaneUcznia.OcenyZPrzed[i].NazwaPrzedmiotu, ':');
        WypisanieOcen(DaneUcznia.OcenyZPrzed[i].Oceny);
        writeln;
      end;
    end;
  end;

  procedure WypisanieDanychZListy(GlowaOsob: WskListaDanychOsob);
  var
    Decyzja: char;
  begin
    if GlowaOsob = nil then
      Writeln('Brak Danych Do Wypisania')
    else
    begin
      while GlowaOsob <> nil do
      begin
        WypisanieDanychOsoby(GlowaOsob^.Dosoby);
        GlowaOsob := GlowaOsob^.Prev;
        Writeln('Wcisnij Klawisz');
        Writeln;
        Writeln('Aby Zakonczyc Przegladanie Wcisnij "p"');
        Decyzja := readkey;
        if decyzja = 'p' then
          break;
      end;
    end;
  end;

  procedure ZapisanieDanychOsobDoPliku(GlowaOsob: WskListaDanychOsob);
  var
    PlikDziennik: file of DaneUcznia;
    PlikOceny: Text;
    i, y: integer;
  begin
    Assign(plikdziennik, Dziennik);
    Rewrite(plikdziennik);
    Assign(PlikOceny, OcenyTxt);
    Rewrite(PlikOCeny);
    if GlowaOsob <> nil then
    begin
      while (GlowaOsob^.prev <> nil) do
      begin
        GlowaOsob := GlowaOsob^.prev;
      end;
    end;
    while GlowaOsob <> nil do
    begin
      Write(plikdziennik, GlowaOsob^.Dosoby.DUcznia);
      for i := 0 to high(GlowaOsob^.Dosoby.OcenyZPrzed) do
      begin
        for y := 0 to high(GlowaOsob^.Dosoby.OcenyZPrzed[i].Oceny) do
          writeln(PlikOceny, GlowaOsob^.Dosoby.OcenyZPrzed[i].Oceny[y]);
      end;
      GlowaOsob := GlowaOsob^.Next;
    end;
    Close(plikdziennik);
    Close(PlikOceny);
    Writeln('Dane Osob Zostaly Zapisane');
  end;

  procedure OdczytanieDanychOsobZPliku(var GlowaOsob: WskListaDanychOsob);
  var
    PlikDziennik: file of DaneUcznia;
    PlikOceny: Text;
    tmp: WskListaDanychOsob;
    IloscOcen, Ocena, i, y: integer;
  begin
    Assign(plikdziennik, Dziennik);
    Reset(plikdziennik);
    Assign(PlikOceny, OcenyTxt);
    Reset(PlikOceny);
    while not EOF(plikdziennik) do
    begin
      if GlowaOsob = nil then
      begin
        New(tmp);
        Read(plikdziennik, tmp^.Dosoby.DUcznia);
        OdczytaniePrzedmiotowZPliku(tmp^.Dosoby.OcenyZPrzed);
        for i := 0 to high(tmp^.Dosoby.OcenyZPrzed) do
        begin
          Read(PlikOceny, IloscOcen);
          SetLength(tmp^.Dosoby.OcenyZPrzed[i].Oceny, IloscOcen + 1);
          tmp^.Dosoby.OcenyZPrzed[i].Oceny[0] := IloscOcen;
          for y := 1 to IloscOcen do
          begin
            Read(PlikOceny, Ocena);
            tmp^.Dosoby.OcenyZPrzed[i].Oceny[y] := Ocena;
          end;
        end;

        tmp^.Next := nil;
        tmp^.prev := nil;
        GlowaOsob := tmp;
      end
      else
      begin
        New(tmp);
        Read(plikdziennik, tmp^.Dosoby.DUcznia);
        OdczytaniePrzedmiotowZPliku(tmp^.Dosoby.OcenyZPrzed);
        for i := 0 to high(tmp^.Dosoby.OcenyZPrzed) do
        begin
          Read(PlikOceny, IloscOcen);
          SetLength(tmp^.Dosoby.OcenyZPrzed[i].Oceny, IloscOcen + 1);
          tmp^.Dosoby.OcenyZPrzed[i].Oceny[0] := IloscOcen;
          for y := 1 to IloscOcen do
          begin
            Read(PlikOceny, Ocena);
            tmp^.Dosoby.OcenyZPrzed[i].Oceny[y] := Ocena;
          end;
        end;

        tmp^.Next := nil;
        tmp^.prev := GlowaOsob;
        GlowaOsob^.Next := tmp;
        GlowaOsob := tmp;
      end;
    end;
    Close(plikdziennik);
    Close(PlikOceny);
    if GlowaOsob = nil then
      Writeln('Brak Danych W Pliku');
  end;

  procedure UtworzenieKontaAdministratora;
  var
    pliklogin: file of DaneDoZalogowania;
    Admin: DaneDoZalogowania;
  begin
    Assign(pliklogin, logintxt);
    Reset(pliklogin);
    Seek(pliklogin, FileSize(pliklogin));
    Admin.Login := 'admin';
    Writeln('Podaj Haslo Dla Administratora');
    Readln(Admin.Haslo);
    Admin.Id := 1;
    Admin.upr := UprAdmina;
    Write(pliklogin, admin);
    Close(pliklogin);
  end;

  procedure OdczytanieDanychDoLogowania(var GlowaLog: WskListaDanychDoZalog);
  var
    pliklogin: file of DaneDoZalogowania;
    tmp: WskListaDanychDoZalog;
    MaxId: integer;
  begin
    MaxId := 0;
    repeat
      Assign(pliklogin, logintxt);
      Reset(pliklogin);
      while not EOF(pliklogin) do
      begin
        if GlowaLog = nil then
        begin
          New(tmp);
          Read(pliklogin, tmp^.Log);
          tmp^.Next := nil;
          tmp^.prev := nil;
          GlowaLog := tmp;
        end
        else
        begin
          New(tmp);
          Read(pliklogin, tmp^.log);
          tmp^.Next := nil;
          tmp^.prev := GlowaLog;
          GlowaLog^.Next := tmp;
          GlowaLog := tmp;
        end;
        if MaxId < GlowaLog^.Log.Id then
          MaxId := GlowaLog^.Log.Id;
      end;
      Close(pliklogin);
      if GlowaLog = nil then
      begin
        Writeln('Zadne konto nie zostalo jeszcze utworzone, zostanie utworzone konto o loginie admin');
        UtworzenieKontaAdministratora;
      end;
    until GlowaLog <> nil;
    Id := GlowaLog^.Log.Id;
  end;

  procedure UsuniecieDanychDoZalog(NrDoUsuniecia: integer;
  var GlowaLog: WskListaDanychDoZalog);
  var
    tmp: WskListaDanychDoZalog;
    usunieto: boolean;
  begin
    usunieto := False;
    while GlowaLog^.prev <> nil do
    begin
      GlowaLog := GlowaLog^.prev;
    end;
    while GlowaLog <> nil do
    begin
      if (GlowaLog^.Log.Id = NrDoUsuniecia) then
      begin
        usunieto := True;
        New(tmp);
        tmp := GlowaLog;
        if GlowaLog^.Prev = nil then
        begin
          GlowaLog^.Next^.Prev := nil;
        end;
        if GlowaLog^.Next = nil then
        begin
          GlowaLog^.Prev^.Next := nil;
        end;
        if (GlowaLog^.Next <> nil) and (GlowaLog^.Prev <> nil) then
        begin
          GlowaLog^.prev^.Next := GlowaLog^.Next;
          GlowaLog^.Next^.prev := GlowaLog^.prev;
        end;
      end;
      if GlowaLog^.Next = nil then
      begin
        GlowaLog := GlowaLog^.Prev;
        break;
      end;
      GlowaLog := GlowaLog^.Next;
    end;

    if usunieto = True then
    begin
      Dispose(tmp);
      Writeln('Dane Usunieto. Wcisnij Dowolny Klawisz');
    end
    else
      writeln('Brak Danych Do Usuniecia. Wcisnij Dowolny Klawisz');
    readkey;
  end;

  procedure UsuniecieOsobyZListy(NrDoUsuniecia: integer;
  var GlowaOsob: WskListaDanychOsob);
  var
    wsk: WskListaDanychOsob;
    Usunieto: boolean;
  begin
    Usunieto := False;
    if (GlowaOsob^.Next = nil) and (GlowaOsob^.prev = nil) then
    begin
      if (GlowaOsob^.Dosoby.DUcznia.Id = NrDoUsuniecia) then
      begin
        New(wsk);
        wsk := GlowaOsob;
        GlowaOsob := nil;
        usunieto := True;
      end;
    end
    else
    begin
      while GlowaOsob^.prev <> nil do
      begin
        GlowaOsob := GlowaOsob^.prev;
      end;
      while GlowaOsob <> nil do
      begin
        if (GlowaOsob^.Dosoby.DUcznia.Id = NrDoUsuniecia) then
        begin
          usunieto := True;
          New(wsk);
          wsk := GlowaOsob;
          if GlowaOsob^.Prev = nil then
          begin
            GlowaOsob^.Next^.Prev := nil;
          end;
          if GlowaOsob^.Next = nil then
          begin
            GlowaOsob^.Prev^.Next := nil;
          end;
          if (GlowaOsob^.Next <> nil) and (GlowaOsob^.Prev <> nil) then
          begin
            GlowaOsob^.prev^.Next := GlowaOsob^.Next;
            GlowaOsob^.Next^.prev := GlowaOsob^.prev;
          end;
        end;
        if GlowaOsob^.Next = nil then
        begin
          GlowaOsob := GlowaOsob^.Prev;
          break;
        end;
        GlowaOsob := GlowaOsob^.Next;
      end;
    end;
    if usunieto = False then
    begin
      Writeln('brak danych spelniajacych kryteria, zadne dane nie zostaly usuniete');
      Delay(2000);
    end
    else
    begin
      UsuniecieDanychDoZalog(NrDoUsuniecia, GlowaDanychDoLog);
      Dispose(wsk);
    end;
  end;

  procedure PodanieNowychDanych(var DaneDoEdycji: DaneOsoby;
  var DaneDoLog: DaneDoZalogowania);
  var
    Wybor: char;
    i: integer;
  begin
    clrscr;
    Writeln('1: Edytuj Imie');
    Writeln('2: Edytuj Nazwisko');
    Writeln('3: Edytowanie Ocen');
    Writeln('4: Wypisz Dane');
    Writeln('5: Zakoncz Edycje danych');
    repeat
      wybor := readkey;
    until (Ord(Wybor) >= 49) or (Ord(Wybor) <= 53);
    case Wybor of
      '1':
      begin
        Writeln('Podaj Nowe Imie:');
        Readln(DaneDoEdycji.DUcznia.Imie);
        DanedoLog.Imie := DaneDoEdycji.DUcznia.Imie;
        PodanieNowychDanych(DaneDoEdycji, DaneDoLog);
      end;
      '2':
      begin
        Writeln('Podaj Nowe Nazwisko');
        Readln(DaneDoEdycji.DUcznia.Nazwisko);
        DaneDoLog.Nazwisko := DaneDoEdycji.DUcznia.Nazwisko;
        PodanieNowychDanych(DaneDoEdycji, DaneDoLog);
      end;
      '3':
      begin
        for i := 0 to high(DaneDoEdycji.OcenyZPrzed) do
        begin
          repeat
            Writeln('Czy chcesz Edytowac ',
              DaneDoEdycji.OcenyZPrzed[i].NazwaPrzedmiotu, ' ?');
            Writeln('[t/n]');
            Wybor := readkey;
          until (Wybor = 't') or (Wybor = 'n');
          if wybor = 't' then
            PodanieOcen(DaneDoEdycji.OcenyZPrzed[i].Oceny);
        end;
        PodanieNowychDanych(DaneDoEdycji, DaneDoLog);
      end;
      '4':
      begin
        WypisanieDanychOsoby(DaneDoEdycji);
        Writeln('Wcisnij Dowolny Klawisz');
        readkey;
        PodanieNowychDanych(DaneDoEdycji, DaneDoLog);
      end;
      '5':
      begin
      end;
    end;
  end;

  procedure SzukOsobySpelWarunek(nrdoedycji: integer; var GlowaOsob: WskListaDanychOsob;
    GlowaLog: WskListaDanychDoZalog);
  var
    Zmieniono: boolean;
  begin
    Zmieniono := False;
    while GlowaLog <> nil do
    begin
      if GlowaLog^.Log.Id = nrdoedycji then
      begin
        if GlowaOsob = nil then
          Writeln('brak danych do edycji')
        else
        begin
          while GlowaOsob <> nil do
          begin
            if GlowaOsob^.Dosoby.DUcznia.Id = nrdoedycji then
            begin
              PodanieNowychDanych(GlowaOsob^.Dosoby, GlowaLog^.Log);
              zmieniono := True;
            end;
            if GlowaOsob^.Prev = nil then
              Break;
            GlowaOsob := GlowaOsob^.prev;
          end;
          while GlowaOsob^.Next <> nil do
          begin
            GlowaOsob := GlowaOsob^.Next;
          end;
        end;
      end;
      if GlowaLog^.prev = nil then
        Break;
      GlowaLog := GlowaLog^.prev;
    end;

    while GlowaLog^.Next <> nil do
    begin
      GlowaLog := GlowaLog^.Next;
    end;
    if zmieniono = False then
      Writeln('Uczen Nie Istnieje Lub Jego Konto Do Logowania Zostalo Usuniete');
    Writeln('Wcisnij dowolny klawisz');
    readkey;
  end;

  procedure PodanieNowychDanychDoLogowania(var DaneDoEdycji: DaneDoZalogowania);
  var
    Wybor: char;
    Istnieje: boolean;
    login: string;
  begin
    clrscr;
    Writeln('1: Edytuj Login');
    Writeln('2: Edytuj Haslo');
    Writeln('3: Edytuj Imie');
    writeln('4: Edytuj Nazwisko');
    Writeln('5: Zakoncz Edycje danych');
    repeat
      Wybor := readkey;
    until (Ord(Wybor) >= 49) or (Ord(Wybor) <= 53);
    case Wybor of
      '1':
      begin
        Istnieje := False;
        Writeln('Podaj Nowy Login:');
        repeat
          Readln(login);
          SprCzyPodanyLogIstnieje(Login, GlowaDanychDoLog, Istnieje);
        until Istnieje = False;
        DaneDoEdycji.Login := login;
        PodanieNowychDanychDoLogowania(DaneDoEdycji);
      end;
      '2':
      begin
        Writeln('Podaj Nowe Haslo');
        Readln(DaneDoEdycji.Haslo);
        PodanieNowychDanychDoLogowania(DaneDoEdycji);
      end;
      '3':
      begin
        Writeln('Podaj Nowe Imie');
        Readln(DaneDoEdycji.Imie);
        PodanieNowychDanychDoLogowania(DaneDoEdycji);
      end;
      '4':
      begin
        Writeln('Podaj Nowe Nazwisko');
        Readln(DaneDoEdycji.Nazwisko);
        PodanieNowychDanychDoLogowania(DaneDoEdycji);
      end;
      '5':
      begin
      end;
    end;
  end;

  procedure EdytowanieDanychDoLogowania(login: string;
  var GlowaLog: WskListaDanychDoZalog);
  var
    zmieniono: boolean;
  begin
    Zmieniono := False;
    if GlowaLog = nil then
      Writeln('brak danych logowania do edycji');
    while GlowaLog <> nil do
    begin
      if GlowaLog^.Log.Login = Login then
      begin
        PodanieNowychDanychDoLogowania(GlowaLog^.Log);
        zmieniono := True;
      end;
      if GlowaLog^.prev = nil then
        Break;
      GlowaLog := GlowaLog^.prev;
    end;
    if zmieniono = False then
      Writeln('brak osoby spelniajacej warunek');
    Writeln('Wcisnij dowolny klawisz');
    readkey;

    while GlowaLog^.Next <> nil do
    begin
      GlowaLog := GlowaLog^.Next;
    end;
  end;

  procedure EdytowanieAlboUsowanie(NrUczniaDoEdycji: integer);
  var
    decyzja: char;
  begin
    Writeln('Jesli chcesz Edytowac to konto wcisnij "t"');
    Writeln('Jesli chcesz Usunac to konto wcisnij "u"');
    Writeln('Jesli chcesz Kontynuowac wcisnij inny klawisz');
    Decyzja := readkey;
    if Decyzja = 'u' then
      UsuniecieOsobyZListy(NrUczniaDoEdycji, GlowaDanychOsob);
    if Decyzja = 't' then
      SzukOsobySpelWarunek(NrUczniaDoEdycji, GlowaDanychOsob, GlowaDanychDoLog);
  end;

  procedure WyszukiwanieOsob(WyszukiwanyTekst: string; SprawdzanyTekst: string;
  var Znaleziono: boolean);
  var
    i: integer;
  begin
    Znaleziono := False;
    if Length(SprawdzanyTekst) >= Length(WyszukiwanyTekst) then
    begin
      i := 0;
      while i < length(WyszukiwanyTekst) do
      begin
        i := i + 1;
        if SprawdzanyTekst[i] = WyszukiwanyTekst[i] then
        begin
          znaleziono := True;
        end
        else
        begin
          znaleziono := False;
          break;
        end;
      end;
    end;
  end;

  procedure WyswietlenieMenuWyszukiwania(GlowaOsob: WskListaDanychOsob);
  var
    Wybor, znak: char;
    WyszukiwanyTekst: string;
    WyszukiwanyNumerUcznia: integer;
    Znaleziono: boolean;
  begin
    ClrScr;
    Writeln('Co zamierzasz zrobic:');
    Writeln('1: Wyszukaj Podajac Imie Ucznia');
    Writeln('2: Wyszukaj Podajac Nazwisko Ucznia');
    Writeln('3: Wyszukaj Podajac ID Ucznia');
    Writeln('4: Wyszukaj Podajac Klase');
    Writeln('5: Zakoncz');
    repeat
      wybor := readkey;
    until (Ord(wybor) >= 49) and (Ord(wybor) <= 53);
    case wybor of
      '1':
      begin
        Znaleziono := False;
        Writeln('Podaj tekst');
        Readln(WyszukiwanyTekst);
        while GlowaOsob <> nil do
        begin
          WyszukiwanieOsob(WyszukiwanyTekst, GlowaOsob^.Dosoby.DUcznia.Imie, Znaleziono);
          if znaleziono = True then
          begin
            WypisanieDanychOsoby(GlowaOsob^.Dosoby);
            EdytowanieAlboUsowanie(GlowaOsob^.Dosoby.DUcznia.Id);
          end;
          GlowaOsob := GlowaOsob^.Prev;
        end;
        if Znaleziono = False then
        begin
          writeln('Brak Danych Do Wyswietlenia. Wcisnij Dowolny Klawisz');
          readkey;
        end;

        WyswietlenieMenuWyszukiwania(GlowaDanychOsob);
      end;
      '2':
      begin
        Znaleziono := False;
        Writeln('Podaj tekst');
        Readln(WyszukiwanyTekst);
        while GlowaOsob <> nil do
        begin
          WyszukiwanieOsob(WyszukiwanyTekst, GlowaOsob^.Dosoby.DUcznia.Nazwisko,
            Znaleziono);
          if znaleziono = True then
          begin
            WypisanieDanychOsoby(GlowaOsob^.Dosoby);
            EdytowanieAlboUsowanie(GlowaOsob^.Dosoby.DUcznia.Id);
          end;
          GlowaOsob := GlowaOsob^.Prev;
        end;
        if Znaleziono = False then
        begin
          writeln('Brak Danych. Wcisnij Dowolny Klawisz');
          readkey;
        end;

        WyswietlenieMenuWyszukiwania(GlowaDanychOsob);

      end;
      '3':
      begin
        Writeln('Podaj Id');
        repeat
          znak := readkey;
          if (znak > chr(47)) and (znak < chr(58)) then
          begin
            WyszukiwanyTekst := WyszukiwanyTekst + znak;
            Write(znak);
          end;
        until znak = chr(13);
        val(WyszukiwanyTekst, WyszukiwanyNumerUcznia);
        while GlowaOsob <> nil do
        begin
          if GlowaOsob^.Dosoby.DUcznia.Id = WyszukiwanyNumerUcznia then
          begin
            WypisanieDanychOsoby(GlowaOsob^.Dosoby);
            EdytowanieAlboUsowanie(GlowaOsob^.Dosoby.DUcznia.Id);
          end;
          GlowaOsob := GlowaOsob^.Prev;
        end;
        WyswietlenieMenuWyszukiwania(GlowaDanychOsob);
      end;
      '4':
      begin
        Znaleziono := False;
        Writeln('Podaj tekst');
        Readln(WyszukiwanyTekst);
        while GlowaOsob <> nil do
        begin
          WyszukiwanieOsob(WyszukiwanyTekst, GlowaOsob^.Dosoby.DUcznia.Klasa,
            Znaleziono);
          if znaleziono = True then
          begin
            WypisanieDanychOsoby(GlowaOsob^.Dosoby);
            EdytowanieAlboUsowanie(GlowaOsob^.Dosoby.DUcznia.Id);
          end;
          GlowaOsob := GlowaOsob^.Prev;
        end;
        if Znaleziono = False then
        begin
          writeln('Brak Danych. Wcisnij Dowolny Klawisz');
          readkey;;
        end;
        WyswietlenieMenuWyszukiwania(GlowaDanychOsob);
      end;
      '5':
      begin
        clrscr;
      end;
    end;
  end;

  procedure EdytowanieLubUsuwanieDanychDoLog(var KontoDoEdycji: DaneDoZalogowania);
  var
    Decyzja: char;
  begin
    Writeln;
    Writeln('Jesli chcesz usunac konto wcisnij u');
    Writeln('Jesli chcesz edytowac konto wcisnij e');
    writeln('Jesli chcesz kontynuowac, wcisnij inny klawisz');
    Decyzja := readkey;
    if Decyzja = 'u' then
      UsuniecieDanychDoZalog(KontoDoEdycji.Id, GlowaDanychDoLog);
    if Decyzja = 'e' then
      EdytowanieDanychDoLogowania(KontoDoEdycji.Login, GlowaDanychDoLog);
    Writeln;
  end;

  procedure WypisanieDanychDoLogowania(upr: integer; GlowaLog: WskListaDanychDoZalog);
  var
    Decyzja: char;
  begin
    while GlowaLog <> nil do
    begin
      if (upr <> UprAdmina) and ((GlowaLog^.Log.Login = 'admin') or
        (GlowaLog^.Log.upr = UprNauczyciela)) then
        Writeln('Login: ', GlowaLog^.Log.Login)
      else
      begin
        Writeln('Login: ', GlowaLog^.Log.Login);
        Writeln('Haslo: ', GlowaLog^.log.Haslo);
      end;
      if GlowaLog^.log.upr = UprRodzica then
        Writeln('Uprawnienie dla rodzica');
      if GlowaLog^.log.upr = UprNauczyciela then
        Writeln('Uprawnienie dla nauczyciela');
      if GlowaLog^.log.upr = UprAdmina then
        Writeln('Uprawnienie administratora');
      Writeln('Id: ', GlowaLog^.log.Id);
      Writeln('Imie Wlasciciela: ', GlowaLog^.Log.Imie);
      Writeln('Nazwisko Wlasciciela: ', GlowaLog^.Log.Nazwisko);
      Writeln;
      EdytowanieLubUsuwanieDanychDoLog(GlowaLog^.Log);
      writeln;
      Writeln('Aby Przerwac wcisnij "p"');
      Decyzja := readkey;
      if Decyzja = 'p' then
        break;
      GlowaLog := GlowaLog^.prev;
    end;
  end;

  procedure WyswietlenieMenuAdministratora;
  var
    NrDoZmiany, NrUcznia: integer;
    Decyzja, Wybor, znak: char;
    Imie, Nazwisko, login, NrUczniaStr: string;
  begin
    clrscr;
    repeat
      Writeln('Co zamierzasz zrobic');
      Writeln('1:  Wypisz Dane Uczniow');
      Writeln('2:  Dodaj Ucznia');
      Writeln('3:  Wypisz Dane Do Logowania');
      Writeln('4:  Dodaj Konto Nauczyciela');
      Writeln('5:  Wyszukaj');
      Writeln('6:  Edytuj Dane Do Logowania');
      Writeln('7:  Usun Konto');
      Writeln('8:  Dodaj Konto Rodzica');
      Writeln('9:  Edycja Przedmiotow');
      Writeln('0:  Wyloguj');
      Wybor := readkey;
    until (Ord(Wybor) >= 48) and (Ord(Wybor) <= 57);

    case Wybor of
      '1':
      begin
        clrscr;
        WypisanieDanychZListy(GlowaDanychOsob);
        WyswietlenieMenuAdministratora;
      end;
      '2':
      begin
        clrscr;
        repeat
          DodanieOsobyDoListy(GlowaDanychOsob);
          Writeln('Czy chcesz dodac kolejna osobe [t/n]');
          repeat
            Decyzja := readkey;
          until (Decyzja = 't') or (Decyzja = 'n');
        until Decyzja = 'n';
        WyswietlenieMenuAdministratora;
      end;
      '3':
      begin
        clrscr;
        WypisanieDanychDoLogowania(Uprawnienie, GlowaDanychDoLog);
        WyswietlenieMenuAdministratora;
      end;
      '4':
      begin
        ClrScr;
        repeat
          Writeln('Podaj Imie Nauczyciela');
          Readln(Imie);
          Writeln('Podaj Nazwisko Nauczyciela');
          Readln(Nazwisko);
          DodanieDanychDoZalogowania(ID, Imie, Nazwisko, UprNauczyciela,
            GlowaDanychDoLog);
          Writeln('Czy chcesz dodac kolejna osobe [t/n]');
          repeat
            Decyzja := readkey;
          until (Decyzja = 't') or (Decyzja = 'n');
        until Decyzja = 'n';
        ZapisanieDanychDoLogowania(GlowaDanychDoLog);
        WyswietlenieMenuAdministratora;
      end;
      '5':
      begin
        ClrScr;
        WyswietlenieMenuWyszukiwania(GlowaDanychOsob);
        WyswietlenieMenuAdministratora;
      end;
      '6':
      begin
        ClrScr;
        Writeln('Podaj Login dla ktorego chcesz dokonac modyfikacji');
        Readln(login);
        EdytowanieDanychDoLogowania(login, GlowaDanychDoLog);
        WyswietlenieMenuAdministratora;
      end;
      '7':
      begin
        ClrScr;
        Writeln('Podaj Id Konta Do Usuniecia');
        repeat
          Readln(NrDoZmiany);
          if NrDoZmiany = 1 then
            Writeln('Nie Mozna Usunac Konta Administratora');
        until NrDoZmiany <> 1;
        UsuniecieDanychDoZalog(NrDoZmiany, GlowaDanychDoLog);
        WyswietlenieMenuAdministratora;
      end;
      '8':
      begin
        ClrScr;
        Writeln('Podaj Imie Ucznia');
        Readln(Imie);
        Writeln('Podaj Nazwisko Ucznia');
        Readln(Nazwisko);
        Writeln('Podaj Numer Ucznia');
        repeat
          znak := readkey;
          if (znak > chr(47)) and (znak < chr(58)) then
          begin
            NrUczniaStr := NrUczniaStr + znak;
            Write(znak);
          end;
        until znak = chr(13);
        val(NrUczniaStr, NrUcznia);
        Writeln;
        DodanieDanychDoZalogowania(NrUcznia, Imie, Nazwisko, UprRodzica,
          GlowaDanychDoLog);
        WyswietlenieMenuAdministratora;
      end;
      '9':
      begin
        ClrScr;
        WyswietlenieOpcjiEdytowaniaPrzedmiotow;
        WyswietlenieMenuAdministratora;
      end;
      '0':
      begin
        ClrScr;
        ZapisanieDanychOsobDoPliku(GlowaDanychOsob);
        ZapisanieDanychDoLogowania(GlowaDanychDoLog);
        Writeln('Zapisano Dane');
        Uprawnienie := 0;
      end;
    end;
  end;

  procedure WyswietlenieMenuDlaNauczyciela;
  var
    Decyzja, Wybor: char;
  begin
    clrscr;
    repeat
      Writeln('Co Zamierzasz Zrobic');
      Writeln('1: Wypisz Dane Uczniow');
      Writeln('2: Dodaj Ucznia');
      Writeln('3: Wypisz Dane Do Logowania');
      Writeln('4: Wyszukaj');
      Writeln('5: Wyloguj');
      Wybor := readkey;
    until (Ord(Wybor) >= 49) and (Ord(Wybor) <= 53);
    case Wybor of
      '1':
      begin
        clrscr;
        WypisanieDanychZListy(GlowaDanychOsob);
        WyswietlenieMenuDlaNauczyciela;
      end;
      '2':
      begin
        clrscr;
        repeat
          DodanieOsobyDoListy(GlowaDanychOsob);
          Writeln('Czy chcesz dodac kolejna osobe [t/n]');
          repeat
            Decyzja := readkey;
          until (Decyzja = 't') or (Decyzja = 'n');
        until Decyzja = 'n';
        WyswietlenieMenuDlaNauczyciela;
      end;
      '3':
      begin
        clrscr;
        WypisanieDanychDoLogowania(Uprawnienie, GlowaDanychDoLog);
        WyswietlenieMenuDlaNauczyciela;
      end;
      '4':
      begin
        ClrScr;
        WyswietlenieMenuWyszukiwania(GlowaDanychOsob);
        WyswietlenieMenuAdministratora;
      end;
      '5':
      begin
        ClrScr;
        ZapisanieDanychOsobDoPliku(GlowaDanychOsob);
        ZapisanieDanychDoLogowania(GlowaDanychDoLog);
        Uprawnienie := 0;
      end;
    end;
  end;

  procedure WyswietlenieMenuDlaRodzica(GlowaOsob: WskListaDanychOsob;
    NumerUcznia: integer);
  var
    Wybor: char;
    znaleziono: boolean;
  begin
    clrscr;
    znaleziono := False;
    Writeln('Co chcesz zrobic ?');
    Writeln('1: Wyswietl dane ucznia');
    Writeln('2: Wyloguj');
    repeat
      Wybor := readkey;
    until (Ord(wybor) >= 49) or (Ord(Wybor) <= 50);
    case Wybor of
      '1':
      begin
        clrscr;
        while GlowaOsob <> nil do
        begin
          if GlowaOsob^.Dosoby.DUcznia.Id = NumerUcznia then
          begin
            WypisanieDanychOsoby(GlowaOsob^.Dosoby);
            Writeln;
            znaleziono := True;
          end;
          GlowaOsob := GlowaOsob^.prev;
        end;
        if znaleziono = False then
          Writeln('nie znaleziono danych ucznia');
        readkey;
        WyswietlenieMenuDlaRodzica(GlowaDanychOsob, NumerUcznia);
      end;
      '2':
      begin
        Uprawnienie := 0;
      end;
    end;
  end;

  procedure WybranieMenu(Uprawnienie: integer);
  begin
    clrscr;
    if Uprawnienie = UprNauczyciela then
      WyswietlenieMenuDlaNauczyciela;
    if Uprawnienie = UprRodzica then
      WyswietlenieMenuDlaRodzica(GlowaDanychOsob, NumerUcznia);
    if Uprawnienie = UprAdmina then
      WyswietlenieMenuAdministratora;
  end;

  procedure ZwolnieniePamieci;
  var
    tmpL: WskListaDanychDoZalog;
    tmpD: WskListaDanychOsob;
  begin
    while GlowaDanychOsob <> nil do
    begin
      New(tmpD);
      if GlowaDanychOsob^.prev = nil then
      begin
        tmpD := GlowaDanychOsob;
        GlowaDanychOsob := nil;
        Dispose(tmpD);
      end
      else
      begin
        GlowaDanychOsob := GlowaDanychOsob^.Prev;
        tmpD := GlowaDanychOsob^.Next;
        Dispose(tmpD);
      end;
    end;
    while GlowaDanychDoLog <> nil do
    begin
      New(tmpL);
      if GlowaDanychDoLog^.prev = nil then
      begin
        tmpL := GlowaDanychDoLog;
        GlowaDanychDoLog := nil;
        Dispose(tmpL);
      end
      else
      begin
        GlowaDanychDoLog := GlowaDanychDoLog^.Prev;
        tmpL := GlowaDanychDoLog^.Next;
        Dispose(tmpL);
      end;
    end;
  end;

begin
  clrscr;
  GlowaDanychOsob := nil;
  GlowaDanychDoLog := nil;
  OdczytanieDanychDoLogowania(GlowaDanychDoLog);
  OdczytanieDanychOsobZPliku(GlowaDanychOsob);
  repeat
    logowanie;
    WybranieMenu(Uprawnienie);
    Writeln('Jesli chcesz zalogowac sie ponownie wcisnij T');
  until readkey <> 't';
  ZwolnieniePamieci;
end.

