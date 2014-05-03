using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Wypozyczalnia.View
{
    public partial class ReservationsView : Wypozyczalnia.View.BaseView
    {
        public ReservationsView()
        {
            InitializeComponent();
        }


        public override void SetColumnsWidth()
        {
            try
            {
                double width = dataGridView1.Width - 20;
                dataGridView1.Columns[0].Width = (int)(0.1 * width);
                dataGridView1.Columns[1].Width = (int)(0.15 * width);
                dataGridView1.Columns[2].Width = (int)(0.15 * width);
                dataGridView1.Columns[3].Width = (int)(0.15 * width);
                dataGridView1.Columns[4].Width = (int)(0.15 * width);
                dataGridView1.Columns[5].Width = (int)(0.15 * width);
                dataGridView1.Columns[6].Width = (int)(0.15 * width);
                dataGridView1.Columns[7].Width = (int)(0.15 * width);
            }
            catch (ArgumentOutOfRangeException ex)
            {

            }
        }

        public string FilterSurname
        {
            get { return filterSurname.Text; }
        }

        private void ActionAdd(object sender, EventArgs e)
        {

        }

        private void ActionEdit(object sender, EventArgs e)
        {

        }

        private void ActionDelete(object sender, EventArgs e)
        {

        }

        private void ActionResized(object sender, EventArgs e)
        {
            SetColumns();
        }

        private void ActionSearchBySurname(object sender, EventArgs e)
        {
            controller.SearchReservationsBySurname();
        }
    }
}
