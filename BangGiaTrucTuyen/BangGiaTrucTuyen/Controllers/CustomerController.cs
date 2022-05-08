using Customer.Hubs;
using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;

namespace Customer.Controllers
{
    public class CustomerController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public JsonResult Get()
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
            {
                connection.Open();
                String sql = "SELECT [id],[giaban1],[giaban2],[giaban3],[giakl],[giamua1],"+
                    "[giamua2],[giamua3],[klban1],[klban2],[klban3],[klkl],[klmua1]," +
                    "[klmua2],[klmua3],[tongkl] FROM [chuyendecnpm].[dbo].[banggiatructuyen]";
                using (SqlCommand command = new SqlCommand(@sql, connection))
                {
                    command.Notification = null;
                    SqlDependency dependency = new SqlDependency(command);
                    dependency.OnChange += new OnChangeEventHandler(dependency_OnChange);
                    if (connection.State == ConnectionState.Closed)
                        connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    var listCus = reader.Cast<IDataRecord>()
                            .Select(x => new
                            {
                                id = (string)x["id"],
                                giaban1 = SafeGetDouble(reader, 1),
                                giaban2 = SafeGetDouble(reader, 2),
                                giaban3 = SafeGetDouble(reader, 3),
                                giakl = SafeGetDouble(reader, 4),
                                giamua1 = SafeGetDouble(reader, 5),
                                giamua2 = SafeGetDouble(reader, 6),
                                giamua3 = SafeGetDouble(reader, 7),
                                klban1 = SafeGetDouble(reader, 8),
                                klban2 = SafeGetDouble(reader, 9),
                                klban3 = SafeGetDouble(reader, 10),
                                klkl = SafeGetDouble(reader, 11),
                                klmua1 = SafeGetDouble(reader, 12),
                                klmua2 = SafeGetDouble(reader, 13),
                                klmua3 = SafeGetDouble(reader, 14),
                                tongkl = SafeGetDouble(reader, 15),
                            }).ToList();
                    return Json(new { listCus = listCus }, JsonRequestBehavior.AllowGet);
                }
            }
        }

        public String SafeGetDouble(SqlDataReader reader, int colIndex)
        {
            if (!reader.IsDBNull(colIndex))
                return reader.GetDouble(colIndex).ToString();
            return "";
        }

        private void dependency_OnChange(object sender, SqlNotificationEventArgs e)
        {
            CusHub.Show();
        }
    }
}