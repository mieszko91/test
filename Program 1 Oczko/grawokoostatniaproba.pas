Program gra_w_oczko;
uses crt;
type
  m1=array[1..13] of string;
  m2=array[1..2,1..13] of integer;
var
  znak:char;
  i,j,wynik1,wynik2,ilk1,ilk2,n,los:integer;
  tab1:m1;
  tab2:m2;
function uzupeln1(var tab1:m1):integer;   //wypeˆnienie tablicy z nazwami kart
  begin
    tab1[1]:='as';   tab1[2]:='2';   tab1[3]:='3';      tab1[4]:='4';
    tab1[5]:='5';    tab1[6]:='6';   tab1[7]:='7';      tab1[8]:='8';
    tab1[9]:='9';    tab1[10]:='10'; tab1[11]:='walet'; tab1[12]:='dama';
    tab1[13]:='kr¢l';
  end;

function uzupeln2(var tab2:m2):integer;     //tablica z wartoscia i iloscia kart
   begin
        for j:=1 to 13 do
        tab2[1,j]:=j;
        for j:=1 to 13 do
        tab2[2,j]:=4;
   end;
function wypisz(var tab2:m2):integer;  //wypisanie tablic
  begin
    for i:=1 to 2 do
      begin
        for j:=1 to 13 do
          begin
            write(tab2[i,j],' ');
          end;
        writeln;
      end;
  end;
function losuj(var los:integer):integer;    //losowanie wartosci oraz sprawdzenie czy dana wartosc moze zostac podana
  begin
      repeat
        los:=random(13)+1;
      until tab2[2,los]<>0;
  writeln('Wylosowana karta to  ',tab1[los],' ','wartosc wylosowanej karty to  ',tab2[1,los]);
  end;
procedure ilpkt(var wynik:integer); //zliczanie ilosci punktow
  begin
    wynik:=wynik+tab2[1,los];
    tab2[2,los]:=tab2[2,los]-1; //mniejsza ilosc kart
  end;
begin
  clrscr;
  randomize;
  uzupeln1(tab1);
  uzupeln2(tab2);

      repeat           //gracz dobiera karty, pierwsze losowanie niezalezne od gracza
      textcolor(yellow);
      losuj(los);
      ilpkt(wynik1);
      textcolor(green);
      writeln('Twoj wynik to',wynik1);
        if wynik1>=21 then break;
          textcolor(yellow);
          writeln('czy dobierasz karte, jesli tak wcisniej t, jesli nie wcisnj dowolny klawisz');
          readln(znak);
      until ((wynik1>=21) or (znak<>'t')); //gracz dobiera do momentu az zadecyduje o przerwaniu lub ilosc pkt przekroczy 21
      repeat    //komputer dobiera karty
        begin
          ilk1:=0;     //ilosc kart ktore nie przekrocza po wylosowaniu wartosci 21
          ilk2:=0;     //ilosc kart ktore po wylosowaniu przekrocza wartosci 21
          textcolor(red);
          losuj(los);
          ilpkt(wynik2);
          writeln('ilosc punktow przeciwnka to',wynik2);
          if wynik2>=21 then break;
          if wynik2>8 then   //  sprawdzenie czy wynik komp jest wiekszy od 8, jesli nie to kolejne losowanie nie przekroczy 21
          begin
          n:=21-wynik2;
            for i:=1 to n do
              ilk1:=ilk1+tab2[2,i]; //zliczanie kart ktore nie przekrocza 21
            for i:=n+1 to 13 do
              ilk2:=ilk2+tab2[2,i];  // zliczanie kart ktore przekrocza 21
            if ilk1<ilk2 then break; // sprawdzanie prawdopodobienstwa przekroczenia 21
            end;
          end;
      until wynik2>21;
      textcolor(lightred);  //warunki zwyciestwa
      if ((wynik1>21) and (wynik2>21)) then
        writeln('gracz i komputer przegrali');
      if ((wynik1=21) and (wynik2=21)) then
        writeln('remis');
      if ((wynik1<21) and (wynik2<21) and (wynik1=wynik2)) then
        writeln('remis');
      if ((wynik1<21) and (wynik2<21) and (wynik1>wynik2)) then
        writeln('gracz wygral');
      if ((wynik1<21) and (wynik2<21) and (wynik2>wynik1)) then
        writeln('komputer wygral');
      if ((wynik1=21) and (wynik2<>21)) then
        writeln('gracz wygral');
      if ((wynik2=21) and (wynik1<>21)) then
        writeln('gracz przegral');
      if ((wynik1>21) and (wynik2<21)) then
        writeln('gracz przegral');
      if ((wynik1<21) and (wynik2>21)) then
        writeln('gracz wygral');



  readln;

end.
