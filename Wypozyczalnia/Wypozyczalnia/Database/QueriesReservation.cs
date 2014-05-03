using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Wypozyczalnia.Database
{
    class QueriesReservation
    {
        WypozyczalniaDataClassesDataContext db;

        public QueriesReservation()
        {
            db = new WypozyczalniaDataClassesDataContext();
        }

        public QueriesReservation(WypozyczalniaDataClassesDataContext dbContext)
        {
            db = dbContext;
        }

        public DataTable SelectAll()
        {
            var query = from r in db.Rezerwacjas
                        join c in db.Klients on r.Klient_Klient_ID equals c.Klient_ID
                        join s in db.Stateks on r.Statek_Statek_ID equals s.Statek_ID
                        join t in db.Typ_statkus on s.Typ_statku_Typ_statku_ID equals t.Typ_statku_ID
                        join p in db.pilotujes on r.Statek_Statek_ID equals p.Rezerwacja_Rezerwacja_ID
                        join e in db.Pracowniks on p.Pracownik_Pracownik_ID equals e.Pracownik_ID

                        select new
                        {
                            r.Rezerwacja_ID,
                            Imie_Klienta = c.Imię,
                            Nazwisko_Klienta = c.Nazwisko,
                            Pracownik_Nazwisko = e.Nazwisko,
                            Typ_Statku = t.Nazwa_typu,
                            Cena_za_dobe = s.Cena_za_dobę,
                            r.Data_wypożyczenia,
                            r.Data_zwrotu
                        };

            DataTable dt = Extensions.ToDataTable(query);
            return dt;
        }

        public DataTable SelectBySurname(string surname)
        {

            var query = from r in db.Rezerwacjas
                        join c in db.Klients on r.Klient_Klient_ID equals c.Klient_ID
                        join s in db.Stateks on r.Statek_Statek_ID equals s.Statek_ID
                        join t in db.Typ_statkus on s.Typ_statku_Typ_statku_ID equals t.Typ_statku_ID
                        join p in db.pilotujes on r.Statek_Statek_ID equals p.Rezerwacja_Rezerwacja_ID
                        join e in db.Pracowniks on p.Pracownik_Pracownik_ID equals e.Pracownik_ID
                        where c.Nazwisko == surname
                        select new
                        {
                            r.Rezerwacja_ID,
                            Imie_Klienta = c.Imię,
                            Nazwisko_Klienta = c.Nazwisko,
                            Pracownik_Nazwisko = e.Nazwisko,
                            Typ_Statku = t.Nazwa_typu,
                            Cena_za_dobe = s.Cena_za_dobę,
                            r.Data_wypożyczenia,
                            r.Data_zwrotu
                        };

            DataTable dt = Extensions.ToDataTable(query);
            return dt;
        }

        public DataTable SelectById(int id)
        {

            var query = from r in db.Rezerwacjas
                        join c in db.Klients on r.Klient_Klient_ID equals c.Klient_ID
                        join s in db.Stateks on r.Statek_Statek_ID equals s.Statek_ID
                        join t in db.Typ_statkus on s.Typ_statku_Typ_statku_ID equals t.Typ_statku_ID
                        join p in db.pilotujes on r.Statek_Statek_ID equals p.Rezerwacja_Rezerwacja_ID
                        join e in db.Pracowniks on p.Pracownik_Pracownik_ID equals e.Pracownik_ID
                        where r.Klient_Klient_ID == id
                        select new
                        {
                            r.Rezerwacja_ID,
                            Imie_Klienta = c.Imię,
                            Nazwisko_Klienta = c.Nazwisko,
                            Pracownik_Nazwisko = e.Nazwisko,
                            Typ_Statku = t.Nazwa_typu,
                            Cena_za_dobe = s.Cena_za_dobę,
                            r.Data_wypożyczenia,
                            r.Data_zwrotu
                        };

            DataTable dt = Extensions.ToDataTable(query);
            return dt;
        }
    }
}
