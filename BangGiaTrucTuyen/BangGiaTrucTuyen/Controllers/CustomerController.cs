using Customer.Hubs;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Customer.Controllers
{
    public class CustomerController : Controller
    {
        // GET: Customer
        public ActionResult Index()
        {
            return View();
        }

        public JsonResult Get()
        {

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["CustomerConnection"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand(@"SELECT [id],[giaban1],[giaban2],[giaban3],[giakl],[giamua1]
      ,[giamua2],[giamua3],[klban1],[klban2],[klban3],[klkl],[klmua1],[klmua2],[klmua3],[tongkl] FROM [chuyendecnpm].[dbo].[banggiatructuyen]", connection))
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
                                giaban1 = (Double)x["giaban1"],
                                giaban2 = (Double)x["giaban2"],
                                giaban3 = (Double)x["giaban3"],
                                giakl = (Double)x["giakl"],
                                giamua1 = (Double)x["giamua1"],
                                giamua2 = (Double)x["giamua2"],
                                giamua3 = (Double)x["giamua3"],
                                klban1 = (Double)x["klban1"],
                                klban2 = (Double)x["klban2"],
                                klban3 = (Double)x["klban3"],
                                klkl = (Double)x["klkl"],
                                klmua1 = (Double)x["klmua1"],
                                klmua2 = (Double)x["klmua2"],
                                klmua3 = (Double)x["klmua3"],
                                tongkl = (Double)x["tongkl"],
                            }).ToList();

                    return Json(new { listCus = listCus }, JsonRequestBehavior.AllowGet);

                }
            }
        }

        private void dependency_OnChange(object sender, SqlNotificationEventArgs e)
        {
            CusHub.Show();
        }
    }
}